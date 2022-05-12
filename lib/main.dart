import 'package:board/pages/home.dart';
import 'package:board/themes/board_theme_data.dart';
import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/board_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
      themeCollection: BoardThemeData.themeCollection,
      defaultThemeId: BoardThemeData.blue,
      builder: (context, theme) {
        return MaterialApp(
          title: 'Board',
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale.fromSubtags(languageCode: 'en'),
            Locale.fromSubtags(languageCode: 'zh'),
          ],
          theme: theme,
          home: const HomePage(),
        );
      },
    );
  }
}
