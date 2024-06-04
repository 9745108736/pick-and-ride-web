import 'package:flutter/material.dart';

class ColorNotifier with ChangeNotifier {
get blackcolor => isDark ? const Color(0xFFFFFFFF) : const Color(0xFF000000);
get blackwhitecolor => isDark ? const Color(0xFF000000) : const Color(0xFFFFFFFF);
get backgroundColor => isDark ? const Color(0xFF141416) : const Color(0xFFFFFFFF);
get whitecolor => isDark ? const Color(0xFF23262F) : const Color(0xFFFFFFFF);
get yellowcolor => const Color(0xFFFFD166);
get redcolor => const Color(0xFFFF0000);
get containerBGColor => const Color(0xffF5F5F5);
get lightPurplecolor => const Color(0xFFD6C1F8);
get purplecolor => const Color(0xFF38D430);
get searchgrey => const Color(0xFFF8F8F8);
get grey03 => const Color(0xFFF0F0F0);
get grey04 => const Color(0xFFE1E7EE);
get xlightPurplecolor => const Color(0xFFF2E9FF);
get bluecolor => const Color(0xFF051036);
get pinkcolor => const Color(0xFFD63955);
get lightgreencolor => const Color(0xFF58C27D);
get textcolor => const Color(0xFF23262F);
get buttoncolor => const Color(0xFF3B71FE);
get greycolor => const Color(0xFF777E90);
get lightgreycolor => isDark ? const Color(0xFF18191D) :  const Color(0xFFF4F5F6);
get subgreycolor => const Color(0xFF777E90);
get sugestionbutton => isDark ? const Color(0xFF353945) : const Color(0xFFE6E8EC);
get advchips => const Color(0xFFF0F6FD);
get su1 => const Color(0xFF8BC5E5);
get su2 => const Color(0xFF92A5EF);
get lightblue => const Color(0xFFEAF5FF);
get hostBGColor => isDark ? const Color(0xFF23262F) : const Color(0xFFFBF8F1);
get addHostcolor => const Color(0xFFC45B2B);
bool _isDark = false;
bool get isDark => _isDark;

void isAvailable(bool value) {
  _isDark = value;
  notifyListeners();
}
}