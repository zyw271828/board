import 'package:board/models/note.dart';
import 'package:board/pages/drawer.dart';
import 'package:board/pages/note.dart';
import 'package:board/services/local_storage_service.dart';
import 'package:board/utils/helper.dart';
import 'package:board/widgets/board_widgets.dart';
import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/board_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

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
    return WillPopScope(
      onWillPop: () {
        if (_isSearchButtonPressed) {
          _playAnimation();
          _exitSearchMode();
          return Future<bool>.value(false);
        } else {
          return Future<bool>.value(true);
        }
      },
      child: Scaffold(
        appBar: _isSearchButtonPressed
            ? AppBar(
                leading: Builder(
                  builder: (context) => IconButton(
                    icon: AnimatedIcon(
                      icon: AnimatedIcons.menu_arrow,
                      progress: _animationController,
                    ),
                    tooltip: AppLocalizations.of(context).back,
                    onPressed: () {
                      _playAnimation();
                      _exitSearchMode();
                    },
                  ),
                ),
                title: Container(
                  child: TextField(
                    autofocus: true,
                    cursorColor:
                        Theme.of(context).accentTextTheme.bodyText1.color,
                    style: TextStyle(
                        color:
                            Theme.of(context).accentTextTheme.bodyText1.color),
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context).searchNote,
                      hintStyle: TextStyle(
                          color: Theme.of(context)
                              .accentTextTheme
                              .bodyText1
                              .color),
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
                title: Text(AppLocalizations.of(context).appName),
                leading: Builder(
                  builder: (context) => IconButton(
                    icon: AnimatedIcon(
                      icon: AnimatedIcons.menu_arrow,
                      progress: _animationController,
                    ),
                    tooltip: AppLocalizations.of(context).menu,
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
                actions: <Widget>[
                  new IconButton(
                    icon: const Icon(Icons.search),
                    tooltip: AppLocalizations.of(context).search,
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
                    tooltip: AppLocalizations.of(context).more,
                    itemBuilder: (BuildContext context) {
                      return {
                        AppLocalizations.of(context).about,
                        AppLocalizations.of(context).exit
                      }.map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(choice),
                        );
                      }).toList();
                    },
                    onSelected: (choice) {
                      if (choice == AppLocalizations.of(context).about) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return BoardWidgets.generateAboutDialog(context);
                          },
                        );
                      } else if (choice == AppLocalizations.of(context).exit) {
                        SystemChannels.platform
                            .invokeMethod('SystemNavigator.pop');
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
                child: ReorderableListView.builder(
                  buildDefaultDragHandles: false,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: notes.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _generateNoteDismissible(notes, index);
                  },
                  onReorder: (int oldIndex, int newIndex) {
                    setState(() {
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }
                      var note = notes.removeAt(oldIndex);
                      notes.insert(newIndex, note);
                      Helper.updateColorCodes(notes);
                    });

                    LocalStorageService.saveNote(notes);
                  },
                ),
              ),
        floatingActionButton: _isSearchButtonPressed
            ? null
            : FloatingActionButton(
                onPressed: () => _addNote(notes),
                tooltip: AppLocalizations.of(context).addANote,
                child: Icon(Icons.add),
              ),
        drawer: _isSearchButtonPressed ? null : NavDrawer(),
      ),
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
    Note newNote = await _showTextEditDialog(
        AppLocalizations.of(context).newNote,
        AppLocalizations.of(context).note,
        Note(null, 900));

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
    Note editedNote = await _showTextEditDialog(
        AppLocalizations.of(context).editNote,
        AppLocalizations.of(context).note,
        notes[index]);

    setState(() {
      notes[index] = editedNote;
    });

    LocalStorageService.saveNote(notes);
  }

  _exitSearchMode() {
    setState(() {
      _isSearchButtonPressed = !_isSearchButtonPressed;
      // notes.clear();
      // notes.addAll(duplicateNotes);
      duplicateNotes.clear();
      // Helper.updateColorCodes(notes);
      // ScaffoldMessenger.of(context).hideCurrentSnackBar();
    });
  }

  Container _generateNoteContainer(List<Note> notes, int index) {
    ColorSwatch swatch;
    if (Helper.isLightTheme(DynamicTheme.of(context).themeId)) {
      swatch = Colors.primaries[DynamicTheme.of(context).themeId];
    } else {
      // Dark theme, but use the Colors.primaries of the light theme
      swatch = Colors.primaries[
          Helper.generateLightThemeId(DynamicTheme.of(context).themeId)];
    }

    return Container(
      child: Stack(
        alignment: Alignment.center,
        children: [
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  swatch[notes[index].colorCode]),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
            ),
            child: Container(
              constraints: BoxConstraints(minHeight: 50),
              child: Center(child: Text(notes[index].content)),
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
            ),
            onPressed: () => _showNote(notes, index),
            onLongPress: () =>
                _isSearchButtonPressed ? null : _editNote(notes, index),
          ),
          ReorderableDragStartListener(
            index: index,
            child: Container(
              constraints: BoxConstraints(minHeight: 50),
              alignment: Alignment.centerRight,
              child: Icon(
                _isSearchButtonPressed ? null : Icons.drag_handle,
                color: Theme.of(context).accentTextTheme.bodyText1.color,
              ),
              padding: const EdgeInsets.all(8.0),
            ),
          ),
        ],
      ),
    );
  }

  Dismissible _generateNoteDismissible(List<Note> notes, int index) {
    return Dismissible(
      key: ObjectKey(notes[index]),
      dismissThresholds: <DismissDirection, double>{
        DismissDirection.startToEnd: 0.4,
        DismissDirection.endToStart: 0.4,
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd ||
            direction == DismissDirection.endToStart) {
          Note deletedNote = _deleteNote(notes, index);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("${deletedNote.content} " +
                  AppLocalizations.of(context).deleted),
              action: SnackBarAction(
                label: AppLocalizations.of(context).undo,
                onPressed: () {
                  _undoDeleteNote(deletedNote, notes, index);
                },
              ),
            ),
          );
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
        color: Colors.red,
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

  void _showNote(List<Note> notes, int index) {
    Helper.enterDisplayMode();

    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return NotePage(notes: notes, index: index);
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
                      child: Text(AppLocalizations.of(context).cancel),
                      onPressed: () => {Navigator.pop(context, prefilledNote)}),
                  TextButton(
                      child: Text(AppLocalizations.of(context).save),
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
