import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ToastAlart {
  static void success(BuildContext context, String msg) {
    // showTopSnackBar(
    //   OverlayState(),
    //   CustomSnackBar.success(
    //     message: msg,
    //   ),
    // );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.green, // Customize the background color
        duration: Duration(seconds: 3), // How long the Snackbar is visible
      ),
    );
  }

  // Info Alert
  static void info(BuildContext context, String msg) {
    // showTopSnackBar(
    //   OverlayState(),
    //   CustomSnackBar.info(
    //     message: msg,
    //   ),
    // );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.blue, // Customize the background color
        duration: Duration(seconds: 3), // How long the Snackbar is visible
      ),
    );
  }

  // Warning Alert
  // static void warning(BuildContext context, String msg) {
  //   showTopSnackBar(
  //     context,
  //     CustomSnackBar(
  //       message: msg,
  //     ),
  //   );
  // }

  // Error alert
  static void error(BuildContext context, String msg) {
    // Warning Alert
    // showTopSnackBar(
    //   OverlayState(),
    //   CustomSnackBar.error(
    //     message: msg,
    //   ),
    // );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red, // Customize the background color
        duration: Duration(seconds: 3), // How long the Snackbar is visible
      ),
    );
  }
}
