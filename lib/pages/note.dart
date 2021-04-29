import 'dart:io';
import 'dart:math';

import 'package:board/models/note.dart';
import 'package:board/utils/helper.dart';
import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/board_localizations.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screen/screen.dart';
import 'package:share/share.dart';

class NotePage extends StatefulWidget {
  final List<Note> notes;
  final int index;

  const NotePage({Key key, @required this.notes, @required this.index})
      : super(key: key);

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  double _noteFontSize = 60;
  double _baseScaleFactor = 1;
  double _scaleFactor = 1;
  bool _showAppBar = false;
  bool _showFontSizeIndicator = false;
  bool _showBrightnessIndicator = false;
  bool _isQRcodeButtonPressed = false;
  bool _isMarkdownButtonPressed = false;
  bool _isRotateButtonPressed = false;
  bool _isColorButtonPressed = false;
  int _fontSizeIndicatorValue = 0;
  int _brightnessIndicatorValue = 0;
  int _indicatorLevel = 15;
  int _index;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Helper.exitDisplayMode();
        return Future<bool>.value(true);
      },
      child: Scaffold(
        appBar: _showAppBar
            ? AppBar(
                title: Text(
                  widget.notes[_index].content,
                  maxLines: 1,
                ),
                leading: Builder(
                  builder: (BuildContext context) {
                    return IconButton(
                      icon: const Icon(Icons.arrow_back),
                      tooltip: AppLocalizations.of(context).back,
                      onPressed: () {
                        Helper.exitDisplayMode();
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.share),
                    tooltip: AppLocalizations.of(context).share,
                    onPressed: () {
                      Share.share(widget.notes[_index].content);
                    },
                  ),
                  IconButton(
                    icon: Icon(_isColorButtonPressed
                        ? Icons.color_lens_outlined
                        : Icons.color_lens),
                    tooltip: _isColorButtonPressed
                        ? AppLocalizations.of(context).blackAndWhiteMode
                        : AppLocalizations.of(context).colorMode,
                    onPressed: () {
                      setState(() {
                        _isColorButtonPressed = !_isColorButtonPressed;
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(_isRotateButtonPressed
                        ? Icons.stay_primary_landscape
                        : Icons.stay_primary_portrait),
                    tooltip: _isRotateButtonPressed
                        ? AppLocalizations.of(context).landscapeMode
                        : AppLocalizations.of(context).portraitMode,
                    onPressed: () {
                      if (_isRotateButtonPressed) {
                        Helper.enterLandscapeMode();
                      } else {
                        Helper.enterPortraitMode();
                      }
                      setState(() {
                        _isRotateButtonPressed = !_isRotateButtonPressed;
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.sync_alt),
                    tooltip: _isMarkdownButtonPressed
                        ? AppLocalizations.of(context).plainTextMode
                        : AppLocalizations.of(context).markdownMode,
                    onPressed: () {
                      setState(() {
                        _isMarkdownButtonPressed = !_isMarkdownButtonPressed;
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(_isQRcodeButtonPressed
                        ? Icons.text_snippet
                        : Icons.qr_code),
                    tooltip: _isQRcodeButtonPressed
                        ? AppLocalizations.of(context).textMode
                        : AppLocalizations.of(context).qrcodeMode,
                    onPressed: () {
                      setState(() {
                        _isQRcodeButtonPressed = !_isQRcodeButtonPressed;
                      });
                    },
                  ),
                ],
              )
            : null,
        body: Stack(
          children: [
            Container(
              color:
                  _isColorButtonPressed ? Theme.of(context).accentColor : null,
            ),
            AnimatedSwitcher(
              duration: Duration(milliseconds: 450),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  child: child,
                  opacity: animation,
                );
              },
              child: Center(
                key: ObjectKey(widget.notes[_index]),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(50.0),
                  scrollDirection: Axis.vertical,
                  child: _generateDisplayWidget(),
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
                onHorizontalDragEnd: (details) {
                  if (details.velocity.pixelsPerSecond.dx > 0) {
                    setState(() {
                      if (_index <= 0) {
                        _index = widget.notes.length - 1;
                      } else {
                        _index--;
                      }
                    });
                  } else if (details.velocity.pixelsPerSecond.dx < 0) {
                    setState(() {
                      if (_index >= widget.notes.length - 1) {
                        _index = 0;
                      } else {
                        _index++;
                      }
                    });
                  }
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

  @override
  void initState() {
    super.initState();
    _index = widget.index;
  }

  Widget _generateDisplayWidget() {
    if (_isQRcodeButtonPressed) {
      return QrImage(
        data: widget.notes[_index].content,
        size: min(MediaQuery.of(context).size.height,
                MediaQuery.of(context).size.width) -
            100,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
      );
    } else if (_isMarkdownButtonPressed) {
      return MarkdownBody(
        data: widget.notes[_index].content,
        selectable: true,
        styleSheet: MarkdownStyleSheet(
          textScaleFactor: _scaleFactor,
        ),
      );
    } else {
      return SelectableText(
        widget.notes[_index].content,
        textScaleFactor: _scaleFactor,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: _noteFontSize,
          color: _isColorButtonPressed
              ? Theme.of(context).accentTextTheme.bodyText1.color
              : null,
        ),
      );
    }
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
