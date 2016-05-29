part of common;

class SessionData extends JsonAble {
  final String matchId;
  final String playerUuid;

  SessionData(this.matchId, this.playerUuid);

  SessionData.fromJson(List json)
      : matchId = json[0],
        playerUuid = json[1] {}

  @override
  List toJson() => [matchId, playerUuid];
}
