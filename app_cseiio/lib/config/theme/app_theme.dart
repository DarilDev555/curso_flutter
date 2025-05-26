import 'package:flutter/material.dart';
import 'package:tinycolor2/tinycolor2.dart';

class AppTheme {
  ThemeData getTheme() => ThemeData(
    brightness: Brightness.light,
    colorSchemeSeed: TinyColor.fromString('#971840').color,
  );
}
