import 'dart:math';

import 'package:ball_iq/components/datePicker.dart';
import 'package:ball_iq/services/nbaStatsService.dart';
import 'package:flutter/material.dart';
import 'package:ball_iq/components/scoreBoard.dart';

import 'package:ball_iq/common/constants.dart';
import 'package:ball_iq/state/state.dart';
import 'package:provider/provider.dart';

// Represents a specific game that can be selected for a montage.
class MontageGameSelectWidget extends StatefulWidget {
  const MontageGameSelectWidget({super.key, required this.scoreboard});

  final Scoreboard scoreboard;

  @override
  _IndividualGameSelection createState() => _IndividualGameSelection();
}

class _IndividualGameSelection extends State<MontageGameSelectWidget> {
  bool _isHovering = false;

  void setIsHovering(isHovering) {
    setState(() {
      _isHovering = isHovering;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isSelected =
        widget.scoreboard.gameId == context.watch<MontageGame>().gameId;
    return MouseRegion(
      onEnter: (event) => setIsHovering(true),
      onExit: (event) => setIsHovering(false),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: isSelected || _isHovering
                      ? themePrimary.withOpacity(0.50)
                      : Colors.transparent,
                  style: BorderStyle.solid,
                  width: 2.0)),
          //borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: GestureDetector(
          onTap: () {
            playerData(widget.scoreboard.gameId)
                .then((List<PlayerBoxScore> players) {
              context
                  .read<MontageGame>()
                  .set(widget.scoreboard.gameId, players);
            });
          },
          child: ScoreboardComponent(
            scoreboard: widget.scoreboard,
          ),
        ),
      ),
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

    var scrollController = ScrollController();

    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Scrollbar(
        scrollbarOrientation: ScrollbarOrientation.top,
        radius: Radius.circular(0.0),
        controller: scrollController,
        thumbVisibility: true,
        trackVisibility: true,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            height: 140.0,
            padding:
                EdgeInsets.only(top: 8), // 10 for padding, minus 2 for border
            width: min(
                MediaQuery.of(context).size.width - 20, scores.length * 300.0),
            child: ListView.builder(
              controller: scrollController,
              physics: BouncingScrollPhysics(),
              itemCount: scores.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, int i) {
                return Container(
                    margin: EdgeInsets.only(left: 5, right: 5),
                    child: MontageGameSelectWidget(scoreboard: scores[i]));
              },
            ),
          ),
        ),
      ),
    );
  }
}
