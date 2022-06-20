import 'package:ball_iq/components/datePicker.dart';
import 'package:flutter/material.dart';

import 'package:ball_iq/common/constants.dart';
import 'package:ball_iq/state/state.dart';
import 'package:ball_iq/services/nbaStatsService.dart';
import 'package:ball_iq/components/montageMaker/gameSelection.dart';
import 'package:ball_iq/components/montageMaker/playerSelection.dart';
import 'package:ball_iq/components/montageMaker/statSelection.dart';
import 'package:provider/provider.dart';

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
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SelectableText("Montage Maker", style: TextStyle(fontSize: 32)),
              DatePicker(),
              GameSelection(),
              PlayerSelection(),
              StatSelection(),
              Text("Go!")
            ],
          ),
        ),
      ),
    );
  }
}
