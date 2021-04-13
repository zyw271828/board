import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:flutter/material.dart';

class BoardThemeData {
  // Except for dark, all index values are taken from Colors.primaries
  // https://api.flutter.dev/flutter/material/Colors/primaries-constant.html
  static const int red = 0;
  static const int pink = 1;
  static const int purple = 2;
  static const int blue = 5;
  static const int teal = 8;
  static const int green = 9;
  static const int orange = 14;
  static const int dark = 255;

  static final themeCollection = ThemeCollection(
    themes: {
      pink: ThemeData(primarySwatch: Colors.pink),
      red: ThemeData(primarySwatch: Colors.red),
      orange: ThemeData(primarySwatch: Colors.orange),
      green: ThemeData(primarySwatch: Colors.green),
      teal: ThemeData(primarySwatch: Colors.teal),
      blue: ThemeData(primarySwatch: Colors.blue),
      purple: ThemeData(primarySwatch: Colors.purple),
      // TODO: dark theme
      // dark: ThemeData.dark(),
    },
    fallbackTheme: ThemeData.light(),
  );
}
