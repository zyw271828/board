import 'dart:io';

import 'package:board/models/note.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:screen/screen.dart';

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
  bool _showAppBar = true;
  bool _showFontSizeIndicator = false;
  bool _showBrightnessIndicator = false;
  int _fontSizeIndicatorValue = 0;
  int _brightnessIndicatorValue = 0;
  int _indicatorLevel = 15;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _showAppBar
          ? AppBar(
              title: Text(widget.note.content),
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      // TODO: do the same when using NavBar
                      // Enter portrait mode
                      SystemChrome.setPreferredOrientations([
                        DeviceOrientation.portraitDown,
                        DeviceOrientation.portraitUp,
                      ]);

                      // Exit fullscreen mode
                      SystemChrome.setEnabledSystemUIOverlays(
                          SystemUiOverlay.values);

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
              onTap: () => setState(() => _showAppBar = !_showAppBar),
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
              //   await Future.delayed(const Duration(seconds: 2), () {
              //     setState(() {
              //       _showFontSizeIndicator = false;
              //     });
              //   });
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
                      child: _showFontSizeIndicator
                          ? _generateIndicatorContainer(_fontSizeIndicatorValue,
                              Icons.format_size, Colors.purple)
                          : null,
                    ),
                    GestureDetector(
                      onVerticalDragUpdate: (details) async {
                        setState(() {
                          _showBrightnessIndicator = true;
                        });
                        if (Platform.isAndroid || Platform.isIOS) {
                          double brightness =
                              await Screen.brightness - details.delta.dy / 500;

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
                        await Future.delayed(const Duration(seconds: 2), () {
                          setState(() {
                            _showBrightnessIndicator = false;
                          });
                        });
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
                      child: _showBrightnessIndicator
                          ? _generateIndicatorContainer(
                              _brightnessIndicatorValue,
                              Icons.brightness_6,
                              Colors.orange)
                          : null,
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
                        await Future.delayed(const Duration(seconds: 2), () {
                          setState(() {
                            _showFontSizeIndicator = false;
                          });
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
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
                color: Colors.black.withOpacity(0.5),
              ),
            )),
          ),
          Container(
            width: 50,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: Container(
                width: 15,
                height: 150,
                color: Colors.white.withOpacity(0.5),
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
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
