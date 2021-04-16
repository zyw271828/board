import 'package:board/themes/board_theme_data.dart';
import 'package:board/utils/helper.dart';
import 'package:board/widgets/board_widgets.dart';
import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/board_localizations.dart';
import 'package:share/share.dart';

class NavDrawer extends StatefulWidget {
  const NavDrawer({Key key}) : super(key: key);

  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  @override
  Widget build(BuildContext context) {
    final drawerHeader = UserAccountsDrawerHeader(
      accountName: Text(
        AppLocalizations.of(context).appName,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      accountEmail: Text(AppLocalizations.of(context).appDescription),
      currentAccountPicture: const CircleAvatar(
        foregroundImage: AssetImage('assets/images/icon-drawer.png'),
      ),
    );
    final drawerItems = ListView(
      children: [
        drawerHeader,
        ListTile(
          title: Text(AppLocalizations.of(context).theme),
          leading: const Icon(Icons.color_lens),
          onTap: () => _showThemeChangeDialog(),
        ),
        ListTile(
          title: Text(AppLocalizations.of(context).donate),
          leading: const Icon(Icons.payment),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return BoardWidgets.generateDonateDialog(context);
              },
            );
          },
        ),
        ListTile(
          title: Text(AppLocalizations.of(context).share),
          leading: const Icon(Icons.share),
          onTap: () async {
            Share.share('https://play.google.com/store/apps/details?id=' +
                await Helper.getPackageName());
          },
        ),
        ListTile(
          title: Text(AppLocalizations.of(context).about),
          leading: const Icon(Icons.info),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return BoardWidgets.generateAboutDialog(context);
              },
            );
          },
        ),
      ],
    );

    return Drawer(
      child: drawerItems,
    );
  }

  _showThemeChangeDialog() {
    return showDialog<MaterialColor>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(AppLocalizations.of(context).changeTheme),
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      BoardWidgets.generateThemeColorContainer(
                          context, BoardThemeData.pink),
                      BoardWidgets.generateThemeColorContainer(
                          context, BoardThemeData.red),
                      BoardWidgets.generateThemeColorContainer(
                          context, BoardThemeData.orange),
                      BoardWidgets.generateThemeColorContainer(
                          context, BoardThemeData.yellow),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      BoardWidgets.generateThemeColorContainer(
                          context, BoardThemeData.green),
                      BoardWidgets.generateThemeColorContainer(
                          context, BoardThemeData.teal),
                      BoardWidgets.generateThemeColorContainer(
                          context, BoardThemeData.blue),
                      BoardWidgets.generateThemeColorContainer(
                          context, BoardThemeData.purple),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Helper.isDarkTheme(DynamicTheme.of(context).themeId)
                          ? Icons.brightness_low
                          : Icons.brightness_high),
                      Switch(
                        value: Helper.isDarkTheme(
                            DynamicTheme.of(context).themeId),
                        activeColor: Theme.of(context).accentColor,
                        onChanged: (value) {
                          int themeId = DynamicTheme.of(context).themeId;
                          if (Helper.isLightTheme(themeId)) {
                            DynamicTheme.of(context)
                                .setTheme(Helper.generateDarkThemeId(themeId));
                          } else {
                            DynamicTheme.of(context)
                                .setTheme(Helper.generateLightThemeId(themeId));
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
