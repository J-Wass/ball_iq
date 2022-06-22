// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

/// Returns whether the current screen is for mobile.
bool isMobileScreen(BuildContext context) {
  print(
      '${MediaQuery.of(context).size.width} Is Mobile: ${MediaQuery.of(context).size.width < 500}');
  return MediaQuery.of(context).size.width < 500;
}

/// Returns whether the current screen is tall enough to show more background.
bool isTallScreen(BuildContext context) {
  print(
      '${MediaQuery.of(context).size.height} Is Tall: ${MediaQuery.of(context).size.height < 500}');
  return MediaQuery.of(context).size.height > 730;
}

class TotalScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.mouse,
        PointerDeviceKind.touch,
        PointerDeviceKind.stylus,
        PointerDeviceKind.unknown
      };
}
