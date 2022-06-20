import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ball_iq/common/constants.dart';
import 'package:ball_iq/components/datePicker.dart';
import 'package:ball_iq/components/scoreBoard.dart';
import 'package:ball_iq/state/state.dart';

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
