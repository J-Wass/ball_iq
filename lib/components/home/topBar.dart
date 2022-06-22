// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

// Project imports:
import 'package:ball_iq/common/constants.dart';
import 'package:ball_iq/components/home/scoreBoard.dart';
import 'package:ball_iq/state/state.dart';
import '../common/datePicker.dart';

class TopBar extends StatelessWidget {
  const TopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(50, 0, 0, 0),
      child: Row(children: const [
        DatePicker(),
        Expanded(
          child: ScoreboardDisplay(),
        ),
      ]),
    );
  }
}
