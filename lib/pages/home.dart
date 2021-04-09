import 'package:board/pages/drawer.dart';
import 'package:board/pages/note.dart';
import 'package:board/themes/board_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({Key key, this.title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            tooltip: 'Menu',
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: <Widget>[
          new IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search',
            onPressed: () => {
              // TODO: implement this
              throw UnimplementedError()
            },
          ),
          new IconButton(
            icon: const Icon(Icons.more_vert),
            tooltip: 'More',
            onPressed: () => {
              // TODO: implement this
              throw UnimplementedError()
            },
          ),
        ],
      ),
      body: Center(
        child: ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: entries.length,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              key: UniqueKey(),
              onDismissed: (direction) {
                if (direction == DismissDirection.startToEnd) {
                  String deletedNote = _deleteNote(index);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("$deletedNote deleted"),
                    action: SnackBarAction(
                      label: "UNDO",
                      onPressed: () => {
                        setState(() {
                          _addColorCodes();
                          if (entries.length > index) {
                            entries.insert(index, deletedNote);
                          } else {
                            entries.insert(entries.length, deletedNote);
                          }
                        })
                      },
                    ),
                  ));
                } else if (direction == DismissDirection.endToStart) {
                  // TODO: implement this
                  String deletedNote = _deleteNote(index);
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("$deletedNote deleted")));
                }
              },
              background: Container(
                padding: const EdgeInsets.all(8.0),
                color: Colors.red,
                alignment: Alignment.centerLeft,
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              secondaryBackground: Container(
                padding: const EdgeInsets.all(8.0),
                color: Colors.orange,
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              child: Container(
                constraints: BoxConstraints(minHeight: 50),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        return BoardThemeData.primarySwatch[colorCodes[index]];
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
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        tooltip: 'Add a note',
        child: Icon(Icons.add),
      ),
      drawer: NavDrawer(),
    );
  }

  void _addColorCodes() {
    if (colorCodes.isNotEmpty) {
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
    } else {
      colorCodes.add(900);
      isColorCodesIncreasing = false;
    }
  }

  void _addNote() async {
    String newNote = await _showTextEditDialog('New Note', 'Note', null);

    setState(() {
      if (newNote != null) {
        _addColorCodes();
        entries.add(newNote);
      }
    });
  }

  String _deleteNote(int index) {
    String deletedNote = entries[index];

    setState(() {
      entries.removeAt(index);
      colorCodes.removeLast();
    });

    return deletedNote;
  }

  _editNote(int index) async {
    String editedNote =
        await _showTextEditDialog('Edit Note', 'Note', entries[index]);

    setState(() {
      entries[index] = editedNote;
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
          return NotePage(note: note);
        },
      ),
    );
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
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      child: Text('Cancel'),
                      onPressed: () => {Navigator.pop(context, prefilledText)}),
                  TextButton(
                      child: Text('Save'),
                      onPressed: () =>
                          {Navigator.pop(context, _controller.text)}),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
