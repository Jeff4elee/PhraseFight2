library client;

import 'dart:html' hide KeyCode;
import 'dart:async';

import 'package:force/force_browser.dart';
import 'package:stagexl/stagexl.dart';

import 'common/common.dart';

part 'matchid_util.dart';
part 'keyboard.dart';

class Client {
  final ForceClient fc;
  final SessionData sessionData;

  int inputSequenceNumber = 0;
  List<Input> pendingInputs;

  Map<String, Entity> entities = {};

  List<List<EntityState>> messages;

  Timer timer;
  Stopwatch watch;

  static final int maxSamples = 100;
  int tickIndex = 0;
  num tickSum = 0;
  List<num> tickList = new List.filled(maxSamples, 0);

  num fps = 0;

  Stage stage;

  Client(this.fc, this.sessionData, List<Player> lobby) {
    pendingInputs = new List();
    messages = new List();
    watch = new Stopwatch();

    CanvasElement canvas = new CanvasElement(width: 800, height: 600);
    document.body.children.add(canvas);
    stage = new Stage(canvas);
    RenderLoop renderLoop = new RenderLoop();
    renderLoop.addStage(stage);

    for (Player player in lobby) {
      Entity entity = new Entity();
      entities[player.uuid] = entity;
      Shape shape = new Shape();
      shape.graphics.circle(0, 0, 50);
      shape.graphics.fillColor(Color.Red);
      entity.displayObject = shape;
      stage.addChild(entity.displayObject);
    }
  }

  void start() {
    print('start');
    if (timer == null) {
      timer =
          new Timer.periodic(const Duration(milliseconds: 16), (_) => update());
    }
  }

  void onPacket(packet) {
    messages.add(packet);
  }

  void update() {
    processServerMessages();

    processInputs();
    renderWorld();
  }

  void processServerMessages() {
    while (messages.length > 0) {
      List<EntityState> entityStates = messages.removeAt(0);
      for (int i = 0; i < entityStates.length; i++) {
        EntityState state = entityStates[i];
        Entity entity = entities[state.entityId];

        if (state.entityId == sessionData.playerUuid) {
          entity.position = state.position;

          int j = 0;
          while (j < pendingInputs.length) {
            Input input = pendingInputs[j];

            if (input.inputSequenceNumber <= state.lastProcessedInputNumber) {
              pendingInputs.removeAt(j);
            } else {
              entity.applyInput(input);
              j++;
            }
          }
        } else {
          // other stuff
          entity.position.x += state.position.x;
          entity.position.x /= 2;
          entity.displayObject.x = entity.position.x;
        }
      }
    }
  }

  void processInputs() {
    watch.stop();

    num delta = watch.elapsedMilliseconds;

    watch.reset();
    watch.start();

    fps = getAverageTick(delta);

    List<int> keycodes = new List();
    if (Keyboard.sharedInstance().isKeyDown(PFKeyCode.RIGHT)) {
      keycodes.add(PFKeyCode.RIGHT);
    }
    if (Keyboard.sharedInstance().isKeyDown(PFKeyCode.LEFT)) {
      keycodes.add(PFKeyCode.LEFT);
    }
    if (keycodes.isEmpty) {
      return;
    }

    Input input = new Input(sessionData.playerUuid, delta, inputSequenceNumber++, keycodes);

    fc.send('${sessionData.matchId} input', input.toJson());
    entities[sessionData.playerUuid].applyInput(input);

    pendingInputs.add(input);
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

  void renderWorld() {}
}
