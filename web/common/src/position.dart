part of common;

class Position extends JsonAble {
  num x;
  num y;

  Position(this.x, this.y);

  Position.fromJson(List json)
      : x = json[0],
        y = json[1] {}

  @override
  List toJson() => [x, y];
}
