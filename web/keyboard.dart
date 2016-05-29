part of client;

class Keyboard {
  Map<int, bool> _keyDownMap = {};

  static final Keyboard _keyboard = new Keyboard._singleton();

  static Keyboard sharedInstance() => _keyboard;

  List<StreamSubscription> streamSubscriptions = new List();

  Keyboard._singleton() {
    document.onKeyDown.listen((e) {
      _keyDownMap[e.keyCode] = true;
    });
    document.onKeyUp.listen((e) {
      _keyDownMap[e.keyCode] = false;
    });
  }

  StreamSubscription onKeyDown(int keyCode, Function handleKeyDown) {
    StreamSubscription streamSubscription = document.onKeyDown.listen((e) {
      if (e.keyCode == keyCode) handleKeyDown();
    });
    streamSubscriptions.add(streamSubscription);
    return streamSubscription;
  }

  StreamSubscription onKeyUp(int keyCode, Function handleKeyUp) {
    StreamSubscription streamSubscription = document.onKeyUp.listen((e) {
      if (e.keyCode == keyCode) handleKeyUp();
    });
    streamSubscriptions.add(streamSubscription);
    return streamSubscription;
  }

  bool isKeyDown(int keyCode) {
    if (!_keyDownMap.containsKey(keyCode)) return false;
    return _keyDownMap[keyCode];
  }

  void removeAllStreamSubscriptions() {
    streamSubscriptions.forEach((e) => e.cancel());
    streamSubscriptions.clear();
  }
}
