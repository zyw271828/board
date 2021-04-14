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
  static const int yellow = 12;
  static const int orange = 14;
  static const int darkRed = red + 100;
  static const int darkPink = pink + 100;
  static const int darkPurple = purple + 100;
  static const int darkBlue = blue + 100;
  static const int darkTeal = teal + 100;
  static const int darkGreen = green + 100;
  static const int darkYellow = yellow + 100;
  static const int darkOrange = orange + 100;

  static final themeCollection = ThemeCollection(
    themes: {
      pink: ThemeData(primarySwatch: Colors.pink),
      red: ThemeData(primarySwatch: Colors.red),
      orange: ThemeData(primarySwatch: Colors.orange),
      yellow: ThemeData(primarySwatch: Colors.yellow),
      green: ThemeData(primarySwatch: Colors.green),
      teal: ThemeData(primarySwatch: Colors.teal),
      blue: ThemeData(primarySwatch: Colors.blue),
      purple: ThemeData(primarySwatch: Colors.purple),
      darkPink: ThemeData(
        primarySwatch: Colors.pink,
        accentColor: Colors.pink,
        brightness: Brightness.dark,
      ),
      darkRed: ThemeData(
        primarySwatch: Colors.red,
        accentColor: Colors.red,
        brightness: Brightness.dark,
      ),
      darkOrange: ThemeData(
        primarySwatch: Colors.orange,
        accentColor: Colors.orange,
        brightness: Brightness.dark,
      ),
      darkYellow: ThemeData(
        primarySwatch: Colors.yellow,
        accentColor: Colors.yellow,
        brightness: Brightness.dark,
      ),
      darkGreen: ThemeData(
        primarySwatch: Colors.green,
        accentColor: Colors.green,
        brightness: Brightness.dark,
      ),
      darkTeal: ThemeData(
        primarySwatch: Colors.teal,
        accentColor: Colors.teal,
        brightness: Brightness.dark,
      ),
      darkBlue: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.blue,
        brightness: Brightness.dark,
      ),
      darkPurple: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.purple,
        brightness: Brightness.dark,
      ),
    },
  );
}
