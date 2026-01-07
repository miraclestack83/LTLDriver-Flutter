import 'package:flutter/material.dart';

import '../../../Widgets/custom_appbar.dart';

class TripsHistory extends StatelessWidget {
  const TripsHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Trips History"),
    );
  }
}
