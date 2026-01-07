import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:opentrip/Helpers/index.dart';
import 'package:opentrip/Models/index.dart';
import 'package:opentrip/Models/trip_place_detail_model.dart';
import 'package:opentrip/Models/trip_place_model.dart';
import 'package:opentrip/Pages/App/Provider/app_provider.dart';
import 'package:opentrip/Pages/App/Styles/index.dart';
import 'package:opentrip/Pages/ShipmentPage/shipment_page.dart';
import 'package:opentrip/Pages/Trips/StopDetailPage/AddNotePage/add_note_page.dart';
import 'package:opentrip/Pages/Trips/StopDetailPage/POD/pod_page.dart';
import 'package:opentrip/Pages/Trips/StopDetailPage/ShipPicturePage/ship_picture_page.dart';
import 'package:opentrip/Pages/Trips/StopDetailPage/UpdatePlacePage/update_place_page.dart';
import 'package:opentrip/Repositories/index.dart';
import 'package:opentrip/Widgets/index.dart';
import 'package:opentrip/Widgets/loading_container.dart';
import 'package:opentrip/Widgets/round_button.dart';

class StopDetailsPage extends StatefulWidget {
  const StopDetailsPage({Key? key, required this.tripTask}) : super(key: key);
  final TripTaskModel tripTask;
  @override
  _StopDetailsPageState createState() => _StopDetailsPageState();
}

