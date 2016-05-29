part of server;

class Phrase extends JsonAble {
  final String phrase;
  final int points;

  Phrase(this.phrase, this.points);

  Phrase.fromJson(List json)
      : phrase = json[0],
        points = json[1] {}

  @override
  List toJson() => [phrase, points];
}
