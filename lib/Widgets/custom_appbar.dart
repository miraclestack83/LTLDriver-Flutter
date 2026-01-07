import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final PreferredSizeWidget? bottom;
  final double? height;
  final bool centerTitle;
  const CustomAppBar(
      {Key? key,
      required this.title,
      this.bottom,
      this.height,
      this.centerTitle = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: Text(title),
      centerTitle: centerTitle,
      backgroundColor: Theme.of(context).primaryColor,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height ?? kToolbarHeight);
}
