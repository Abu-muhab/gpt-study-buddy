import 'package:flutter/material.dart';

class AppColors {
  static const Color secondaryColor = Color(0xFF495774);
  static const Color secondaryColorLight = Color(0xFFE0E1EF);
  static const Color black = Color(0xFF2E3749);
  static const Color blueBlack = Color(0xFF49454F);
  static const Color pink = Color(0xFFDF8192);
  static const Color textColor = Color(0xff515867);
  static const Color error = Color(0xffB80000);
  static MaterialColor primaryColor =
      MaterialColor(const Color.fromARGB(255, 2, 20, 48).value, const {
    50: Color.fromARGB(255, 2, 22, 54),
    100: Color.fromARGB(255, 2, 24, 60),
    200: Color.fromARGB(255, 2, 26, 66),
    300: Color.fromARGB(255, 2, 28, 72),
    400: Color.fromARGB(255, 2, 30, 78),
    500: Color.fromARGB(255, 2, 32, 84),
    600: Color.fromARGB(255, 2, 34, 90),
    700: Color.fromARGB(255, 2, 36, 96),
    800: Color.fromARGB(255, 2, 38, 102),
    900: Color.fromARGB(255, 2, 40, 108),
  });
}
