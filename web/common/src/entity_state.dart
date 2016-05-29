part of common;

class EntityState extends JsonAble {
  final String entityId;
  final Position position;
  final int lastProcessedInputNumber;

  EntityState(this.entityId, this.position, this.lastProcessedInputNumber);

  EntityState.fromJson(List json)
      : entityId = json[0],
        position = new Position.fromJson(json[1]),
        lastProcessedInputNumber = json[2] {}

  @override
  List toJson() => [entityId, position.toJson(), lastProcessedInputNumber];
}
