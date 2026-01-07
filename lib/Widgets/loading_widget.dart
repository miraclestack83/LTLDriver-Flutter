import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
// import 'package:touch_ripple_effect/touch_ripple_effect.dart';

Widget LoadingWidget({
  Widget? icon,
  Widget? loadText,
  Color? loadingColor,
  Color? textColor,
}) {
  List<Color> _kDefaultRainbowColors = [
    // Colors.red,
    // Colors.orange,
    // Colors.yellow,
    // Colors.green,
    loadingColor ?? Colors.blue,
    // Colors.indigo,
    // Colors.purple,
  ];
  return Center(
    child: Container(
      child: Column(
        children: <Widget>[
          icon ?? Container(),
          SizedBox(
            height: 20,
          ),
          Container(
            width: 50,
            child: LoadingIndicator(
              indicatorType: Indicator.ballRotateChase,

              /// Required, The loading type of the widget
              colors: _kDefaultRainbowColors,

              /// Optional, The color collections
              strokeWidth: 4,

              /// Optional, The stroke of the line, only applicable to widget which contains line
              // backgroundColor: Colors.black,

              /// Optional, Background of the widget
              // pathBackgroundColor: Colors.black,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          loadText ?? Container(),
        ],
      ),
    ),
  );
}
