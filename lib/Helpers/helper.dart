import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:opentrip/Helpers/index.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class Helpers {
  static String formatDateTime(String dateTime, {String? fomat}) {
    try {
      return DateFormat(fomat ?? "yyyy/MM/dd")
          .format(DateTime.parse(dateTime).toLocal());
    } catch (e) {
      return '';
    }
  }

  static Future<File> saveBytesToTemporaryFile(
      {required Uint8List uint8list, required String extension}) async {
    var documents = await getTemporaryDirectory();

    var output =
        '${documents.path}/file_${DateTime.now().millisecondsSinceEpoch}.$extension';
    var file = File(output);
    await file.writeAsBytes(uint8list);
    return file;
  }

  static Future<File> getVideoThumbnail(File file) async {
    final uint8list = await VideoThumbnail.thumbnailData(
      video: file.path,
      imageFormat: ImageFormat.JPEG,
      quality: 60,
    );
    return saveBytesToTemporaryFile(
        uint8list: uint8list!, extension: file.path.split('.').last);
  }

  static String fixFileName(String filename) {
    RegExp regExp = RegExp('[/\\\\:*?"<>|]');
    String newFileName = filename.replaceAll(regExp, '_');
    print(newFileName); // Output: 'file 2023_23_23.png'
    return newFileName;
  }

  static Color getRandomColorFromList() {
    List<Color> colorList = [
      Color(0xFF3498db), // Dodger Blue
      Color(0xFFe74c3c), // Alizarin Crimson
      Color(0xFF2ecc71), // Emerald
      Color(0xFFf39c12), // Sunflower
      Color(0xFF1abc9c), // Turquoise
      Color(0xFF9b59b6), // Amethyst
      Color(0xFF2c3e50), // Midnight Blue
      Color(0xFFe67e22), // Carrot
      Color(0xFF16a085), // Green Sea
      Color(0xFFc0392b), // Pomegranate
      Color(0xFF27ae60), // Nephritis
      Color(0xFFf1c40f), // Sunflower
      Color(0xFF2980b9), // Belize Hole
      Color(0xFFd35400), // Pumpkin
      Color(0xFF8e44ad), // Wisteria
      Color(0xFF34495e), // Wet Asphalt
      Color(0xFFe67e22), // Carrot
      Color(0xFF2c3e50), // Midnight Blue
      Color(0xFFe74c3c), // Alizarin Crimson
      Color(0xFF3498db), // Dodger Blue
    ];

    Random random = Random();
    return colorList[random.nextInt(colorList.length)];
  }
}

hideKeyboard(BuildContext context) {
  FocusScope.of(context).requestFocus(FocusNode());
}

String formatRoleName(String role) {
  if (role == UserRole.DRIVER) {
    return "Driver";
  } else if (role == UserRole.FORK_LIFT_OPERATOR) {
    return "Forklift Operator";
  } else if (role == UserRole.DISPATCHER) {
    return "Dispatcher";
  }
  return role;
}
