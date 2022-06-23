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
                      ? brightText.withOpacity(0.50)
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
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  topRight: Radius.circular(50.0),
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    themePrimary.withOpacity(0.01),
                    brightInactiveBackground,
                  ],
                )),
            margin: EdgeInsets.only(bottom: 10),
            width: 150,
            child: Column(
              children: [
                Stack(children: [
                  Image.network(playerImageUrl(widget.player.playerId)),
                  SizedBox(
                    width: 50,
                    child: Image.network(teamImageUrl(widget.player.teamId)),
                  ),
                ]),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          "${widget.player.playername}"),
                      Text(
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                          "${widget.player.points} pts"),
                      Text(
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                          "${widget.player.rebounds} rbs"),
                      Text(
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                          "${widget.player.assists} ast"),
                    ],
                  ),
                )
              ],
            ),
          ),
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
    players.sort((a, b) => (b.points + b.rebounds * 1.5 + b.assists * 2.5)
        .compareTo(a.points + a.rebounds * 2 + a.assists * 3));

    var scrollController = ScrollController();

    bool isLoading = context.watch<MontagePlayer>().isLoading;

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
            height: 250.0,
            padding:
                EdgeInsets.only(top: 8), // 10 for padding, minus 2 for border
            width: min(
                MediaQuery.of(context).size.width - 20, players.length * 300.0),
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