class _StopDetailsPageState extends State<StopDetailsPage>
    with SingleTickerProviderStateMixin {
  final pageStrings = AppStrings();
  TripPlaceDetailModel placeDetail = TripPlaceDetailModel();
  AppState appState = AppState.LOADING;

  PageController controller = PageController(initialPage: 2);
  late TabController tabCtrl;

  // Gloabal key for progress dialog
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  int pageIndex = 2;

  List<String> titles = [
    AppStrings().updatePlace_title,
    AppStrings().addNote_title,
    AppStrings().stopDetails_title,
    AppStrings().shipPicture_title,
    AppStrings().pod_title,
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabCtrl = TabController(length: 5, vsync: this);
    tabCtrl.animateTo(2);
    // Get Data
    getInitData();
  }

  Future<void> getInitData() async {
    setState(() {
      appState = AppState.LOADING;
    });

    try {
      // Get User's DriverID
      int placeID = widget.tripTask.srID;
      String stopType = widget.tripTask.stopType;
      print("STOPE TYPE");
      print(stopType);
      Map<String, dynamic> res =
          await AppRepository.getPlaceByID(placeID, stopType);

      if (!res['success']) {
        ToastAlart.error(context, res['message']);
        setState(() {
          appState = AppState.ERROR;
        });
        return;
      }

      var data = res['data'];
      print(data.toString());
      placeDetail = TripPlaceDetailModel.fromJson(data[0]);

      AppProvider.of(context).setTripPlaceDetail(placeDetail);
      setState(() {
        appState = AppState.SUCCESS;
      });
    } catch (e) {
      print(e.toString());
      ToastAlart.error(context, e.toString());
      setState(() {
        appState = AppState.ERROR;
      });
    }
  }

  // Make As Arrived
  Future<void> makeArrived() async {
    if (appState == AppState.ACTION_PROGRESS) return;
    setState(() {
      appState = AppState.ACTION_PROGRESS;
    });
    int unixtime = (DateTime.now().millisecondsSinceEpoch / 1000).ceil();
    print(unixtime);
    Map data = {
      "placeID": widget.tripTask.srID,
      "stopType": widget.tripTask.stopType,
      'timestamp': unixtime,
      "timezone": 'CST',
      "lat": '0.00',
      "lon": '0.00'
    };

    Map res = await AppRepository.makeArrived(data);
    if (res['success']) {
      setState(() {
        appState = AppState.ACTION_SUCCESS;
      });
      ToastAlart.success(context, "Marked as Arrived successfully!");
      await getInitData();
    } else {
      setState(() {
        appState = AppState.ACTION_ERROR;
      });
      ToastAlart.error(context, res['message']);
    }
  }

  // Make As Done
  Future<void> makeDone() async {
    if (appState == AppState.ACTION_PROGRESS) return;
    setState(() {
      appState = AppState.ACTION_PROGRESS;
    });
    int unixtime = (DateTime.now().millisecondsSinceEpoch / 1000).ceil();
    print(unixtime);
    Map data = {
      "placeID": widget.tripTask.srID,
      "stopType": widget.tripTask.stopType,
      'timestamp': unixtime,
      "timezone": 'CST',
      "lat": '0.00',
      "lon": '0.00'
    };

    Map res = await AppRepository.makeDone(data);
    if (res['success']) {
      setState(() {
        appState = AppState.ACTION_SUCCESS;
      });
      ToastAlart.success(context, "Marked as Done successfully!");
      await getInitData();
    } else {
      ToastAlart.error(context, res['message']);
      setState(() {
        appState = AppState.ACTION_ERROR;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingContainer(
      context: context,
      isLoading: (appState == AppState.ACTION_PROGRESS),
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8),
        bottomNavigationBar: ConvexAppBar(
          controller: tabCtrl,
          backgroundColor: Theme.of(context).primaryColor,
          height: 70,
          items: [
            TabItem(icon: Icons.edit, title: 'Update'),
            TabItem(icon: Icons.note_add, title: 'Add Note'),
            TabItem(icon: Icons.more_horiz, title: 'Details'),
            TabItem(icon: Icons.image, title: 'Pictures'),
            TabItem(icon: Icons.send, title: 'POD'),
          ],
          initialActiveIndex: pageIndex, //optional, default as 0
          onTap: (int i) {
            print('click index=$i');
            setState(() {
              pageIndex = i;
            });
            controller.animateToPage(
              i,
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          },
        ),
        appBar: AppBar(
          title: Text(titles[pageIndex]),
          centerTitle: true,
          // backgroundColor: Theme.of(context).primaryColor,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: PageView(
          controller: controller,
          onPageChanged: (index) {
            print("🧨------ $index");
            tabCtrl.animateTo(index);
            setState(() {
              pageIndex = index;
            });
          },
          children: [
            UpdatePlacePage(),
            AddNotePage(),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: (appState == AppState.LOADING)
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        LoadingWidget(
                          loadText: const Text(
                            "LOADING...",
                            style: TextStyle(color: Colors.white),
                          ),
                          loadingColor: Colors.white,
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
                      : SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                height: 140,
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "SHIPPER:",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4,
                                          ),
                                          const SizedBox(height: 20),
                                          Text(
                                            placeDetail.shipperName,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge,
                                          ),
                                          Text(
                                            placeDetail.shipperAddress1,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge,
                                          ),
                                          Text(
                                            placeDetail.shipperCSZ,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "CONSIGNEE:",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline4,
                                          ),
                                          const SizedBox(height: 20),
                                          Text(
                                            placeDetail.consigneeName,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge,
                                          ),
                                          Text(
                                            placeDetail.consigneeAddress1,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge,
                                          ),
                                          Text(
                                            placeDetail.consigneeCSZ,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 30),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          getActionName(
                                              widget.tripTask.stopType),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4!
                                              .copyWith(color: Colors.white),
                                        ),
                                        Text(
                                          " APPT: ",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      dateToString(
                                          stringToDate(placeDetail.APPT_from)),
                                      // stringToDateFormat(
                                      //     placeDetail.APPT_from, 'yyyy-MM-dd h:mm'),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      dateToString(
                                          stringToDate(placeDetail.APPT_to)),
                                      // stringToDateFormat(
                                      //     placeDetail.APPT_to, 'yyyy-MM-dd h:mm'),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Table1
                              Container(
                                margin: const EdgeInsets.only(top: 30),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: <Widget>[
                                    tableRow(
                                      items: [
                                        "",
                                        "Pieces: ",
                                        "Weight: ",
                                        "Spots: "
                                      ],
                                      isHeader: true,
                                    ),
                                    tableRow(
                                      items: [
                                        "Original: ",
                                        '${placeDetail.pcs}',
                                        '${placeDetail.weight}',
                                        '',
                                      ],
                                    ),
                                    tableRow(
                                      items: [
                                        "Actual: ",
                                        placeDetail.ActualPCS.toString(),
                                        placeDetail.ActualWeight,
                                        placeDetail.ActualSpots,
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // Table2
                              Container(
                                margin: const EdgeInsets.only(top: 30),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: <Widget>[
                                    tableRow(
                                      items: ["Trailer# ", "Seal# ", "Bol# "],
                                      isHeader: true,
                                    ),
                                    tableRow(
                                      items: [
                                        placeDetail.containerNumber.toString(),
                                        placeDetail.sealNumber.toString(),
                                        placeDetail.BoLNumber.toString(),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // Arrived
                              (placeDetail.arrived != "")
                                  ? Container(
                                      margin: const EdgeInsets.only(top: 20),
                                      child: Text(
                                        "Arrived: " +
                                            dateToString(stringToDate(
                                                placeDetail.arrived)),
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge!
                                            .copyWith(color: Colors.white),
                                      ),
                                    )
                                  : Container(),
                              const SizedBox(height: 10),
                              // Done
                              (placeDetail.done != "")
                                  ? Container(
                                      margin: const EdgeInsets.only(top: 20),
                                      child: Text(
                                        "Done: " +
                                            dateToString(
                                                stringToDate(placeDetail.done)),
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge!
                                            .copyWith(color: Colors.white),
                                      ),
                                    )
                                  : Container(),
                              // Mark as Arrive
                              (placeDetail.arrived == null ||
                                      placeDetail.arrived == "")
                                  ? Padding(
                                      padding: EdgeInsets.only(top: 20),
                                      child: RoundButton(
                                        context: context,
                                        onTap: () async {
                                          await makeArrived();
                                        },
                                        title: "Mark as Arrived",
                                        // backColor: Colors.green,
                                      ),
                                    )
                                  : Container(),

                              // Mark as Done
                              (placeDetail.done == null ||
                                      placeDetail.done == "")
                                  ? Padding(
                                      padding: EdgeInsets.only(top: 20),
                                      child: RoundButton(
                                        context: context,
                                        onTap: () async {
                                          await makeDone();
                                        },
                                        title: "Mark as DONE",
                                        // backColor: Colors.green,
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
            ),
            ShipPicturePage(),
            PODPage(),
          ],
        ),
      ),
    );
  }

  Widget tableRow({required List items, bool? isHeader}) {
    List<Widget> itemWidget = [];
    for (var item in items) {
      itemWidget.add(Expanded(
          child: Text(
        item,
        style: isHeader != null
            ? Theme.of(context).textTheme.headline6
            : Theme.of(context).textTheme.labelLarge,
      )));
    }
    return Container(
      margin: EdgeInsets.only(bottom: (isHeader != null && isHeader) ? 10 : 7),
      child: Row(
        children: itemWidget,
      ),
    );
  }
}
