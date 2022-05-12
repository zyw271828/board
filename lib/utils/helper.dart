import 'package:board/models/note.dart';
import 'package:board/services/local_storage_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screen_wake/flutter_screen_wake.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:wakelock/wakelock.dart';

class Helper {
  static Future<void> enterDisplayMode() async {
    enterLandscapeMode();

    enterFullscreenMode();

    try {
      Wakelock.enable();
      FlutterScreenWake.setBrightness(
          await LocalStorageService.loadScreenBrightness());
    } on PlatformException catch (e) {
      // Waiting for wakelock to support Linux
      // https://github.com/creativecreatorormaybenot/wakelock/issues/97
      if (kDebugMode) {
        print(e.message);
      }
    } on MissingPluginException catch (e) {
      if (kDebugMode) {
        print(e.message);
      }
    }
  }

  static void enterFullscreenMode() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  static void enterLandscapeMode() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  static void enterPortraitMode() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  static Future<void> exitDisplayMode() async {
    try {
      LocalStorageService.saveScreenBrightness(
          await FlutterScreenWake.brightness);
      // Restore system screen brightness
      FlutterScreenWake.setBrightness(-1);
      Wakelock.disable();
    } on MissingPluginException catch (e) {
      if (kDebugMode) {
        print(e.message);
      }
    } on PlatformException catch (e) {
      // Waiting for wakelock to support Linux
      // https://github.com/creativecreatorormaybenot/wakelock/issues/97
      if (kDebugMode) {
        print(e.message);
      }
    }

    exitFullscreenMode();

    unlockScreenRotation();
  }

  static void exitFullscreenMode() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  static int? generateDarkThemeId(int lightThemeId) {
    return isLightTheme(lightThemeId) ? (lightThemeId + 100) : null;
  }

  static int? generateLightThemeId(int darkThemeId) {
    return isDarkTheme(darkThemeId) ? (darkThemeId - 100) : null;
  }

  static Future<PackageInfo> getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo;
  }

  static Future<String> getPackageName() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.packageName;
  }

  static bool isDarkTheme(int themeId) {
    return !isLightTheme(themeId);
  }

  static bool isLightTheme(int themeId) {
    return themeId < 100;
  }

  static void unlockScreenRotation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  static void updateColorCodes(List<Note?> notes) {
    const int maxColorCode = 900;
    const int minColorCode = 300;
    const int step = 100;

    int curColorCode = maxColorCode;
    bool isColorCodesIncreasing = false;

    for (var note in notes) {
      if (isColorCodesIncreasing) {
        note!.colorCode = curColorCode;
        curColorCode += step;
        if (curColorCode >= maxColorCode) {
          isColorCodesIncreasing = false;
        }
      } else {
        note!.colorCode = curColorCode;
        curColorCode -= step;
        if (curColorCode <= minColorCode) {
          isColorCodesIncreasing = true;
        }
      }
    }
  }
}
