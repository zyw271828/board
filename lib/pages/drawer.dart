import 'package:board/themes/board_theme_data.dart';
import 'package:board/utils/helper.dart';
import 'package:board/widgets/board_widgets.dart';
import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/board_localizations.dart';

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
            // TODO: add donate dialog
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text(AppLocalizations.of(context).share),
          leading: const Icon(Icons.share),
          onTap: () {
            // TODO: add share dialog
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text(AppLocalizations.of(context).about),
          leading: const Icon(Icons.info),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return BoardWidgets.generateAboutDialog();
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

  Container _generateThemeColorContainer(int themeId) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: BoardThemeData.themeCollection[themeId].primaryColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: GestureDetector(
        onTap: () {
          int currentThemeId = DynamicTheme.of(context).themeId;
          if (Helper.isLightTheme(currentThemeId)) {
            DynamicTheme.of(context).setTheme(themeId);
          } else {
            DynamicTheme.of(context)
                .setTheme(Helper.generateDarkThemeId(themeId));
          }
        },
        child: (themeId == DynamicTheme.of(context).themeId ||
                Helper.generateDarkThemeId(themeId) ==
                    DynamicTheme.of(context).themeId)
            ? Icon(
                Icons.check,
                size: 30,
                color: Colors.white,
              )
            : null,
      ),
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
                      _generateThemeColorContainer(BoardThemeData.pink),
                      _generateThemeColorContainer(BoardThemeData.red),
                      _generateThemeColorContainer(BoardThemeData.orange),
                      _generateThemeColorContainer(BoardThemeData.yellow),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      _generateThemeColorContainer(BoardThemeData.green),
                      _generateThemeColorContainer(BoardThemeData.teal),
                      _generateThemeColorContainer(BoardThemeData.blue),
                      _generateThemeColorContainer(BoardThemeData.purple),
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
