import 'package:flutter/material.dart';

class OverlayLoading extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final Widget? customLoading;
  final bool opacityBackground;
  const OverlayLoading(
      {Key? key,
      required this.child,
      this.isLoading = false,
      this.customLoading,
      this.opacityBackground = true})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        child,
        if (isLoading && opacityBackground)
          Positioned.fill(
            child: Opacity(
              opacity: 0.5,
              child: Container(
                color: Colors.black,
              ),
            ),
          ),
        if (isLoading)
          Positioned.fill(
            child: Center(
              child: customLoading ??
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),
            ),
          ),
      ],
    );
  }
}
