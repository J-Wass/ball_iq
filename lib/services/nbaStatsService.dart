// Dart imports:
import 'dart:convert';
import 'dart:developer';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:ball_iq/common/constants.dart';
import 'package:ball_iq/state/state.dart';

/// Encapsulation of data needed to construct a single scoreboard item.
class Scoreboard {
  bool isFinished = false;
  String timeString = "";
  String team1 = "";
  String team1Score = "";
  String team1Id = "";
  String team2 = "";
  String team2Score = "";
  String team2Id = "";
  String gameId = "";

  Scoreboard(this.isFinished, this.timeString, this.team1, this.team1Score,
      this.team1Id, this.team2, this.team2Score, this.team2Id, this.gameId);
}

// Represents a stat name, and the regex used to search for.
class Stat {
  String statName = "";
  String statRegex = "";

  Stat(this.statName, this.statRegex);
}

/// Encapsulation of stats for a player in a game.
class PlayerBoxScore {
  String gameId = "";
  String playerId = "";
  String playername = "";
  String teamId = "";
  String teamCity = "";
  String position = "";
  int points = 0;
  int assists = 0;
  int rebounds = 0;
  double fieldGoalPercent = 0.0;

  PlayerBoxScore(
      this.gameId,
      this.playerId,
      this.playername,
      this.teamId,
      this.teamCity,
      this.position,
      this.points,
      this.assists,
      this.rebounds,
      this.fieldGoalPercent);
}

/// Makes an HTTP GET request through the server proxy.
Future<Response> _getRequest(String url) async {
  Uri formattedUri = Uri.parse(_formattedUrl(url, true));

  // Headers required for the proxy server to accept http requests.
  final Map<String, String> proxyHeaders = {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Credentials": "true",
    "Access-Control-Allow-Headers": "*",
    "Access-Control-Allow-Methods": "GET"
  };
  return http.get(formattedUri, headers: proxyHeaders);
}

/// Takes a url and returns it for use in the server proxy.
String _formattedUrl(String url, bool useStatsNbaHeaders) {
  String escapedUrl = Uri.encodeQueryComponent(url);
  String route = useStatsNbaHeaders ? "proxy" : "proxy/headerless";

  // No idea, but I need to add "25" after every escape???
  escapedUrl = escapedUrl.replaceAll("%", "%25");
  return 'http://localhost:5000/${route}/$escapedUrl';
}

/// Returns a url pointing to an image file for a given team name.
String teamImageUrl(String teamId) {
  return "assets/teams/$teamId.png";
}

String playerImageUrl(String playerId) {
  return _formattedUrl(
      "cdn.nba.com/headshots/nba/latest/1040x760/${playerId}.png", false);
}

Future<Response> _nbaStatsResponse(
    String endpoint, Map<String, String> queryParams) {
  List components = [];
  queryParams.forEach((query, value) {
    components.add('$query=$value');
  });
  String finalUrl = 'stats.nba.com/stats/$endpoint?${components.join('&')}';
  return _getRequest(finalUrl);
}

Future<List<PlayerBoxScore>> playerData(String gameId) async {
  if (gameId.isEmpty) {
    return [];
  }

  Response response = await _nbaStatsResponse('boxscoretraditionalv2', {
    'GameID': gameId,
    'StartPeriod': '0',
    'EndPeriod': '0',
    'RangeType': '0',
    'EndRange': '0',
    'StartRange': '0',
  });

  List<PlayerBoxScore> players = [];

  // Get all result sets from endpoint, break into a dict.
  Map blob = json.decode(response.body);

  // Break results into player & team sets.
  Map resultSets = {};
  for (Map rSet in blob["resultSets"]) {
    resultSets[rSet['name']] = rSet;
  }

  // Headers are [GAME_ID, TEAM_ID, TEAM_ABBREVIATION, TEAM_CITY, PLAYER_ID, PLAYER_NAME, NICKNAME, START_POSITION, COMMENT, MIN, FGM, FGA, FG_PCT, FG3M, FG3A, FG3_PCT, FTM, FTA, FT_PCT, OREB, DREB, REB, AST, STL, BLK, TO, PF, PTS, PLUS_MINUS]
  List player_jsons = resultSets["PlayerStats"]["rowSet"];
  for (List player in player_jsons) {
    players.add(PlayerBoxScore(
        gameId,
        player[4].toString(),
        player[5] ?? "",
        player[1].toString(),
        player[3].toString(),
        player[7] ?? "",
        player[27] ?? 0,
        player[22] ?? 0,
        player[14] ?? 0,
        player[12] ?? 0.0));
  }

  return players;
}

/// Returns gamedata for the specified date time.
Future<List<Scoreboard>> gameData(DateTime dt) async {
  String selectedDateString = '${dt.year}-${dt.month}-${dt.day}';
  Response response = await _nbaStatsResponse('scoreboardv2', {
    'DayOffset': '0',
    'LeagueID': '00',
    'GameDate': selectedDateString,
  });

  List<Scoreboard> scoreboards = [];

  // Get all result sets from endpoint, break into a dict.
  Map blob = json.decode(response.body);
  Map resultSets = {};
  for (Map rSet in blob["resultSets"]) {
    resultSets[rSet['name']] = rSet;
  }

  if (resultSets["LineScore"]['rowSet'].length == 0) {
    return [];
  }

  // stats.nba returns each team's scoreline as an element of one long list for the day.
  List results = resultSets["LineScore"]['rowSet'];
  for (int i = 0; i < results.length / 2; i++) {
    // headers: [GAME_DATE_EST, GAME_SEQUENCE, GAME_ID, TEAM_ID, TEAM_ABBREVIATION, TEAM_CITY_NAME, TEAM_NAME, TEAM_WINS_LOSSES, PTS_QTR1, PTS_QTR2, PTS_QTR3, PTS_QTR4, PTS_OT1, PTS_OT2, PTS_OT3, PTS_OT4, PTS_OT5, PTS_OT6, PTS_OT7, PTS_OT8, PTS_OT9, PTS_OT10, PTS, FG_PCT, FT_PCT, FG3_PCT, AST, REB, TOV]
    List team1 = resultSets["LineScore"]['rowSet'][i * 2];
    List team2 = resultSets["LineScore"]['rowSet'][i * 2 + 1];

    // headers: [GAME_DATE_EST, GAME_SEQUENCE, GAME_ID, GAME_STATUS_ID, GAME_STATUS_TEXT, GAMECODE, HOME_TEAM_ID, VISITOR_TEAM_ID, SEASON, LIVE_PERIOD, LIVE_PC_TIME, NATL_TV_BROADCASTER_ABBREVIATION, HOME_TV_BROADCASTER_ABBREVIATION, AWAY_TV_BROADCASTER_ABBREVIATION, LIVE_PERIOD_TIME_BCAST, ARENA_NAME, WH_STATUS, WNBA_COMMISSIONER_FLAG]
    List gameStats = resultSets["GameHeader"]['rowSet'][i];

    scoreboards.add(Scoreboard(
        gameStats[4] == 'Final',
        gameStats[4].toString(),
        team1[5].toString(),
        team1[22].toString(),
        team1[3].toString(),
        team2[5].toString(),
        team2[22].toString(),
        team2[3].toString(),
        gameStats[2].toString()));
  }

  return scoreboards;
}
