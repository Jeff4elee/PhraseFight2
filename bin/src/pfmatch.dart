part of server;

class PFMatch {
  static const int maxPlayers = 2;

  List<Player> players;

  Timer timer;
  Stopwatch watch;

  static const int maxSamples = 100;
  int tickIndex = 0;
  num tickSum = 0;
  List<num> tickList;

  num averageDelta = 0;

  final ForceServer fs;
  final String matchId;

  List<Input> inputs;

  Map<String, Entity> entities = {};
  Map<String, int> lastProcessedInput = {};

  PFMatch(this.fs, this.matchId) {
    players = new List();
    watch = new Stopwatch();
    inputs = new List();
    tickList = new List.filled(maxSamples, 0);
  }

  bool isFull() => players.length == maxPlayers;

  void start() {
    if (timer == null) {
      timer = new Timer.periodic(const Duration(milliseconds: 16), loop);
    }
  }

  void loop(Timer timer) {
    watch.stop();

    num delta = watch.elapsedMilliseconds;

    watch.reset();
    watch.start();

    averageDelta = getAverageDelta(delta);

    processInputs();
    sendWorldState();
    updateWorld();
  }

  void processInputs() {
    while (inputs.length > 0) {
      Input input = inputs.removeAt(0);

      if (validateInput(input)) {
        String id = input.playerUuid;
        entities[id].applyInput(input);
        lastProcessedInput[id] = input.inputSequenceNumber;
      }
    }
  }

  bool validateInput(Input input) {
    return true;

    // TODO
    if (input.pressTime.abs() > 1 / 40) {
      return false;
    }
    return true;
  }

  void sendWorldState() {
    List worldState = new List();

    for (int i = 0; i < entities.length; i++) {
      Entity entity = entities.values.elementAt(i);
      EntityState state = new EntityState(entities.keys.elementAt(i),
          entity.position, lastProcessedInput[entities.keys.elementAt(i)]);

      worldState.add(state.toJson());
    }

    fs.send('${matchId} state', worldState);
  }

  void updateWorld() {
    // TODO logic here
  }

  num getAverageDelta(num newTick) {
    tickSum -= tickList[tickIndex];
    tickSum += newTick;
    tickList[tickIndex] = newTick;
    if (++tickIndex == maxSamples) {
      tickIndex = 0;
    }

    return tickSum / maxSamples;
  }

  void stop() {
    if (timer != null) {
      timer.cancel();
    }
  }

  void playerDisconnected(String playerUuid) {
    print('player disconnected: $playerUuid');
    stop();

    players.removeWhere((p) => p.uuid == playerUuid);
  }
}
