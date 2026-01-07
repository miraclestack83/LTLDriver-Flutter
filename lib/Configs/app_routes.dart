import 'package:flutter/material.dart';

class AppRoutes {
  static Future push(BuildContext context, Widget page) async {
    return Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}
