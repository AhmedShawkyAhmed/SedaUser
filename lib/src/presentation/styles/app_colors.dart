import 'package:flutter/material.dart';

class AppColors {
  static const Color transparent = Colors.transparent;
  static const Color primary = Color(0xFF278977);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color black1 = Color(0xFF282828);
  static const Color darkGrey = Color(0xFF434343);
  static const Color grey = Color(0xFF6C6C6C);
  static const Color lightGrey = Color(0xFFE9E9E9);
  static const Color grey1 = Color(0xFFFAFAFA);
  static const Color grey2 = Color(0xFFA7A7A7);
  static const Color midGrey = Color(0xFFD1D1D1);
  static const Color shadowGrey = Color.fromARGB(35, 13, 13, 46);
  static const Color test = Color(0xFFF5F5F5);
  static const Color green = Color(0xFF38B190);
  static const Color green1 = Color(0xFF33AD88);
  static const Color midGreen = Color(0xFF268575);
  static const Color lightGreen = Color(0xFF42CAA2);
  static const Color darkGreen = Color(0xFF145759);
  static const Color fadedGreen = Color(0xFFE3FEF6);
  static const Color darkBlue = Color(0xFF294563);
  static const Color blue = Color(0xFF42D4F4);
  static const Color orange = Color(0xFFED8A19);
  static const Color yellow = Color(0xFFFFCE42);
  static const Color lightRed = Color(0xFFF15C5C);
  static const Color red = Color(0xFFFF0000);
  static const Color darkRed = Color(0xFFF40606);
  static const Color pink = Color(0xFFFF00C4);
  static const Color lightBlue = Color(0xFF4394CE);

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
