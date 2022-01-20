import 'package:board/themes/board_theme_data.dart';
import 'package:board/utils/helper.dart';
import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/board_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';

class BoardWidgets {
  static Widget generateAboutDialog(BuildContext context) {
    return SimpleDialog(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: 50,
              height: 50,
              child: LogoAvatar(),
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
      title: Text(AppLocalizations.of(context)!.donate),
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(AppLocalizations.of(context)!.donateDescription),
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

  static Container generateThemeColorContainer(
      BuildContext context, int themeId) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: BoardThemeData.themeCollection[themeId].primaryColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: GestureDetector(
        onTap: () {
          int currentThemeId = DynamicTheme.of(context)!.themeId;
          if (Helper.isLightTheme(currentThemeId)) {
            DynamicTheme.of(context)!.setTheme(themeId);
          } else {
            DynamicTheme.of(context)!
                .setTheme(Helper.generateDarkThemeId(themeId)!);
          }
        },
        child: (themeId == DynamicTheme.of(context)!.themeId ||
                Helper.generateDarkThemeId(themeId) ==
                    DynamicTheme.of(context)!.themeId)
            ? Icon(
                Icons.check,
                size: 30,
                color: Colors.white,
              )
            : null,
      ),
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
              snapshot.data!.appName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            snapshot.data!.packageName.isEmpty
                ? SizedBox(height: 0)
                : Text(snapshot.data!.packageName),
            SizedBox(height: 8),
            Text('Version: ' + snapshot.data!.version),
            Text('Build number: ' + snapshot.data!.buildNumber),
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

class LogoAvatar extends StatefulWidget {
  @override
  _LogoAvatarState createState() => _LogoAvatarState();
}

class _LogoAvatarState extends State<LogoAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onDoubleTap: () {
          _animationController.reset();
          _animationController.forward();
        },
        child: RotationTransition(
          turns: _animation,
          child: CircleAvatar(
            foregroundImage: AssetImage('assets/images/icon-drawer.png'),
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );
  }
}
