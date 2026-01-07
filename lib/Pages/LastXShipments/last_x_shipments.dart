import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:opentrip/Helpers/constant.dart';
import 'package:opentrip/Helpers/index.dart';
import 'package:opentrip/Helpers/local_storage.dart';
import 'package:opentrip/Models/index.dart';
import 'package:opentrip/Models/shipment_model.dart';
import 'package:opentrip/Pages/ShipmentPage/shipment_page.dart';
import 'package:opentrip/Pages/Trips/TripStopsPage/trip_stops_page.dart';
import 'package:opentrip/Repositories/app_repository.dart';
import 'package:opentrip/Widgets/index.dart';

class LastXShipmentPage extends StatefulWidget {
  const LastXShipmentPage({Key? key}) : super(key: key);

  @override
  _LastXShipmenttate createState() => _LastXShipmenttate();
}

class _LastXShipmenttate extends State<LastXShipmentPage> {
  List<ShipmentModel> shipments = [];
  AppState appState = AppState.LOADING;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Get Data
    getInitData();
  }

  String convertDateTime(String dateTimeString) {
    final dateTime = DateTime.parse(dateTimeString).toLocal();
    final formatter = DateFormat('MM/dd/yyyy hh:mma ZZZZ');
    return formatter.format(dateTime);
  }

  Future<void> getInitData() async {
    setState(() {
      appState = AppState.LOADING;
    });

    try {
      // Get User's DriverID
      // int driverID = await getDataInLocal(
      //     key: AppLocalKeys.DRIVER_ID, type: StorableDataType.INT);
      int records = 20;
      Map<String, dynamic> res = await AppRepository.getLastXShipments(records);
      if (!res['success']) {
        ToastAlart.error(context, res['message']);
        setState(() {
          appState = AppState.ERROR;
        });
        return;
      }

      Logger().i("SHIPMENT RES");

      // Logger().e(res['data'].toString());
      // List data = res['data']['data'];
      List data = res['data'];
      shipments = [];
      Logger().i(data.toString());
      for (var item in data) {
        ShipmentModel shipment = ShipmentModel.fromJson(item);
        shipments.add(shipment);
      }
      setState(() {
        appState = AppState.SUCCESS;
      });
    } catch (e) {
      Logger().e(e.toString());
      ToastAlart.error(context, e.toString());
      setState(() {
        appState = AppState.ERROR;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Last X Shipments"),
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
                : ListView.separated(
                    itemCount: shipments.length,
                    itemBuilder: (context, index) {
                      return listItem(
                        context: context,
                        shipment: shipments[index],
                        onTap: () {
                          //-------- Go To Trip Stops Page ----
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShipmentPage(
                                shipment: shipments[index],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        color: Theme.of(context).primaryColor.withOpacity(0.6),
                      );
                    },
                  ),
      ),
    );
  }

  Widget listItem({
    required BuildContext context,
    required ShipmentModel shipment,
    required Function onTap,
  }) {
    return ListTile(
      onTap: () {
        onTap();
      },
      title: Text(
        'Ref# ${shipment.ref1} - Bill To: ${shipment.FullName}',
        overflow: TextOverflow.fade,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
      ),
      subtitle: Text(
          'PRO# ${shipment.shipNum} CM: ${shipment.movescount}; Consignee: ${shipment.Consignee ?? 'N/A'} \r\nDelivery: ' +
              (shipment.soonestDelvDate != null
                  ? '${convertDateTime(shipment.soonestDelvDate!)}'
                  : '')),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.arrow_forward_ios,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
    );
  }
}
