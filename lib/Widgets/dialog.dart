import 'package:flutter/material.dart';

class Dialogs {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key, String title) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: () async {
                Navigator.of(context).pop();
                return false;
              },
              child: SimpleDialog(
                  key: key,
                  backgroundColor: Colors.white,
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        CircularProgressIndicator(),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        )
                      ]),
                    )
                  ]));
        });
  }

  static Future<void> showLoadingDarkDialog(
      BuildContext context, GlobalKey key, String title) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: () async {
                Navigator.of(context).pop();
                return false;
              },
              child: SimpleDialog(
                  key: key,
                  backgroundColor: Theme.of(context).primaryColor,
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          title,
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        )
                      ]),
                    )
                  ]));
        });
  }

  // Loading Progressbar Dialog
  static Future<void> showProgressBarDialog(
      BuildContext context, GlobalKey key, String title) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: () async {
                Navigator.of(context).pop();
                return false;
              },
              child: SimpleDialog(
                  key: key,
                  backgroundColor: Colors.white,
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          title,
                          style: TextStyle(color: Colors.black),
                        )
                      ]),
                    )
                  ]));
        });
  }
}
