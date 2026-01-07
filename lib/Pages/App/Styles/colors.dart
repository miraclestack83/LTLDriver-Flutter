import 'package:flutter/material.dart';

class AppColors {
  Color retryBtnColor = Colors.lightBlue;
  static Color errorTxtColor = Colors.red;
  Color listDividColor = Colors.grey;
  Color dateColor = Colors.red;

  //===================== Main Theme Colors  ==========
  // Light
  Color backgroundColor = Colors.white;

  Color backgroundColorDark = Colors.black;
  static Color textColor = Colors.black;

  static Color primary(context) {
    return Theme.of(context).primaryColor;
  }

  static Color white(context) {
    return Colors.white;
  }

  static Color black(context) {
    return Colors.black;
  }

  static Color grey1(context) {
    return const Color(0xff818181);
  }
}
