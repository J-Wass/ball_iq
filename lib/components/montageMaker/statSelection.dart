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

// Represents a specific stat that can be selected for a montage.
class MontageStatSelectWidget extends StatefulWidget {
  const MontageStatSelectWidget({super.key, required this.stat});

  final Stat stat;

  @override
  _IndividualStatSelection createState() => _IndividualStatSelection();
}

class _IndividualStatSelection extends State<MontageStatSelectWidget> {
  bool _isHovering = false;

  void setIsHovering(isHovering) {
    setState(() {
      _isHovering = isHovering;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isSelected = widget.stat == context.watch<MontageStat>().stat;
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
            context.read<MontageStat>().set(widget.stat);
          },
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  color: inactiveBackground),
              margin: EdgeInsets.only(bottom: 10),
              width: 150,
              child: Container(
                child: Column(
                  children: [
                    Text(
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        "${widget.stat.statName}"),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}

/// Represents all the stats that can be selected for a montage.
class StatSelection extends StatelessWidget {
  const StatSelection({super.key});

  @override
  Widget build(BuildContext context) {
    List<Stat> stats = [
      Stat("Buckets", "score"),
      Stat("Rebounds", "rebound"),
      Stat("Assists", "assist"),
      Stat("Blocks", "block"),
      Stat("Steals", "steal"),
      Stat("Tipped Passes", "tip"),
      Stat("Turnovers", "turnover"),
      Stat("Misses", "miss"),
      Stat("Personal Foul", "personal foul"),
      Stat("Technical Foul", "technical foul"),
      Stat("Flagrant Foul", "flagrant foul"),
    ];

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
            height: 250.0,
            padding:
                EdgeInsets.only(top: 8), // 10 for padding, minus 2 for border
            width: min(
                MediaQuery.of(context).size.width - 20, stats.length * 300.0),
            child: ListView.builder(
              controller: scrollController,
              physics: BouncingScrollPhysics(),
              itemCount: stats.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, int i) {
                return Container(
                    margin: EdgeInsets.only(left: 5, right: 5, top: 5),
                    child: MontageStatSelectWidget(stat: stats[i]));
              },
            ),
          ),
        ),
      ),
    );
  }
}
