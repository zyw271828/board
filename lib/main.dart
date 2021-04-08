import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Board',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Board'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> entries = <String>[
    'Note A',
    'Note B',
    'Note C',
    'Note D',
    'Note E',
    'Note F'
  ];
  List<int> colorCodes = <int>[900, 800, 700, 600, 500, 400];
  bool isColorCodesIncreasing = false;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        leading: new IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => {
                  // TODO: implement this
                  throw UnimplementedError()
                }),
        actions: <Widget>[
          new IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => {
                    // TODO: implement this
                    throw UnimplementedError()
                  }),
          new IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () => {
                    // TODO: implement this
                    throw UnimplementedError()
                  }),
        ],
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: entries.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                constraints: BoxConstraints(minHeight: 50),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        return Colors.blue[colorCodes[index]];
                      },
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                  ),
                  child: Container(
                      child: Center(child: Text(entries[index])),
                      padding: const EdgeInsets.all(8.0)),
                  onPressed: () => _showNote(entries[index]),
                  onLongPress: () => _editNote(index),
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        tooltip: 'Add a note',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _addNote() async {
    String newNote = await _showTextEditDialog('New Note', 'Note', null);

    setState(() {
      if (newNote != null) {
        entries.add(newNote);

        if (isColorCodesIncreasing) {
          colorCodes.add(colorCodes.last + 100);
          if (colorCodes.last == 900) {
            isColorCodesIncreasing = false;
          }
        } else {
          colorCodes.add(colorCodes.last - 100);
          if (colorCodes.last == 100) {
            isColorCodesIncreasing = true;
          }
        }
      }
    });
  }

  void _showNote(String note) {
    // Enter landscape mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // Enter fullscreen mode
    SystemChrome.setEnabledSystemUIOverlays([]);

    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return new Scaffold(
            appBar: new AppBar(
              title: Text(note),
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
            ),
            body: Center(
                child: SingleChildScrollView(
              padding: const EdgeInsets.all(50.0),
              scrollDirection: Axis.vertical,
              child: Text(
                note,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 80),
              ),
            )),
          );
        },
      ),
    );
  }

  _editNote(int index) async {
    String editedNote =
        await _showTextEditDialog('Edit Note', 'Note', entries[index]);

    setState(() {
      entries[index] = editedNote;
    });
  }

  Future<String> _showTextEditDialog(
      String title, String label, String prefilledText) async {
    final _controller = TextEditingController();
    _controller.text = prefilledText;

    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(title),
          children: <Widget>[
            Container(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _controller,
                  autofocus: true,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: label,
                  ),
                )),
            Container(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        child: Text('Cancel'),
                        onPressed: () =>
                            {Navigator.pop(context, prefilledText)}),
                    TextButton(
                        child: Text('Save'),
                        onPressed: () =>
                            {Navigator.pop(context, _controller.text)}),
                  ],
                )),
          ],
        );
      },
    );
  }
}
