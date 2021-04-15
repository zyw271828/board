import 'package:board/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/board_localizations.dart';
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

  static Widget generateDonateDialog(BuildContext context) {
    // TODO: unfinished donate dialog
    return SimpleDialog(
      title: Text(AppLocalizations.of(context).donate),
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(AppLocalizations.of(context).donateDescription),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('\$ 0.00'),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('\$ 0.00'),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('\$ 0.00'),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('\$ 0.00'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  static _generatePackageInfoColumn() {
    return FutureBuilder<PackageInfo>(
      future: Helper.getPackageInfo(),
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
}
