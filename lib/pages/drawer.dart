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
        child: FlutterLogo(size: 42.0),
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
            // TODO: implement this
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text('Share'),
          leading: const Icon(Icons.share),
          onTap: () {
            // TODO: implement this
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text('About'),
          leading: const Icon(Icons.info),
          onTap: () {
            // TODO: implement this
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
    MaterialColor newPrimarySwatch =
        await _showThemeChangeDialog(primarySwatch);

    setState(() {
      if (BoardThemeData.primarySwatch != null) {
        BoardThemeData.themeData = ThemeData(primarySwatch: newPrimarySwatch);
      }
    });
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  ElevatedButton(
                    child: Text('Blue'),
                    onPressed: () => {
                      Navigator.pop(context, Colors.blue),
                    },
                    style: ElevatedButton.styleFrom(primary: Colors.blue),
                  ),
                  ElevatedButton(
                    child: Text('Green'),
                    onPressed: () => {
                      Navigator.pop(context, Colors.green),
                    },
                    style: ElevatedButton.styleFrom(primary: Colors.green),
                  ),
                  ElevatedButton(
                    child: Text('Red'),
                    onPressed: () => {
                      Navigator.pop(context, Colors.red),
                    },
                    style: ElevatedButton.styleFrom(primary: Colors.red),
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
