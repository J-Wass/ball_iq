import 'package:ball_iq/components/datePicker.dart';
import 'package:ball_iq/services/nbaStatsService.dart';
import 'package:flutter/material.dart';
import 'package:ball_iq/components/scoreBoard.dart';

import 'package:ball_iq/common/constants.dart';
import 'package:ball_iq/state/state.dart';
import 'package:provider/provider.dart';

// Represents a specific game that can be selected for a montage.
class IndividualPlayerSelection extends StatelessWidget {
  final PlayerBoxScore player;
  const IndividualPlayerSelection({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        splashColor: Color.fromARGB(
            120, themePrimary.red, themePrimary.green, themePrimary.blue),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
        onTap: () {},
        child: Text(player.playername));
  }
}

/// Represents all the games that can be selected for a montage.
class PlayerSelection extends StatelessWidget {
  const PlayerSelection({super.key});

  @override
  Widget build(BuildContext context) {
    List<PlayerBoxScore> playerBoxScores = context.watch<MontageGame>().players;

    return Container(
        height: 130.0,
        width: MediaQuery.of(context).size.width - 20,
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: playerBoxScores.length,
          scrollDirection: Axis.horizontal,
          //shrinkWrap: true,
          itemBuilder: (_, int i) {
            return Container(
                child: IndividualPlayerSelection(player: playerBoxScores[i]));
          },
        ));
  }
}
