import 'package:board/models/note.dart';
import 'package:board/pages/drawer.dart';
import 'package:board/pages/note.dart';
import 'package:board/themes/board_theme_data.dart';
import 'package:board/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({Key key, this.title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Note> notes = <Note>[
    Note('Note A', 900),
    Note('Note B', 800),
    Note('Note C', 700),
    Note('Note D', 600),
    Note('Note E', 500),
    Note('Note F', 400),
  ];
  bool _isSearchButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isSearchButtonPressed
          ? AppBar(
              leading: Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.arrow_back),
                  tooltip: 'Back',
                  onPressed: () => setState(() {
                    _isSearchButtonPressed = !_isSearchButtonPressed;
                    // TODO: unfinished notes search
                    // TODO: do the same when using NavBar
                  }),
                ),
              ),
              title: Container(
                child: TextField(
                  autofocus: true,
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search Note',
                    hintStyle: TextStyle(color: Colors.white),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    _searchNote(notes, value);
                  },
                ),
              ),
            )
          : AppBar(
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
                  onPressed: () => setState(() {
                    _isSearchButtonPressed = !_isSearchButtonPressed;
                    // TODO: unfinished notes search
                  }),
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
          itemCount: notes.length,
          itemBuilder: (BuildContext context, int index) {
            return _generateNoteDismissible(notes, index);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNote(notes),
        tooltip: 'Add a note',
        child: Icon(Icons.add),
      ),
      drawer: NavDrawer(),
    );
  }

  void _addNote(List<Note> notes) async {
    Note newNote =
        await _showTextEditDialog('New Note', 'Note', Note(null, 900));

    setState(() {
      if (newNote.content != null) {
        notes.add(newNote);
        Helper.updateColorCodes(notes);
      }
    });
  }

  Note _deleteNote(List<Note> notes, int index) {
    Note deletedNote = notes[index];

    setState(() {
      notes.removeAt(index);
      Helper.updateColorCodes(notes);
    });

    return deletedNote;
  }

  void _editNote(List<Note> notes, int index) async {
    Note editedNote =
        await _showTextEditDialog('Edit Note', 'Note', notes[index]);

    setState(() {
      notes[index] = editedNote;
    });
  }

  Container _generateNoteContainer(List<Note> notes, int index) {
    return Container(
      constraints: BoxConstraints(minHeight: 50),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              return BoardThemeData.primarySwatch[notes[index].colorCode];
            },
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
        ),
        child: Container(
            child: Center(child: Text(notes[index].content)),
            padding: const EdgeInsets.all(8.0)),
        onPressed: () => _showNote(notes[index]),
        onLongPress: () => _editNote(notes, index),
      ),
    );
  }

  Dismissible _generateNoteDismissible(List<Note> notes, int index) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          Note deletedNote = _deleteNote(notes, index);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("${deletedNote.content} deleted"),
              action: SnackBarAction(
                label: "UNDO",
                onPressed: () => {
                  setState(() {
                    if (notes.length > index) {
                      notes.insert(index, deletedNote);
                    } else {
                      notes.insert(notes.length, deletedNote);
                    }
                    Helper.updateColorCodes(notes);
                  })
                },
              ),
            ),
          );
        } else if (direction == DismissDirection.endToStart) {
          // TODO: implement this
          Note deletedNote = _deleteNote(notes, index);
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("${deletedNote.content} deleted")));
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
      child: _generateNoteContainer(notes, index),
    );
  }

  void _searchNote(List<Note> notes, String value) {
    // TODO: unfinished notes search
  }

  void _showNote(Note note) {
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

  Future<Note> _showTextEditDialog(
      String title, String label, Note prefilledNote) async {
    final _controller = TextEditingController();

    _controller.text = prefilledNote.content;

    return showDialog<Note>(
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
                      onPressed: () => {Navigator.pop(context, prefilledNote)}),
                  TextButton(
                      child: Text('Save'),
                      onPressed: () => {
                            Navigator.pop(context,
                                Note(_controller.text, prefilledNote.colorCode))
                          }),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
