// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:ball_iq/common/constants.dart';
import 'package:ball_iq/components/montageMaker/gameSelection.dart';
import 'package:ball_iq/components/montageMaker/playerSelection.dart';
import 'package:ball_iq/components/montageMaker/statSelection.dart';
import 'package:ball_iq/services/nbaStatsService.dart';
import 'package:ball_iq/state/state.dart';
import 'package:ball_iq/utils/screenUtils.dart';
import '../common/background.dart';
import '../common/datePicker.dart';

class MontageMaker extends StatelessWidget {
  const MontageMaker({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40.0),
        child: AppBar(
          title: const SelectableText('BBall IQ - Montage Maker'),
          backgroundColor: themePrimary,
          foregroundColor: darkText,
        ),
      ),
      body: Background(
          color: themePrimary,
          child:

              // Layer 3: side widgets
              SingleChildScrollView(
            child: Center(
              child: Container(
                margin: isTallScreen(context)
                    ? const EdgeInsets.only(top: 100)
                    : const EdgeInsets.only(top: 10),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      RichText(
                          text: const TextSpan(children: [
                        WidgetSpan(
                          child: Icon(Icons.movie, size: 38, color: brightText),
                        ),
                        TextSpan(
                            text: " Montage Maker",
                            style: TextStyle(fontSize: 32, color: brightText))
                      ])),
                      const DatePicker(),
                      const GameSelection(),
                      if (context.watch<MontageGame>().gameId != '')
                        const PlayerSelection(),
                      if (context.watch<MontagePlayer>().playerId != '')
                        const StatSelection(),
                      if (context.watch<MontageStat>().stat != null)
                        TextButton.icon(
                            icon: Icon(Icons.calendar_today_rounded),
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              primary: darkText,
                              backgroundColor: themePrimary.withOpacity(0.75),
                            ),
                            onPressed: () => {
                                  // TODO: use https://pub.dev/packages/url_launcher to open the mp4 from rust service or something
                                },
                            label: Text(
                              'Go!',
                              style: TextStyle(fontSize: 16),
                            ))
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
