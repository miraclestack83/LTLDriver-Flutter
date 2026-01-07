import 'package:flutter/material.dart';
import 'package:opentrip/Pages/Trips/Documents/corporate_tabview.dart';
import 'package:opentrip/Pages/Trips/Documents/trailer_tabview.dart';
import 'package:opentrip/Pages/Trips/Documents/truck_tabview.dart';
import 'package:opentrip/Widgets/custom_appbar.dart';

class DocumentsPage extends StatefulWidget {
  final String truckId;
  final String trailerId;
  final String trailerName;
  final String truckName;
  const DocumentsPage(
      {Key? key,
      required this.truckId,
      required this.truckName,
      required this.trailerId,
      required this.trailerName})
      : super(key: key);

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Documents",
          height: kToolbarHeight * 2,
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                text: "Corporate",
              ),
              Tab(
                text: "Truck #${widget.truckName}",
              ),
              Tab(
                text: "Trailer #${widget.trailerName}",
              )
            ],
          ),
        ),
        body: TabBarView(children: [
          CorporateTabView(
            trucKId: widget.truckId,
          ),
          TruckTabView(
            trucKId: widget.truckId,
          ),
          TrailerTabView(
            trailerId: widget.trailerId,
          ),
        ]),
      ),
    );
  }
}
