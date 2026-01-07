import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget customTextForm({
  required BuildContext context,
  String? fieldname,
  String? hint,
  Function? validator,
  required TextEditingController controller,
  Widget? icon,
  obscureText = false,
}) {
  return TextFormField(
    obscureText: obscureText,
    style: TextStyle(
      fontSize: 18,
    ),
    controller: controller,
    validator: (value) {
      return validator?.call(value);
    },
    maxLength: 100,

    cursorColor: Colors.black,

    // keyboardType: inputType,
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.transparent,
      // border: InputBorder.none,
      // focusedBorder: InputBorder.none,
      // enabledBorder: InputBorder.none,
      // errorBorder: InputBorder.none,
      // disabledBorder: InputBorder.none,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
        borderRadius: BorderRadius.circular(100),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
        borderRadius: BorderRadius.circular(100),
      ),
      errorBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: Color.fromARGB(255, 118, 0, 253), width: 2),
        borderRadius: BorderRadius.circular(100),
      ),
      prefixIcon: (icon != null)
          ? Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[icon],
              ),
            )
          : Container(),

      contentPadding: EdgeInsets.only(left: 15, bottom: 15, top: 15, right: 15),
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
    ),
  );
}

Widget commonTextForm({
  required BuildContext context,
  required String fieldname,
  required String hint,
  required Function validator,
  required TextEditingController controller,
  Widget? icon,
  obscureText = false,
  bool? enable,
  TextInputType? keyboard,
}) {
  return TextFormField(
    obscureText: obscureText,
    style: TextStyle(
        fontSize: 16, color: Colors.white, fontWeight: FontWeight.w400),
    controller: controller,
    validator: (value) {
      return validator(value);
    },
    enabled: enable,
    maxLength: 100,
    cursorColor: Colors.white,
    keyboardType: keyboard ?? TextInputType.text,
    inputFormatters: keyboard == TextInputType.number
        ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
        : null,
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.transparent,
      // // border: InputBorder.none,
      // focusedBorder: InputBorder.none,
      // enabledBorder: InputBorder.none,
      // errorBorder: InputBorder.none,
      disabledBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: Color.fromARGB(255, 61, 61, 61), width: 2),
        borderRadius: BorderRadius.circular(100),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white70, width: 2),
        borderRadius: BorderRadius.circular(100),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white70, width: 2),
        borderRadius: BorderRadius.circular(100),
      ),
      errorBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: Color.fromARGB(255, 118, 0, 253), width: 2),
        borderRadius: BorderRadius.circular(100),
      ),
      prefixIcon: (icon != null)
          ? Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[icon],
              ),
            )
          : Container(
              margin: EdgeInsets.only(left: 0),
              child: SizedBox(width: 0),
            ),

      contentPadding: EdgeInsets.only(left: 0, bottom: 5, top: 5, right: 0),
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
    ),
  );
}
