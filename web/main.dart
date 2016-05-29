// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html' hide Client;
import 'dart:js' as js;

import 'package:force/force_browser.dart';

import 'client.dart';
import 'common/common.dart';

void main() {
  ForceClient fc = new ForceClient();
  fc.connect();

  fc.onConnected.listen((_) {
    print('connected');
  });

  fc.onDisconnected.listen((_) {
    print("disconnected!");
  });

  fc.on('join match successful', (mp, _) {
    SessionData sessionData = new SessionData.fromJson(mp.json);

    fc.initProfileInfo(
        {'playerUuid': sessionData.playerUuid, 'matchId': sessionData.matchId});

    print('joined match: ${sessionData.matchId}');

    MatchIdUtil.setUrl(sessionData.matchId);

    querySelector('#waiting-screen').style.visibility = 'visible';
    (querySelector('#link-holder') as InputElement).value = Uri.base.toString();

    querySelector('#login').remove();
    toast('Joined match');

    fc.on('${sessionData.matchId} start', (mp, _) {
      querySelector('#waiting-screen').remove();
      List<Player> lobby = new List();

      for (int i = 0; i < mp.json.length; i++) {
        Player player = new Player.fromJson(mp.json[i]);
        lobby.add(player);
      }

      print('starting with lobby: $lobby');

      Client client = new Client(fc, sessionData, lobby);

      fc.on('${sessionData.matchId} state', (mp, sender) {
        List<EntityState> entityStates = new List();
        for (int i = 0; i < mp.json.length; i++) {
          EntityState eS = new EntityState.fromJson(mp.json[i]);
          entityStates.add(eS);
        }
        client.messages.add(entityStates);
      });

      client.start();
    });
  });

  querySelector('#join').onClick.listen((_) {
    InputElement nameField = querySelector('#name');

    String name = nameField.value.trim();
    if (name.isEmpty) {
      toast('Name must be specified!');
      return;
    }

    LoginData loginData = new LoginData(MatchIdUtil.getExistingMatchId(), name);
    fc.send('join match', loginData.toJson());
  });
}

void toast(String message, {int duration: 2500}) =>
    js.context['Materialize'].callMethod('toast', [message, duration]);
