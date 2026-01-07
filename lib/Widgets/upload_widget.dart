import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget uploadWidget({required BuildContext context, File? file}) {
  return Container(
    height: 100,
    margin: const EdgeInsets.symmetric(vertical: 30),
    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: Theme.of(context).primaryColor,
      boxShadow: [
        BoxShadow(
          color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 5,
          offset: Offset(1, 3), // changes position of shadow
        ),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Icon(
          FontAwesomeIcons.file,
          size: 50,
          color: Colors.grey,
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: Text(
            (file != null) ? file.path : "Please choose file",
            style: const TextStyle(
                color: Colors.grey, fontSize: 18, fontStyle: FontStyle.italic),
          ),
        )
      ],
    ),
  );
}
