import 'package:flutter/material.dart';
import 'package:opentrip/Widgets/index.dart';

Widget LoadingContainer({
  required BuildContext context,
  required bool isLoading,
  required Widget child,
  double? height,
  Color? backgroundColor,
  String? message,
}) {
  return WillPopScope(
    onWillPop: () async {
      Navigator.of(context).pop();
      return false;
    },
    child: Stack(
      children: <Widget>[
        child,
        (isLoading)
            ? Positioned.fill(
                left: 0,
                top: 0,
                child: Container(
                  // height: height ?? MediaQuery.of(context).size.height,
                  // width: MediaQuery.of(context).size.width,
                  color: backgroundColor ??
                      Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      LoadingWidget(
                        loadingColor: Colors.white,
                      ),
                      if (message != null)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            message,
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                decoration: TextDecoration.none),
                          ),
                        )
                    ],
                  ),
                ),
              )
            : Container()
      ],
    ),
  );
}
