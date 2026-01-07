import 'package:flutter/material.dart';

Widget RoundButton({
  required BuildContext context,
  required Function onTap,
  required String title,
  Icon? icon,
  Color? backColor,
  Color? textColor,
}) {
  return Container(
    height: 45,
    child: MaterialButton(
      elevation: 6.0,
      onPressed: () {
        onTap();
      },
      color: backColor ?? Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          icon ?? Container(),
          icon != null ? SizedBox(width: 10) : Container(),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18,
                color: textColor ?? Colors.white,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
  );
}
