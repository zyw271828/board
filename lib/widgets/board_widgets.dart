import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class BoardWidgets {
  static Widget generateAboutDialog() {
    return SimpleDialog(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: 50,
              height: 50,
              child: CircleAvatar(
                foregroundImage: AssetImage('assets/images/icon-drawer.png'),
              ),
            ),
            _generatePackageInfoColumn(),
            SizedBox(width: 50),
          ],
        ),
      ],
    );
  }

  static _generatePackageInfoColumn() {
    return FutureBuilder<PackageInfo>(
      future: _getPackageInfo(),
      builder: (BuildContext context, AsyncSnapshot<PackageInfo> snapshot) {
        List<Widget> children;

        if (snapshot.hasData) {
          children = <Widget>[
            Text(
              snapshot.data.appName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            snapshot.data.packageName.isEmpty
                ? SizedBox(height: 0)
                : Text(snapshot.data.packageName),
            SizedBox(height: 8),
            Text('Version: ' + snapshot.data.version),
            Text('Build number: ' + snapshot.data.buildNumber),
          ];
        } else {
          children = <Widget>[
            SizedBox(
              child: CircularProgressIndicator(),
              width: 50,
              height: 50,
            ),
          ];
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        );
      },
    );
  }

  static Future<PackageInfo> _getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo;
  }
}
