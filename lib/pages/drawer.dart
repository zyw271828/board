import 'package:board/themes/board_theme_data.dart';
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
          onTap: () => _changeTheme(BoardThemeData.primarySwatch),
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

  _changeTheme(MaterialColor primarySwatch) async {
    // TODO: unfinished app theme change
    MaterialColor newPrimarySwatch =
        await _showThemeChangeDialog(primarySwatch);

    setState(() {
      if (BoardThemeData.primarySwatch != null) {
        BoardThemeData.themeData = ThemeData(primarySwatch: newPrimarySwatch);
      }
    });
  }

  Container _generateThemeColorContainer(MaterialColor color, bool isSelected) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(25),
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            // TODO: change theme
          });
        },
        child: isSelected
            ? Icon(
                Icons.check,
                size: 30,
                color: Colors.white,
              )
            : null,
      ),
    );
  }

  Future<MaterialColor> _showThemeChangeDialog(
      MaterialColor primarySwatch) async {
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
                      _generateThemeColorContainer(Colors.pink, false),
                      _generateThemeColorContainer(Colors.red, false),
                      _generateThemeColorContainer(Colors.orange, false),
                      _generateThemeColorContainer(Colors.green, false),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      _generateThemeColorContainer(Colors.teal, false),
                      _generateThemeColorContainer(Colors.blue, true),
                      _generateThemeColorContainer(Colors.purple, false),
                      _generateThemeColorContainer(Colors.grey, false),
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
