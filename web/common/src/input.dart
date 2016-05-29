part of common;

class Input extends JsonAble {
  final String playerUuid;
  final int pressTime;
  final int inputSequenceNumber;
  final List<int> keyCodes;

  Input(
      this.playerUuid, this.pressTime, this.inputSequenceNumber, this.keyCodes);

  Input.fromJson(List json)
      : playerUuid = json[0],
        pressTime = json[1],
        inputSequenceNumber = json[2],
        keyCodes = json[3] {}

  @override
  List toJson() => [playerUuid, pressTime, inputSequenceNumber, keyCodes];
}
