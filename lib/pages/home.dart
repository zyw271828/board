import 'package:board/models/note.dart';
import 'package:board/pages/drawer.dart';
import 'package:board/pages/note.dart';
import 'package:board/services/local_storage_service.dart';
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

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  List<Note> notes = <Note>[];
  List<Note> duplicateNotes = <Note>[];
  bool _isSearchButtonPressed = false;
  bool _isAnimationPlaying = false;
  AnimationController _animationController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isSearchButtonPressed
          ? AppBar(
              leading: Builder(
                builder: (context) => IconButton(
                  icon: AnimatedIcon(
                    icon: AnimatedIcons.menu_arrow,
                    progress: _animationController,
                  ),
                  tooltip: 'Back',
                  onPressed: () {
                    _playAnimation();
                    setState(() {
                      _isSearchButtonPressed = !_isSearchButtonPressed;
                      // notes.clear();
                      // notes.addAll(duplicateNotes);
                      duplicateNotes.clear();
                      // Helper.updateColorCodes(notes);
                      // ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      // TODO: do the same when using NavBar
                    });
                  },
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
                    duplicateNotes.clear();
                    setState(() {
                      for (var index in _searchNote(notes, value)) {
                        duplicateNotes.add(notes[index]);
                      }
                    });
                  },
                ),
              ),
            )
          : AppBar(
              title: Text(widget.title),
              leading: Builder(
                builder: (context) => IconButton(
                  icon: AnimatedIcon(
                    icon: AnimatedIcons.menu_arrow,
                    progress: _animationController,
                  ),
                  tooltip: 'Menu',
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
              actions: <Widget>[
                new IconButton(
                  icon: const Icon(Icons.search),
                  tooltip: 'Search',
                  onPressed: () {
                    _playAnimation();
                    setState(() {
                      _isSearchButtonPressed = !_isSearchButtonPressed;
                      duplicateNotes.clear();
                      duplicateNotes.addAll(notes);
                    });
                  },
                ),
                new PopupMenuButton(
                  icon: const Icon(Icons.more_vert),
                  tooltip: 'More',
                  itemBuilder: (BuildContext context) {
                    return {'About', 'Exit'}.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                  onSelected: (choice) {
                    switch (choice) {
                      case 'About':
                        // TODO: add about dialog
                        break;
                      case 'Exit':
                        SystemChannels.platform
                            .invokeMethod('SystemNavigator.pop');
                        break;
                    }
                  },
                ),
              ],
            ),
      body: _isSearchButtonPressed
          ? Center(
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: duplicateNotes.length,
                itemBuilder: (BuildContext context, int index) {
                  // TODO: use generateNoteDismissible and fix delete & edit
                  return _generateNoteContainer(duplicateNotes, index);
                },
              ),
            )
          : Center(
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: notes.length,
                itemBuilder: (BuildContext context, int index) {
                  return _generateNoteDismissible(notes, index);
                },
              ),
            ),
      floatingActionButton: _isSearchButtonPressed
          ? null
          : FloatingActionButton(
              onPressed: () => _addNote(notes),
              tooltip: 'Add a note',
              child: Icon(Icons.add),
            ),
      drawer: _isSearchButtonPressed ? null : NavDrawer(),
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
    LocalStorageService.loadNote().then((initNotes) {
      setState(() {
        notes = initNotes;
      });
    });
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
  }

  void _addNote(List<Note> notes) async {
    Note newNote =
        await _showTextEditDialog('New Note', 'Note', Note(null, 900));

    if (newNote.content != null) {
      setState(() {
        notes.add(newNote);
        Helper.updateColorCodes(notes);
      });
    }

    LocalStorageService.saveNote(notes);
  }

  Note _deleteNote(List<Note> notes, int index) {
    Note deletedNote = notes[index];

    setState(() {
      notes.removeAt(index);
      Helper.updateColorCodes(notes);
    });

    LocalStorageService.saveNote(notes);
    return deletedNote;
  }

  void _editNote(List<Note> notes, int index) async {
    Note editedNote =
        await _showTextEditDialog('Edit Note', 'Note', notes[index]);

    setState(() {
      notes[index] = editedNote;
    });

    LocalStorageService.saveNote(notes);
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
        onLongPress: () =>
            _isSearchButtonPressed ? null : _editNote(notes, index),
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
                onPressed: () {
                  _undoDeleteNote(deletedNote, notes, index);
                },
              ),
            ),
          );
        } else if (direction == DismissDirection.endToStart) {
          // TODO: sliding to star note
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

  void _playAnimation() {
    setState(() {
      _isAnimationPlaying = !_isAnimationPlaying;
      _isAnimationPlaying
          ? _animationController.forward()
          : _animationController.reverse();
    });
  }

  List<int> _searchNote(List<Note> notes, String value) {
    List<int> result = <int>[];

    for (var i = 0; i < notes.length; i++) {
      if (notes[i].content.toLowerCase().contains(value.toLowerCase())) {
        result.add(i);
      }
    }
    return result;
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

  void _undoDeleteNote(Note deletedNote, List<Note> notes, int index) {
    if (notes.length > index) {
      setState(() {
        notes.insert(index, deletedNote);
        Helper.updateColorCodes(notes);
      });
    } else {
      setState(() {
        notes.insert(notes.length, deletedNote);
        Helper.updateColorCodes(notes);
      });
    }

    LocalStorageService.saveNote(notes);
  }
}
