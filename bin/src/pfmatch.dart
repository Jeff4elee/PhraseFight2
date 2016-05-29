part of server;

class PFMatch {
  static final int maxPlayers = 2;

  List<Player> players;

  Timer timer;
  Stopwatch watch;

  static final int maxSamples = 100;
  int tickIndex = 0;
  num tickSum = 0;
  List<num> tickList = new List.filled(maxSamples, 0);

  num fps = 0;

  final ForceServer fs;
  final String matchId;

  List<Input> inputs;

  Map<String, Entity> entities = {};
  Map<String, int> lastProcessedInput = {};


  PFMatch(this.fs, this.matchId) {
    players = new List();
    watch  = new Stopwatch();
    inputs = new List();
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

    fps = getAverageTick(delta);
    
    processInputs();
    sendWorldState();
    renderWorld();
  }

  void processInputs() {
    while(inputs.length > 0) {
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
    if (input.pressTime.abs() > 1/40) {
      return false;
    }
    return true;
  }

  void sendWorldState() {
    List worldState = new List();

    for (int i = 0; i < entities.length; i++) {
      Entity entity = entities.values.elementAt(i);
      EntityState state = new EntityState(entities.keys.elementAt(i), entity.position, lastProcessedInput[entities.keys.elementAt(i)]);

      worldState.add(state.toJson());
    }

    fs.send('${matchId} state', worldState);
  }

  void renderWorld() {
  }

  num getAverageTick(num newTick) {
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
