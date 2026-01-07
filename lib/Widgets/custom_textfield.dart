import 'package:flutter/material.dart';

import '../Pages/App/Styles/colors.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final TextInputType? textInputType;
  const CustomTextField(
      {Key? key, this.controller, this.onChanged, this.textInputType})
      : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.textInputType,
      controller: widget.controller,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Colors.lightBlue,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Colors.lightBlue,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 17, vertical: 13),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Colors.lightBlue,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Colors.lightBlue,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Colors.lightBlue,
          ),
        ),
      ),
    );
  }
}
