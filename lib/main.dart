import 'package:board/pages/home.dart';
import 'package:board/themes/board_theme_data.dart';
import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
      themeCollection: BoardThemeData.themeCollection,
      defaultThemeId: BoardThemeData.blue,
      builder: (context, theme) {
        return MaterialApp(
          title: 'Board',
          theme: theme,
          home: HomePage(title: 'Board'),
        );
      },
    );
  }
}
