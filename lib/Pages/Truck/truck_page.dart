import 'package:flutter/material.dart';
import 'package:opentrip/Configs/app_routes.dart';
import 'package:opentrip/Helpers/index.dart';
import 'package:opentrip/Models/index.dart';
import 'package:opentrip/Models/my_truck.dart';
import 'package:opentrip/Models/trip_place_detail_model.dart';
import 'package:opentrip/Pages/App/Styles/index.dart';
import 'package:opentrip/Pages/Trips/Documents/documents_page.dart';

import 'package:opentrip/Pages/Truck/truck_ODO_page.dart';
import 'package:opentrip/Pages/Truck/truck_problem_page.dart';
import 'package:opentrip/Pages/Truck/truck_repair_page.dart';
import 'package:opentrip/Repositories/index.dart';
import 'package:opentrip/Widgets/index.dart';
import 'package:opentrip/Widgets/loading_container.dart';
import 'package:opentrip/Widgets/round_button.dart';

class TruckPage extends StatefulWidget {
  final int? trailerId;
  final String? title;
  const TruckPage({
    Key? key,
    this.trailerId,
    this.title,
  }) : super(key: key);
  @override
  _TruckPageState createState() => _TruckPageState();
}

class _TruckPageState extends State<TruckPage> {
  final pageStrings = AppStrings();
  TripPlaceDetailModel placeDetail = TripPlaceDetailModel();
  bool _isLoading = false;
  List<MyTruck> myTrucks = [];

  @override
  void initState() {
    super.initState();

    // Get Data
    getInitData();
  }

  Future<void> getInitData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      if (widget.trailerId != null) {
        final truck = await AppRepository.getTrailer(widget.trailerId!);

        if (truck == null) {
          ToastAlart.error(context, "Trailer not found. Please retry!");
          setState(() {
            _isLoading = false;
          });
        } else {
          myTrucks = [truck];
        }
      } else {
        final driverId = await getDataInLocal(
            key: AppLocalKeys.DRIVER_ID, type: StorableDataType.INT);

        myTrucks = await AppRepository.getMyTruck("$driverId");
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      ToastAlart.error(context, e.toString());
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingContainer(
      context: context,
      isLoading: _isLoading,
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                AppRoutes.push(
                    context,
                    DocumentsPage(
                      truckName: "${myTrucks[0].truckName}",
                      trailerName: "",
                      truckId: "${myTrucks[0].truckNum}",
                      trailerId: "0",
                    ));
              },
              child: Container(
                  width: double.infinity,
                  // height: 50,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey, width: 1),
                    ),
                  ),
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
            ),
            BottomNavigationBar(
              backgroundColor: Theme.of(context).primaryColor,
              unselectedLabelStyle: TextStyle(
                color: Colors.white,
              ),
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white,
              currentIndex: 1,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                    label: "ODO Update"),
                BottomNavigationBarItem(
                    backgroundColor: Colors.white,
                    icon: Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                    label: "Report Problem"),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                    label: "Repairs"),
              ],
              onTap: (int i) {
                switch (i) {
                  case 0: // Update
                    if (myTrucks.isNotEmpty) {
                      // Go to Update Place Page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TruckODOPage(
                                truckId: "${myTrucks.first.truckNum}",
                                odo: myTrucks.first.odometer!)),
                      );
                    } else {
                      ToastAlart.error(context, "No data found.");
                    }

                    break;

                  case 1: // Add Note
                    // Go to Update Place Page
                    if (myTrucks.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TruckProblemPage(
                                  truckId: "${myTrucks.first.truckNum}",
                                )),
                      );
                    } else {
                      ToastAlart.error(context, "No data found.");
                    }
                    break;

                  case 2: // Details
                    // Go to Truck Repair Page
                    if (myTrucks.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TruckRepairPage(
                            truckID: "${myTrucks.first.truckNum}",
                          ),
                        ),
                      );
                    } else {
                      ToastAlart.error(context, "No data found.");
                    }

                    break;
                }
              },
            ),
          ],
        ),
        appBar: AppBar(
          title: Text(
            widget.title ?? pageStrings.truck_title,
            overflow: TextOverflow.clip,
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          // backgroundColor: Colors.transparent,
          // actions: [
          //   IconButton(
          //     onPressed: () {
          //       AppRoutes.push(
          //           context,
          //           DocumentsPage(
          //             truckName: "${myTrucks[0].truckName}",
          //             trailerName: "",
          //             truckId: "${myTrucks[0].truckNum}",
          //             trailerId: "0",
          //           ));
          //     },
          //     icon: Icon(Icons.file_present),
          //   ),
          // ],
          elevation: 0,
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: _isLoading
              ? Container()
              : myTrucks.isEmpty
                  ? Center(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text("No data found."),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 20,
                          ),
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
                    ))
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Name: ${myTrucks.first.truckName}",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              "${myTrucks.first.make} ${myTrucks.first.model}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              "Year: ${myTrucks.first.year ?? "N/A"}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              "License: ${myTrucks.first.license ?? "N/A"}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              "License Epiration: ${myTrucks.first.licenseExp != null ? stringToDateFormat(myTrucks.first.licenseExp!, 'yyyy-MM-dd') : "N/A"}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              "VIN: ${myTrucks.first.vin ?? "N/A"}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              "ODO: ${myTrucks.first.odometer ?? "N/A"}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              "Last Oil Changed: ${myTrucks.first.oilchanged ?? "N/A"}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              "Last Annual Inspection:${myTrucks.first.lastAnnualInsp != null ? stringToDateFormat(myTrucks.first.lastAnnualInsp!, 'yyyy-MM-dd') : "N/A"}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              "Notes: ${myTrucks.first.notes ?? "N/A"}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }
}
