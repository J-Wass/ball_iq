// Dart imports:
import 'dart:developer';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:ball_iq/common/constants.dart';
import 'package:ball_iq/services/nbaStatsService.dart';
import 'package:ball_iq/state/state.dart';

class ScoreboardComponent extends StatelessWidget {
  final Scoreboard scoreboard;
  const ScoreboardComponent({Key? key, required this.scoreboard})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 89, 89, 89).withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 2,
            offset: const Offset(2, 2), // changes position of shadow
          ),
        ],
      ),
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        children: [
          // Team Logos.
          Container(
            width: 50,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 0),
                    child: Image.network(
                        height: 45, teamImageUrl(scoreboard.team1Id)),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Image.network(
                        height: 45, teamImageUrl(scoreboard.team2Id)),
                  ),
                ),
              ],
            ),
          ),
          // Team cities.
          Container(
            width: 125,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 15),
                    child: Text(
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 18),
                        scoreboard.team1),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 15),
                    child: Text(
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 18),
                        scoreboard.team2),
                  ),
                )
              ],
            ),
          ),
          // Team Scores
          Container(
            width: 54,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 5),
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 5, bottom: 5),
                  height: 110,
                  color: brightInactiveBackground,
                  child: Column(children: [
                    Text(
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                        scoreboard.timeString),
                    scoreboard.team1Score != "null"
                        ? Container(
                            child: Text(
                                style: const TextStyle(fontSize: 15),
                                scoreboard.team1Score))
                        : Container(),
                    scoreboard.team2Score != "null"
                        ? Container(
                            margin: const EdgeInsets.only(top: 25),
                            child: Text(
                                style: const TextStyle(fontSize: 15),
                                scoreboard.team2Score))
                        : Container(),
                  ]),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ScoreboardDisplay extends StatelessWidget {
  const ScoreboardDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Scoreboard> scoreboard =
        context.watch<FrontPageScoreboardState>().scoreboard ?? [];

    bool isLoading = context.watch<FrontPageScoreboardState>().isLoading;

    return MouseRegion(
      cursor: isLoading || scoreboard.isEmpty
          ? SystemMouseCursors.precise
          : SystemMouseCursors.grab,
      child: Container(
          decoration: BoxDecoration(
            border: Border(
              left:
                  BorderSide(width: 1.0, color: Colors.white.withOpacity(0.5)),
            ),
          ),
          height: 130,
          child: isLoading
              ? const SizedBox(
                  width: 30,
                  child: Center(
                    child: CircularProgressIndicator(color: themePrimary),
                  ),
                )
              : scoreboard.isEmpty
                  ? const Center(
                      child: Text(
                          style: TextStyle(
                              color: brightInactiveBackground, fontSize: 18),
                          "No games today..."),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: scoreboard.length,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (_, int i) {
                        return Container(
                            margin: const EdgeInsets.only(left: 15),
                            child:
                                ScoreboardComponent(scoreboard: scoreboard[i]));
                      },
                    )),
    );
  }
}
