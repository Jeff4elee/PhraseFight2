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

  void lerpPos(Position p2, num f) {
    x = lerp(x, p2.x, f);
    y = lerp(y, p2.y, f);
  }

  num lerp(num a, num b, num f) => a + f * (b - a);
}
