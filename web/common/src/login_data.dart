part of common;

class LoginData extends JsonAble {
  final String matchId;
  final String username;

  LoginData(this.matchId, this.username);

  LoginData.fromJson(List json)
      : matchId = json[0],
        username = json[1] {}

  @override
  List toJson() => [matchId, username];
}
