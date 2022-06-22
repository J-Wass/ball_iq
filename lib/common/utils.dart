// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

AssetImage getRandomBackground() {
  List<String> backgrounds = [
    "backgroundGIFs/dunk_background.gif",
    "backgroundGIFs/curry.gif"
  ];

  backgrounds.shuffle();
  return AssetImage(backgrounds.first);
}
