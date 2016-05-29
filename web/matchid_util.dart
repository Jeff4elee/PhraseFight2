part of client;

class MatchIdUtil {
  static String getExistingMatchId() => Uri.base.query.trim();

  static void setUrl(String id) => window.history.pushState({}, "matchid", '?$id');
}