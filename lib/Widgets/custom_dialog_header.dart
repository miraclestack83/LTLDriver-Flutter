import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget dialogCamera(BuildContext context) {
  return Container(
    child: FaIcon(
      // FontAwesomeIcons.camera,
      Icons.camera,
      color: Theme.of(context).primaryColor,
      size: 80.0,
    ),
  );
}
