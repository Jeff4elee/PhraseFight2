library server;

import 'package:force/force_serverside.dart';

import 'dart:math';
import 'dart:async';

import 'package:uuid/uuid.dart';

import '../web/common/common.dart';

part 'src/data/gfycat_match_names.dart';
part 'src/data/phrases.dart';
part 'src/phrase.dart';
part 'src/pfmatch.dart';

main() async {
  Map<String, PFMatch> matches = {};

  ForceServer fs = new ForceServer(
      host: 'localhost',
      port: 8080,
      clientFiles: '../web/',
      startPage: 'index.html');

  await fs.start();

  fs.on('join match', (mp, Sender sender) {
    LoginData loginData = new LoginData.fromJson(mp.json);
    String matchId = loginData.matchId;
    String name = loginData.username;

    if (matchId.isEmpty ||
        (matches.containsKey(matchId) && matches[matchId].isFull())) {
      matchId = GfycatMatchNames.getRandomMatchId();
    }

    // first player
    if (!matches.containsKey(matchId)) {
      matches[matchId] = new PFMatch(fs, matchId);
    }

    PFMatch match = matches[matchId];
    Player player = new Player(name, new Uuid().v1().toString());
    SessionData sessionData = new SessionData(matchId, player.uuid);

    match.players.add(player);

    sender.reply('join match successful', sessionData.toJson());

    // on last player
    if (match.players.length == PFMatch.maxPlayers) {
      List lobby = new List();

      for (Player p in match.players) {
        lobby.add(p.toJson());
        match.entities[p.uuid] = new Entity();
        match.lastProcessedInput[p.uuid] = 0;
      }

      fs.on('$matchId input', (mp, sender) {
        Input input = new Input.fromJson(mp.json);
        match.inputs.add(input);
      });

      match.start();

      print('start match: $matchId');
      fs.send('$matchId start', lobby);
    }
  });

  fs.onProfileChanged.listen((e) {
    if (e.type == ForceProfileType.Removed) {
      String matchId = e.profileInfo['matchId'];
      PFMatch match = matches[matchId];
      match.playerDisconnected(e.profileInfo['playerUuid']);
      if (match.players.isEmpty) {
        matches.remove(matchId);
        print('closing game: $matchId');
      }
    }
  });

  print('started server');
}
