// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:opentrip/Configs/app_routes.dart';
import 'package:opentrip/Models/index.dart';
import 'package:opentrip/Models/trip_place_model.dart';
import 'package:opentrip/Pages/App/Styles/index.dart';
import 'package:opentrip/Pages/Trips/Documents/documents_page.dart';
import 'package:opentrip/Pages/Trips/StopDetailPage/stop_details_page.dart';
import 'package:opentrip/Pages/Trips/TripTasksPage/trip_tasks_page.dart';
import 'package:opentrip/Repositories/index.dart';

import '../../../Helpers/index.dart';
import '../../../Widgets/index.dart';

class TripStopsPage extends StatefulWidget {
  const TripStopsPage({Key? key, required this.tripModel}) : super(key: key);
  final TripModel tripModel;
  @override
  _TripStopsPageState createState() => _TripStopsPageState();
}

class _TripStopsPageState extends State<TripStopsPage> {
  final pageStrings = new AppStrings();
  bool isAcKnow = true;

  List<TripPlaceModel> places = [];
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
      int tripID = widget.tripModel.id;
      Map<String, dynamic> res = await AppRepository.getTripPlaces(tripID);

      if (!res['success']) {
        ToastAlart.error(context, res['message']);
        setState(() {
          appState = AppState.ERROR;
        });
        return;
      }

      List data = res['data'];
      places = [];
      if (data[0]['error'] == null) {
        for (var item in data) {
          TripPlaceModel tripPlace = TripPlaceModel.fromJson(item);
          places.add(tripPlace);
        }
      }
      setState(() {
        appState = AppState.SUCCESS;
        isAcKnow = widget.tripModel.isConfirmed;
      });
    } catch (e) {
      ToastAlart.error(context, e.toString());
      setState(() {
        appState = AppState.ERROR;
      });
    }
  }

  _confirmTrip(bool val) async {
    if (!val) return;
    try {
      int tripID = widget.tripModel.id;
      String notes = 'Trips ${tripID}';
      Map<String, dynamic> data = {"tripID": tripID, "notes": notes};
      Map<String, dynamic> res = await AppRepository.confirmTrip(data);
      if (res['success']) {
        setState(() {
          isAcKnow = true;
          widget.tripModel.isConfirmed = true;
          widget.tripModel.confirmNotes = notes;
        });
        ToastAlart.success(context, "Confirmed successfully!");
      } else {
        ToastAlart.error(context, res['message']);
        setState(() {
          isAcKnow = false;
        });
      }
    } catch (e) {
      ToastAlart.error(context, e.toString());
      setState(() {
        isAcKnow = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(pageStrings.tripStops_title),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                children: <Widget>[
                  Text(
                    pageStrings.tripStops_acKnow,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: FlutterSwitch(
                      width: 90.0,
                      height: 35.0,
                      valueFontSize: 20.0,
                      toggleSize: 25.0,
                      value: isAcKnow,
                      borderRadius: 25.0,
                      // padding: 8.0,
                      showOnOff: true,
                      activeText: "Yes",
                      inactiveText: "No",
                      onToggle: (val) async {
                        await _confirmTrip(val);
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.tripModel.isConfirmed
                        ? widget.tripModel.confirmNotes
                        : "!!! Must Confirm the Trip !!!",
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topRight: const Radius.circular(40),
                    topLeft: const Radius.circular(40),
                  ),
                  color: Colors.white,
                ),
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
                        : places.length == 0
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
                            : ListView.separated(
                                itemCount: places.length,
                                itemBuilder: (context, index) {
                                  return listItem(
                                    context: context,
                                    tripPlace: places[index],
                                    onTap: () {
                                      //-------- Go To Trip Stops Page ----
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => TripTasksPage(
                                            tripPlace: places[index],
                                          ),
                                        ),
                                      );
                                    },
                                  );
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
            ),
            InkWell(
              onTap: () {
                AppRoutes.push(
                    context,
                    DocumentsPage(
                      truckName: "${widget.tripModel.truckName}",
                      trailerName: "${widget.tripModel.trailerName}",
                      truckId: "${widget.tripModel.truckID}",
                      trailerId: "${widget.tripModel.trailerID}",
                    ));
              },
              child: Container(
                  width: double.infinity,
                  color: Theme.of(context).primaryColor,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Icon(
                        Icons.menu,
                        color: Colors.white,
                      ),
                      Text(
                        "Documents",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        width: 24,
                      )
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }

  Widget listItem({
    required BuildContext context,
    required TripPlaceModel tripPlace,
    required Function onTap,
  }) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          tripPlace.FullName,
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      Text(
                        tripPlace.date1 == "" ? "" : tripPlace.date1,
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    tripPlace.Add1,
                    style: const TextStyle(fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    tripPlace.CSZ,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Miles To: ${tripPlace.miles} -- Stop Pays: \$${tripPlace.stopPay}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 3),
                  (tripPlace.Ph1 == "")
                      ? const SizedBox(height: 0)
                      : Text(
                          tripPlace.Ph1,
                          style: const TextStyle(fontWeight: FontWeight.w400),
                        ),
                ],
              ),
            ),
            Container(
              width: 50,
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).primaryColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
