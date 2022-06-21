import 'dart:math';

import 'package:ball_iq/components/datePicker.dart';
import 'package:ball_iq/services/nbaStatsService.dart';
import 'package:flutter/material.dart';
import 'package:ball_iq/components/scoreBoard.dart';

import 'package:ball_iq/common/constants.dart';
import 'package:ball_iq/state/state.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

// Represents a specific player that can be selected for a montage.
class MontagePlayerSelectWidget extends StatefulWidget {
  const MontagePlayerSelectWidget({super.key, required this.player});

  final PlayerBoxScore player;

  @override
  _IndividualPlayerSelection createState() => _IndividualPlayerSelection();
}

class _IndividualPlayerSelection extends State<MontagePlayerSelectWidget> {
  bool _isHovering = false;

  void setIsHovering(isHovering) {
    setState(() {
      _isHovering = isHovering;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isSelected =
        widget.player.playerId == context.watch<MontagePlayer>().playerId;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
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
        ),
        child: GestureDetector(
          onTap: () {
            context
                .read<MontagePlayer>()
                .set(widget.player.playerId, widget.player.playername);
          },
          child: Container(
              width: 150,
              child: Column(
                children: [
                  Stack(children: [
                    Image.network(playerImageUrl(widget.player.playerId)),
                    SvgPicture.network(teamImageUrl(widget.player.teamId)),
                  ]),
                  Center(
                      child: Text(
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                          widget.player.playername))
                ],
              )),
        ),
      ),
    );
  }
}

/// Represents all the players that can be selected for a montage.
class PlayerSelection extends StatelessWidget {
  const PlayerSelection({super.key});

  @override
  Widget build(BuildContext context) {
    List<PlayerBoxScore> players = context.watch<MontageGame>().players;

    var scrollController = ScrollController();

    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Scrollbar(
        scrollbarOrientation: ScrollbarOrientation.top,
        radius: Radius.circular(0.0),
        controller: scrollController,
        thumbVisibility: true,
        trackVisibility: true,
        interactive: true,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            height: 500.0,
            padding:
                EdgeInsets.only(top: 8), // 10 for padding, minus 2 for border
            width: min(
                MediaQuery.of(context).size.width - 20, players.length * 300.0),
            child: ListView.builder(
              controller: scrollController,
              physics: BouncingScrollPhysics(),
              itemCount: players.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, int i) {
                return Container(
                    margin: EdgeInsets.only(left: 5, right: 5, top: 5),
                    child: MontagePlayerSelectWidget(player: players[i]));
              },
            ),
          ),
        ),
      ),
    );
  }
}
