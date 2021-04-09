import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:screen/screen.dart';

class NotePage extends StatefulWidget {
  final String note;

  const NotePage({Key key, @required this.note}) : super(key: key);

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  double noteFontSize = 80;
  double _baseScaleFactor = 1;
  double _scaleFactor = 1;
  bool _showAppBar = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _showAppBar
          ? AppBar(
              title: Text(widget.note),
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
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
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(50.0),
              scrollDirection: Axis.vertical,
              child: Text(
                widget.note,
                textScaleFactor: _scaleFactor,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: noteFontSize),
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
                  _scaleFactor = _baseScaleFactor * details.scale;
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 100,
                height: MediaQuery.of(context).size.height,
                child: GestureDetector(
                  onVerticalDragUpdate: (details) {
                    setState(() {
                      _scaleFactor *= 1 - details.delta.dy / 50;
                    });
                  },
                ),
              ),
              Container(
                width: 100,
                height: MediaQuery.of(context).size.height,
                child: GestureDetector(
                  onVerticalDragUpdate: (details) async {
                    double brightness =
                        await Screen.brightness - details.delta.dy / 500;

                    if (brightness >= 0 && brightness <= 1) {
                      Screen.setBrightness(brightness);
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
