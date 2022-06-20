import 'dart:math';

import 'package:ball_iq/components/datePicker.dart';
import 'package:ball_iq/services/nbaStatsService.dart';
import 'package:flutter/material.dart';
import 'package:ball_iq/components/scoreBoard.dart';

import 'package:ball_iq/common/constants.dart';
import 'package:ball_iq/state/state.dart';
import 'package:provider/provider.dart';

// Represents a specific game that can be selected for a montage.
class IndividualGameSelection extends StatelessWidget {
  final Scoreboard scoreboard;
  const IndividualGameSelection({super.key, required this.scoreboard});

  @override
  Widget build(BuildContext context) {
    bool selected =
        scoreboard.gameId == Provider.of<MontageGame>(context).gameId;
    return Container(
      height: 130,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          border: Border.all(
              width: 0, color: selected ? themePrimary : Colors.transparent)),
      child: InkWell(
          focusColor: selected ? themePrimary : Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          splashColor: Color.fromARGB(
              120, themePrimary.red, themePrimary.green, themePrimary.blue),
          onTap: () {
            playerData(scoreboard.gameId).then((List<PlayerBoxScore> players) {
              context.read<MontageGame>().set(scoreboard.gameId, players);
            });
          },
          child: ScoreboardComponent(
            scoreboard: scoreboard,
          )),
    );
  }
}

/// Represents all the games that can be selected for a montage.
class GameSelection extends StatelessWidget {
  const GameSelection({super.key});

  @override
  Widget build(BuildContext context) {
    List<Scoreboard> scores =
        context.watch<FrontPageScoreboardState>().scoreboard ?? [];

    double target_width =
        min(MediaQuery.of(context).size.width - 20, scores.length * 300.0);

    return Container(
        height: 130.0,
        margin: EdgeInsets.only(bottom: 25),
        width: target_width,
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: scores.length,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          //shrinkWrap: true,
          itemBuilder: (_, int i) {
            return Container(
                margin: EdgeInsets.only(left: 5, right: 5),
                child: IndividualGameSelection(scoreboard: scores[i]));
          },
        ));
  }
}
