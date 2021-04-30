import 'dart:convert';

import 'package:board/models/note.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static Future<List<Note?>> loadNote() async {
    List<Note?> notes = <Note?>[];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? numberOfNotes = prefs.getInt('numberOfNotes');

    if (numberOfNotes != null) {
      for (var i = 0; i < numberOfNotes; i++) {
        String jsonString = prefs.getString('note' + i.toString())!;
        Map noteMap = jsonDecode(jsonString);
        var note = Note.fromJson(noteMap as Map<String, dynamic>);
        notes.add(note);
      }
    } else {
      notes = <Note?>[
        Note('john.smith@example.com', 900),
        Note('+1 (123) 456-7891', 800),
        Note(
            '1 Montgomery Street,\nSuite 1600, San Francisco,\nCalifornia 94104',
            700),
        Note('https://www.example.com', 600),
        Note('PGP: 1234 5678 9ABC\nDEF1 2345 6789 ABCD\nEF12 3456 789A', 500),
        Note('Support **Markdown**', 400),
      ];
    }
    return notes;
  }

  static Future<double> loadScreenBrightness() async {
    double? screenBrightness;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    screenBrightness = prefs.getDouble('screenBrightness');

    if (screenBrightness == null) {
      return -1.0;
    } else {
      return screenBrightness;
    }
  }

  static saveNote(List<Note?> notes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int? numberOfNotes = prefs.getInt('numberOfNotes');
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

  static saveScreenBrightness(double screenBrightness) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setDouble('screenBrightness', screenBrightness);
  }
}
