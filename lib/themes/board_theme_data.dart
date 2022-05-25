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
      pink: ThemeData(
        primarySwatch: Colors.pink,
        useMaterial3: true,
      ),
      red: ThemeData(
        primarySwatch: Colors.red,
        useMaterial3: true,
      ),
      orange: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: true,
      ),
      yellow: ThemeData(
        primarySwatch: Colors.yellow,
        useMaterial3: true,
      ),
      green: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      teal: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      blue: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      purple: ThemeData(
        primarySwatch: Colors.purple,
        useMaterial3: true,
      ),
      darkPink: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.pink,
          accentColor: Colors.pink,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      darkRed: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.red,
          accentColor: Colors.red,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      darkOrange: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.orange,
          accentColor: Colors.orange,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      darkYellow: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.yellow,
          accentColor: Colors.yellow,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      darkGreen: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.green,
          accentColor: Colors.green,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      darkTeal: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.teal,
          accentColor: Colors.teal,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      darkBlue: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
          accentColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      darkPurple: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.purple,
          accentColor: Colors.purple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
    },
  );
}
