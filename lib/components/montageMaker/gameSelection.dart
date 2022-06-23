// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:ball_iq/common/constants.dart';
import 'package:ball_iq/services/nbaStatsService.dart';
import 'package:ball_iq/state/state.dart';
import '../home/scoreBoard.dart';

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
                      ? brightText.withOpacity(0.50)
                      : Colors.transparent,
                  style: BorderStyle.solid,
                  width: 2.0)),
          //borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: GestureDetector(
          onTap: () {
            context.read<MontagePlayer>().markIsLoading(true);
            playerData(widget.scoreboard.gameId)
                .then((List<PlayerBoxScore> players) {
              context
                  .read<MontageGame>()
                  .set(widget.scoreboard.gameId, players);
              context.read<MontagePlayer>().markIsLoading(false);
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

    bool isLoading = context.watch<MontageGame>().isLoading;

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
            // width = either the entire page - 20 (and then scroll), or however long scores is
            width: min(
                MediaQuery.of(context).size.width - 20, scores.length * 300.0),
            child: isLoading
                ? const SizedBox(
                    width: 30,
                    child: Center(
                      child: CircularProgressIndicator(color: themePrimary),
                    ),
                  )
                : ListView.builder(
                    controller: scrollController,
                    physics: BouncingScrollPhysics(),
                    itemCount: scores.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, int i) {
                      return Container(
                          margin: EdgeInsets.only(left: 5, right: 5),
                          child:
                              MontageGameSelectWidget(scoreboard: scores[i]));
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
