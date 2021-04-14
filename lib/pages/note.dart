import 'dart:io';

import 'package:board/models/note.dart';
import 'package:board/utils/helper.dart';
import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:flutter/material.dart';
import 'package:screen/screen.dart';
import 'package:wakelock/wakelock.dart';

class NotePage extends StatefulWidget {
  final Note note;

  const NotePage({Key key, @required this.note}) : super(key: key);

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  double _noteFontSize = 80;
  double _baseScaleFactor = 1;
  double _scaleFactor = 1;
  bool _showAppBar = false;
  bool _showFontSizeIndicator = false;
  bool _showBrightnessIndicator = false;
  int _fontSizeIndicatorValue = 0;
  int _brightnessIndicatorValue = 0;
  int _indicatorLevel = 15;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Wakelock.disable();
        Helper.exitDisplayMode();
        return Future<bool>.value(true);
      },
      child: Scaffold(
        appBar: _showAppBar
            ? AppBar(
                title: Text(widget.note.content),
                leading: Builder(
                  builder: (BuildContext context) {
                    return IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Helper.exitDisplayMode();
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
              )
            : null,
        body: Stack(
          // TODO: horizontal drag gesture to change note color
          children: [
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(50.0),
                scrollDirection: Axis.vertical,
                child: Text(
                  widget.note.content,
                  textScaleFactor: _scaleFactor,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: _noteFontSize),
                ),
              ),
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  if (_showAppBar) {
                    Helper.enterFullscreenMode();
                  } else {
                    Helper.exitFullscreenMode();
                  }
                  setState(() {
                    _showAppBar = !_showAppBar;
                  });
                },
                onScaleStart: (details) {
                  _baseScaleFactor = _scaleFactor;
                },
                onScaleUpdate: (details) {
                  setState(() {
                    // _showFontSizeIndicator = true;
                    _scaleFactor = _baseScaleFactor * details.scale;
                    _fontSizeIndicatorValue =
                        (_scaleFactor * (_indicatorLevel / 3)).toInt();
                  });
                },
                // onScaleEnd: (details) async {
                //   // https://github.com/flutter/flutter/issues/13102
                //   try {
                //     await Future.delayed(const Duration(seconds: 1), () {
                //       setState(() {
                //         _showFontSizeIndicator = false;
                //       });
                //     });
                //   } on FlutterError catch (e) {
                //     debugPrint(e.message);
                //   }
                // },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 100,
                  height: MediaQuery.of(context).size.height,
                  child: Stack(
                    children: [
                      Center(
                        child: AnimatedOpacity(
                          opacity: _showFontSizeIndicator ? 1.0 : 0.0,
                          duration: Duration(milliseconds: 500),
                          child: _generateIndicatorContainer(
                              _fontSizeIndicatorValue,
                              Icons.format_size,
                              Colors.purple),
                        ),
                      ),
                      GestureDetector(
                        onVerticalDragUpdate: (details) async {
                          setState(() {
                            _showBrightnessIndicator = true;
                          });
                          if (Platform.isAndroid || Platform.isIOS) {
                            double brightness = await Screen.brightness -
                                details.delta.dy / 500;

                            if (brightness >= 0 && brightness <= 1) {
                              Screen.setBrightness(brightness);
                              setState(() {
                                // Brightness cannot reach 1, so we add 0.01 here
                                _brightnessIndicatorValue =
                                    (brightness * (_indicatorLevel + 0.01))
                                        .toInt();
                              });
                            }
                          }
                        },
                        onVerticalDragEnd: (details) async {
                          try {
                            await Future.delayed(const Duration(seconds: 1),
                                () {
                              setState(() {
                                _showBrightnessIndicator = false;
                              });
                            });
                          } on FlutterError catch (e) {
                            debugPrint(e.message);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 100,
                  height: MediaQuery.of(context).size.height,
                  child: Stack(
                    children: [
                      Center(
                        child: AnimatedOpacity(
                          opacity: _showBrightnessIndicator ? 1.0 : 0.0,
                          duration: Duration(milliseconds: 450),
                          child: _generateIndicatorContainer(
                              _brightnessIndicatorValue,
                              Icons.brightness_6,
                              Colors.orange),
                        ),
                      ),
                      GestureDetector(
                        onVerticalDragUpdate: (details) {
                          setState(() {
                            _showFontSizeIndicator = true;
                            _scaleFactor *= 1 - details.delta.dy / 50;
                            _fontSizeIndicatorValue =
                                (_scaleFactor * (_indicatorLevel / 3)).toInt();
                          });
                        },
                        onVerticalDragEnd: (details) async {
                          try {
                            await Future.delayed(const Duration(seconds: 1),
                                () {
                              setState(() {
                                _showFontSizeIndicator = false;
                              });
                            });
                          } on FlutterError catch (e) {
                            debugPrint(e.message);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container _generateIndicatorContainer(
      int progress, IconData icon, MaterialColor color) {
    // 0 <= progress <= _indicatorLevel
    if (progress < 0) {
      progress = 0;
    } else if (progress > _indicatorLevel) {
      progress = _indicatorLevel;
    }

    bool isDarkTheme = Helper.isDarkTheme(DynamicTheme.of(context).themeId);
    Color backgroundColor = isDarkTheme ? Colors.white : Colors.black;
    Color foregroundColor = isDarkTheme ? Colors.black : Colors.white;

    return Container(
      width: 50,
      height: 300,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            child: Center(
                child: Text(
              progress.toString(),
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: backgroundColor.withOpacity(0.5),
              ),
            )),
          ),
          Container(
            width: 50,
            height: 200,
            decoration: BoxDecoration(
              color: backgroundColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: Container(
                width: 15,
                height: 150,
                color: foregroundColor.withOpacity(0.5),
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: 15,
                  height: (progress * (150 / _indicatorLevel)).toDouble(),
                  color: color.withOpacity(0.8),
                ),
              ),
            ),
          ),
          Container(
            width: 50,
            height: 50,
            child: Center(
              child: Icon(
                icon,
                size: 30,
                color: backgroundColor.withOpacity(0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
