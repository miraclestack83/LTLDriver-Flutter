import 'package:flutter/material.dart';

pop(BuildContext context, {dynamic result}) {
  return Navigator.pop(context, result);
}

push(BuildContext context, Widget page) {
  return Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
}

replace(BuildContext context, Widget page) {
  return Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (_) => page));
}

replaceToRoot(BuildContext context, Widget page) {
  Navigator.popUntil(context, (route) => route.isFirst);
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
}

class NavigationService {
  GlobalKey<NavigatorState>? navigationKey;

  static NavigationService instance = NavigationService();

  NavigationService() {
    navigationKey = GlobalKey<NavigatorState>();
  }
}
