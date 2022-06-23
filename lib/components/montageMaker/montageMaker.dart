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
        preferredSize: Size.fromHeight(40.0),
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
                    ? EdgeInsets.only(top: 100)
                    : EdgeInsets.only(top: 10),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      RichText(
                          text: TextSpan(children: [
                        WidgetSpan(
                          child: Icon(Icons.movie, size: 38, color: brightText),
                        ),
                        TextSpan(
                            text: " Montage Maker",
                            style: TextStyle(fontSize: 32, color: brightText))
                      ])),
                      DatePicker(),
                      GameSelection(),
                      PlayerSelection(),
                      StatSelection(),
                      Text("Go!")
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
