import 'dart:convert';

import 'package:board/models/note.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static Future<List<Note>> loadNote() async {
    List<Note> notes = <Note>[];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int numberOfNotes = prefs.getInt('numberOfNotes');

    if (numberOfNotes != null) {
      for (var i = 0; i < numberOfNotes; i++) {
        String jsonString = prefs.getString('note' + i.toString());
        Map noteMap = jsonDecode(jsonString);
        var note = Note.fromJson(noteMap);
        notes.add(note);
      }
    } else {
      notes = <Note>[
        Note('Note A', 900),
        Note('Note B', 800),
        Note('Note C', 700),
        Note('Note D', 600),
        Note('Note E', 500),
        Note('Note F', 400),
      ];
    }
    return notes;
  }

  static saveNote(List<Note> notes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int numberOfNotes = prefs.getInt('numberOfNotes');
    if (numberOfNotes != null) {
      for (var i = 0; i < numberOfNotes; i++) {
        prefs.remove('note' + i.toString());
      }
    }

    numberOfNotes = notes.length;
    for (var i = 0; i < numberOfNotes; i++) {
      String json = jsonEncode(notes[i]);
      prefs.setString('note' + i.toString(), json);
    }
    prefs.setInt('numberOfNotes', numberOfNotes);
  }
}
