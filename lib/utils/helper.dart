import 'package:board/models/note.dart';

class Helper {
  static void updateColorCodes(List<Note> notes) {
    const int maxColorCode = 900;
    const int minColorCode = 100;
    const int step = 100;

    int curColorCode = maxColorCode;
    bool isColorCodesIncreasing = false;

    for (var note in notes) {
      if (isColorCodesIncreasing) {
        note.colorCode = curColorCode;
        curColorCode += step;
        if (curColorCode >= maxColorCode) {
          isColorCodesIncreasing = false;
        }
      } else {
        note.colorCode = curColorCode;
        curColorCode -= step;
        if (curColorCode <= minColorCode) {
          isColorCodesIncreasing = true;
        }
      }
    }
  }
}
