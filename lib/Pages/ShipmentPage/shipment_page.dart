import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:opentrip/Helpers/index.dart';
import 'package:opentrip/Helpers/library.dart';
import 'package:opentrip/Models/index.dart';
import 'package:opentrip/Models/shipment_detail_model.dart';
import 'package:opentrip/Models/shipment_model.dart';
import 'package:opentrip/Models/trip_place_model.dart';
import 'package:opentrip/Pages/App/Provider/app_provider.dart';
import 'package:opentrip/Pages/App/Styles/index.dart';
import 'package:opentrip/Pages/Trips/StopDetailPage/stop_details_page.dart';
import 'package:opentrip/Pages/Trips/TripStopsPage/trip_stops_page.dart';
import 'package:opentrip/Repositories/index.dart';
import 'package:opentrip/Widgets/index.dart';

class ShipmentPage extends StatefulWidget {
  const ShipmentPage({Key? key, required this.shipment}) : super(key: key);
  final ShipmentModel shipment;
  @override
  _ShipmentPageState createState() => _ShipmentPageState();
}

class _ShipmentPageState extends State<ShipmentPage> {
  final pageStrings = AppStrings();

  List<ShipmentDetailModel> shipmentDetails = [];
  AppState appState = AppState.LOADING;

  String convertDateTime(String dateTimeString) {
    final dateTime = DateTime.parse(dateTimeString).toLocal();
    final formatter = DateFormat('MM/dd/yyyy hh:mma ZZZZ');
    return formatter.format(dateTime);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Get Data
    getInitData();
  }

  Future<void> getInitData() async {
    setState(() {
      appState = AppState.LOADING;
    });

    try {
      int shipNum = widget.shipment.shipNum;
      Map<String, dynamic> res = await AppRepository.getShipmentID(shipNum);
      if (!res['success']) {
        ToastAlart.error(context, res['message']);
        setState(() {
          appState = AppState.ERROR;
        });
        return;
      }
      List data = res['data'];
      shipmentDetails = [];
      // if (data[0]['error'] == null) {
      for (var item in data) {
        ShipmentDetailModel task = ShipmentDetailModel.fromJson(item);
        shipmentDetails.add(task);
      }
      // }
      setState(() {
        appState = AppState.SUCCESS;
      });
    } catch (e) {
      Logger().e(e.toString());
      // ToastAlart.error(context, "Something went wrong. Please try again!");
      ToastAlart.error(context, "${e.toString()}");
      setState(() {
        appState = AppState.ERROR;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 209, 222, 232),
      appBar: AppBar(
        title: Text(
            "PRO# ${widget.shipment.shipNum} Ref# ${widget.shipment.ref1}"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: (appState == AppState.LOADING)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  LoadingWidget(
                    loadText: Text("LOADING..."),
                  ),
                ],
              )
            : (appState == AppState.ERROR)
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      child: RoundButton(
                        context: context,
                        onTap: () async {
                          await getInitData();
                        },
                        title: "RETRY",
                        icon: const Icon(
                          Icons.refresh,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                : shipmentDetails.length == 0
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const Text(
                              "No Tasks",
                              style: TextStyle(fontSize: 18),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 20),
                              child: RoundButton(
                                context: context,
                                onTap: () async {
                                  await getInitData();
                                },
                                title: "RETRY",
                                icon: const Icon(
                                  Icons.refresh,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 209, 222, 232),
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Colors.grey.withOpacity(0.5),
                          //     spreadRadius: 5,
                          //     blurRadius: 7,
                          //     offset: Offset(0, -3),
                          //   ),
                          // ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ------------ BILL TO ---------------
                            Container(
                              margin: EdgeInsets.only(bottom: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Bill To:",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    '${shipmentDetails[0].billingName}',
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    '\$${shipmentDetails[0].shipmentTotal}',
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                // color: Colors.white,
                                child: ListView.separated(
                                  itemCount: shipmentDetails.length,
                                  itemBuilder: (context, index) {
                                    return shipmentDetailRow(
                                        shipmentDetails[index]);
                                  },
                                  separatorBuilder: (context, index) {
                                    return Divider(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.6),
                                    );
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
      ),
    );
  }

  Widget shipmentDetailRow(ShipmentDetailModel shipment) {
    print(shipment.pickDone);
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ----------- ORIGIN PART -------------------
              Expanded(
                child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Origin:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "${shipment.shipperName}",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                "${shipment.shipperAddress1}",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                "${shipment.shipperCSZ}",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                "Pick# ${shipment.pickNumber}",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Appt:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "${convertDateTime(shipment.pickAPPTfrom)}",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                "${convertDateTime(shipment.pickAPPTto)}",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                "Notes: ${shipment.pickNotes}",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                'Arrived: ' + shipment.pickArrived == '' ||
                                        shipment.pickArrived.length == 0
                                    ? "No"
                                    : "${convertDateTime(shipment.pickArrived)}",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                'Done : ' + shipment.pickDone == '' ||
                                        shipment.pickDone.length == 0
                                    ? "No"
                                    : "${convertDateTime(shipment.pickDone)}",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
              ),

              // ----------- ORIGIN PART -------------------
              Expanded(
                child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Destination:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "${shipment.consigneeName}",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                "${shipment.consigneeAddress1}",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                "${shipment.consigneeCSZ}",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                "Pick# ${shipment.delvNumber}",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Appt:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "${convertDateTime(shipment.delvAPPTfrom)}",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                "${convertDateTime(shipment.delvAPPTto)}",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                "Notes: ${shipment.delvNotes}",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                'Arrived: ' + shipment.delvArrived == '' ||
                                        shipment.delvArrived.length == 0
                                    ? "No"
                                    : "${convertDateTime(shipment.delvArrived)}",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                'Done : ' + shipment.delvDone == '' ||
                                        shipment.delvDone.length == 0
                                    ? "No"
                                    : "${convertDateTime(shipment.delvDone)}",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),

        // ------------ PRICE PART ------------
        Container(
          margin: EdgeInsets.only(top: 5),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              PriceRow('', 'Pieces:', "Weight:", "Spots:", isHeader: true),
              PriceRow('Original', '${shipment.pcs} ${shipment.pcsunits}',
                  "${shipment.weight}", "${shipment.spots}",
                  isHeader: false),
              PriceRow(
                  'Actual',
                  shipment.actualPCS != null ? '${shipment.actualPCS}' : "",
                  shipment.actualWeight != null
                      ? "${shipment.actualWeight}"
                      : "",
                  shipment.actualSpots != null ? "${shipment.actualSpots}" : "",
                  isHeader: false),
              PriceRow(
                  'Comidity: ${shipment.commodity}',
                  '${shipment.containerNumber}',
                  "${shipment.sealNumber}",
                  "${shipment.boLNumber}",
                  isHeader: false),
            ],
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget PriceRow(String item1, String item2, String item3, String item4,
      {bool isHeader = false}) {
    return Row(
      children: [
        Expanded(
            child: Text(
          item1,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontWeight: isHeader ? FontWeight.w600 : FontWeight.w400,
          ),
        )),
        Expanded(
            child: Text(
          item2,
          style: TextStyle(
            fontWeight: isHeader ? FontWeight.w600 : FontWeight.w400,
          ),
        )),
        Expanded(
            child: Text(
          item3,
          style: TextStyle(
            fontWeight: isHeader ? FontWeight.w600 : FontWeight.w400,
          ),
        )),
        Expanded(
            child: Text(
          item4,
          style: TextStyle(
            fontWeight: isHeader ? FontWeight.w600 : FontWeight.w400,
          ),
        )),
      ],
    );
  }
}
