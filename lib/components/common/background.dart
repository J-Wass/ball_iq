import 'package:flutter/material.dart';

import '../../common/constants.dart';
import '../../common/utils.dart';

/// Wraps its child widget in a gif & gradient background.
class Background extends StatelessWidget {
  final Color color;
  final Widget child;
  Background({Key? key, required this.color, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Layer 1: gif background.
        Container(
          height: MediaQuery.of(context).size.height - 40,
          decoration: BoxDecoration(
            color: Colors.transparent,
            image: DecorationImage(
              image: getRandomBackground(),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.grey,
                BlendMode.saturation,
              ),
            ),
          ),
        ),
        // Layer 2: gradient background.
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                Colors.transparent,
                themePrimary.withAlpha(250),
              ])),
        ),
        // Layer 3: Main content.
        child
      ],
    );
  }
}
