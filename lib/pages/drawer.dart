import 'package:board/themes/board_theme_data.dart';
import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:flutter/material.dart';

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
        'Board',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      accountEmail: Text('A Display Board.'),
      currentAccountPicture: const CircleAvatar(
        foregroundImage: AssetImage('assets/images/icon-android.png'),
        backgroundColor: Colors.blue,
      ),
    );
    final drawerItems = ListView(
      children: [
        drawerHeader,
        ListTile(
          title: Text('Theme'),
          leading: const Icon(Icons.color_lens),
          onTap: () => _showThemeChangeDialog(),
        ),
        ListTile(
          title: Text('Donate'),
          leading: const Icon(Icons.payment),
          onTap: () {
            // TODO: add donate dialog
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text('Share'),
          leading: const Icon(Icons.share),
          onTap: () {
            // TODO: add share dialog
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text('About'),
          leading: const Icon(Icons.info),
          onTap: () {
            // TODO: add about dialog
            Navigator.pop(context);
          },
        ),
      ],
    );

    return Drawer(
      child: drawerItems,
    );
  }

  Container _generateThemeColorContainer(int colorIndex) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: BoardThemeData.themeCollection[colorIndex].primaryColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: GestureDetector(
        onTap: () {
          DynamicTheme.of(context).setTheme(colorIndex);
        },
        child: (colorIndex == DynamicTheme.of(context).themeId)
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
          title: Text('Change Theme'),
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
                      _generateThemeColorContainer(BoardThemeData.green),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      _generateThemeColorContainer(BoardThemeData.teal),
                      _generateThemeColorContainer(BoardThemeData.blue),
                      _generateThemeColorContainer(BoardThemeData.purple),
                      // TODO: dark theme
                      // _generateThemeColorContainer(BoardThemeData.dark),
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
