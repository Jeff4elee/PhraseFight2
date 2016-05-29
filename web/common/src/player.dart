part of common;

class Player extends JsonAble {
  final String name;
  final String uuid;

  Player(this.name, this.uuid);

  Player.fromJson(List json)
      : name = json[0],
        uuid = json[1] {}

  @override
  List toJson() => [name, uuid];
}
