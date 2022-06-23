// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:ball_iq/common/constants.dart';
import 'package:ball_iq/services/nbaStatsService.dart';
import 'package:ball_iq/state/state.dart';

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
        context.read<FrontPageScoreboardState>().markIsLoading(true);
        context.read<MontageGame>().markIsLoading(true);
        gameData(dateSelected).then((List<Scoreboard> allGames) {
          context.read<FrontPageScoreboardState>().set(allGames);
          context.read<MontageGame>().markIsLoading(false);
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
