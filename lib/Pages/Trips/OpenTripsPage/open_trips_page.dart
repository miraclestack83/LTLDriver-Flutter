import 'package:flutter/material.dart';
import 'package:opentrip/Helpers/constant.dart';
import 'package:opentrip/Helpers/local_storage.dart';
import 'package:opentrip/Models/index.dart';
import 'package:opentrip/Pages/Trips/TripStopsPage/trip_stops_page.dart';
import 'package:opentrip/Repositories/app_repository.dart';
import 'package:opentrip/Widgets/index.dart';

class OpenTripsPage extends StatefulWidget {
  const OpenTripsPage({Key? key}) : super(key: key);

  @override
  _OpenTripsPageState createState() => _OpenTripsPageState();
}

class _OpenTripsPageState extends State<OpenTripsPage> {
  List<TripModel> trips = [];
  AppState appState = AppState.LOADING;

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
      // Get User's DriverID
      int driverID = await getDataInLocal(
          key: AppLocalKeys.DRIVER_ID, type: StorableDataType.INT);
      Map<String, dynamic> res = await AppRepository.getOpenTrips(driverID);
      if (!res['success']) {
        ToastAlart.error(context, res['message']);
        setState(() {
          appState = AppState.ERROR;
        });
        return;
      }

      List data = res['data'];
      trips = [];

      for (var item in data) {
        TripModel trip = TripModel.fromJson(item);
        trips.add(trip);
      }
      setState(() {
        appState = AppState.SUCCESS;
      });
    } catch (e) {
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
        title: Text("Open Trips"),
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
                    itemCount: trips.length,
                    itemBuilder: (context, index) {
                      return listItem(
                        context: context,
                        trip: trips[index],
                        onTap: () {
                          //-------- Go To Trip Stops Page ----
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TripStopsPage(
                                tripModel: trips[index],
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
    required TripModel trip,
    required Function onTap,
  }) {
    return ListTile(
      onTap: () {
        onTap();
      },
      title: Row(children: <Widget>[
        Text(
          'Trip# ${trip.id}',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        const SizedBox(width: 10),
        (!trip.isConfirmed)
            ? const Text(
                "(Must CONFIRM)",
              )
            : Container()
      ]),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            trip.descr,
          ),
          Text(
              'Truck: ${trip.truckName} - Trailer: ${trip.trailerName} - Miles: ${trip.miles}'),
          const SizedBox(height: 10),
          Text(
            "Trip Pays: \$${trip.tripPay}",
            style: Theme.of(context).textTheme.headline4,
          ),
        ],
      ),
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
