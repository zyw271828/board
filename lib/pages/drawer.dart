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
          onTap: () {
            // TODO: implement this
            Navigator.pop(context);
          },
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
}
