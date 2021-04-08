import 'package:board/pages/home.dart';
import 'package:board/themes/board_theme_data.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Board',
      theme: BoardThemeData.themeData,
      home: HomePage(title: 'Board'),
    );
  }
}
