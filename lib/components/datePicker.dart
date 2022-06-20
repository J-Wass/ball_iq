import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ball_iq/common/constants.dart';
import 'package:ball_iq/state/state.dart';
import 'package:ball_iq/services/nbaStatsService.dart';

class DatePicker extends StatelessWidget {
  const DatePicker({Key? key}) : super(key: key);

  /// Shows the datepicker for the homepage and saves the date to memory.
  void setDate(BuildContext context) {
    DateTime yesteryear =
        DateTime.now().subtract(const Duration(days: 365 * 10));
    showDatePicker(
            context: context,
            initialDate: context.read<DateSelect>().datetime,
            firstDate: yesteryear,
            lastDate: DateTime.now())
        .then((dateSelected) {
      if (dateSelected != null) {
        context.read<DateSelect>().set(dateSelected);
        gameData(dateSelected).then((List<Scoreboard> allGames) {
          context.read<FrontPageScoreboardState>().set(allGames);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0))),
      margin: EdgeInsets.all(15),
      child: TextButton.icon(
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
          onPressed: () => setDate(context),
          label: Text(
            '${context.watch<DateSelect>().shortDateTime}',
            style: TextStyle(fontSize: 16),
          )),
    );
  }
}
