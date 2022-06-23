// ignore_for_file: unnecessary_brace_in_string_interps

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:ball_iq/common/constants.dart';
import 'package:ball_iq/services/nbaStatsService.dart';

/*
**  This file uses provider to manage state.
**  Provider allows us to update state and have it immediately take affect.
**  Writing to state: context.read<MyStateClass>().set()
**  Listening to state: context.watch<MyStateClass>().property
*/

/// Stores a datetime.
class DateSelect with ChangeNotifier, DiagnosticableTreeMixin {
  String _datetimeToString(DateTime dt) {
    String month = months[dt.month].toString();
    String day = dt.day.toString();
    return '${month} ${day}';
  }

  DateTime _datetime = DateTime.now();
  DateTime get datetime => _datetime;

  String? _shortDateTime =
      '${months[DateTime.now().month]} ${DateTime.now().day}';
  String? get shortDateTime => _shortDateTime;

  void set(DateTime dt) {
    _datetime = dt;
    _shortDateTime = _datetimeToString(dt);
    notifyListeners();
  }
}

/// Stores a string that the front page tool selection should be filtered by.
class ToolFilter with ChangeNotifier, DiagnosticableTreeMixin {
  String? _filter;
  String? get filter => _filter;

  void set(String filter) {
    _filter = filter;
    notifyListeners();
  }
}

/// Stores a list of scoreboard items to display in the frontpage
class FrontPageScoreboardState with ChangeNotifier, DiagnosticableTreeMixin {
  List<Scoreboard>? _scoreboard;
  List<Scoreboard>? get scoreboard => _scoreboard;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Sets whether the scoreboard is loading.
  void markIsLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  /// Sets the scoreboard data for the app.
  void set(List<Scoreboard> scoreboard, [bool isLoading = false]) {
    _scoreboard = scoreboard;
    _isLoading = isLoading;
    notifyListeners();
    _isLoading = isLoading;
  }
}

/// Stores the selected player for making a montage.
class MontagePlayer with ChangeNotifier, DiagnosticableTreeMixin {
  String _playerId = "";
  String get playerId => _playerId;

  String _playerName = "";
  String get playerName => _playerName;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Sets whether the scoreboard is loading.
  void markIsLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void set(String playerId, String playerName, [bool isLoading = false]) {
    _playerId = playerId;
    _playerName = playerName;
    _isLoading = isLoading;
    notifyListeners();
  }
}

/// Stores the selected game for making a montage.
class MontageGame with ChangeNotifier, DiagnosticableTreeMixin {
  String _gameId = "";
  String get gameId => _gameId;

  List<PlayerBoxScore> _players = [];
  List<PlayerBoxScore> get players => _players;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Sets whether the scoreboard is loading.
  void markIsLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void set(String gameId, List<PlayerBoxScore> players,
      [bool isLoading = false]) {
    _gameId = gameId;
    _players = players;
    _isLoading = isLoading;
    notifyListeners();
  }
}

/// Stores the selected stat for making a montage.
class MontageStat with ChangeNotifier, DiagnosticableTreeMixin {
  Stat? _stat = null;
  Stat? get stat => _stat;

  void set(Stat stat) {
    _stat = stat;
    notifyListeners();
  }
}
