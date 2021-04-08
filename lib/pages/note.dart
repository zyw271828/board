import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NotePage extends StatefulWidget {
  final String note;

  const NotePage({Key key, @required this.note}) : super(key: key);

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

                Navigator.of(context).pop();
              },
            );
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(50.0),
          scrollDirection: Axis.vertical,
          child: Text(
            widget.note,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 80),
          ),
        ),
      ),
    );
  }
}
