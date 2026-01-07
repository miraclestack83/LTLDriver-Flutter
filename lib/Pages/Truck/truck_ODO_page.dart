import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:opentrip/Helpers/index.dart';
import 'package:opentrip/Models/index.dart';
import 'package:opentrip/Models/trip_place_detail_model.dart';
import 'package:opentrip/Models/trip_place_model.dart';
import 'package:opentrip/Pages/App/Provider/app_provider.dart';
import 'package:opentrip/Pages/App/Styles/index.dart';
import 'package:opentrip/Pages/Trips/StopDetailPage/AddNotePage/add_note_page.dart';
import 'package:opentrip/Pages/Trips/StopDetailPage/POD/pod_page.dart';
import 'package:opentrip/Pages/Trips/StopDetailPage/ShipPicturePage/ship_picture_page.dart';
import 'package:opentrip/Pages/Trips/StopDetailPage/UpdatePlacePage/update_place_page.dart';
import 'package:opentrip/Pages/Truck/truck_problem_page.dart';
import 'package:opentrip/Repositories/index.dart';
import 'package:opentrip/Widgets/index.dart';
import 'package:opentrip/Widgets/loading_container.dart';
import 'package:opentrip/Widgets/round_button.dart';

class TruckODOPage extends StatefulWidget {
  final String truckId;
  final int odo;

  const TruckODOPage({
    Key? key,
    // required this.tripTask,
    required this.truckId,
    required this.odo,
  }) : super(key: key);
  // final TripTaskModel tripTask;
  @override
  _TruckODOPageState createState() => _TruckODOPageState();
}

class _TruckODOPageState extends State<TruckODOPage> {
  final pageStrings = AppStrings();
  TripPlaceDetailModel placeDetail = TripPlaceDetailModel();
  AppState appState = AppState.SUCCESS;

  // Gloabal key for progress dialog
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  TextEditingController odoCtl = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    odoCtl.text = "";
    // Get Data
    getInitData();
  }

  Future<void> getInitData() async {
    // setState(() {
    //   appState = AppState.LOADING;
    // });

    // try {
    //   // Get User's DriverID
    //   int placeID = widget.tripTask.srID;
    //   String stopType = widget.tripTask.stopType;
    //   Map<String, dynamic> res =
    //       await AppRepository.getPlaceByID(placeID, stopType);
    //   if (!res['success']) {
    //     ToastAlart.error(context, res['message']);
    //     setState(() {
    //       appState = AppState.ERROR;
    //     });
    //     return;
    //   }

    //   var data = res['data'];
    //   print(data[0]);
    //   placeDetail = TripPlaceDetailModel.fromJson(data[0]);

    //   AppProvider.of(context).setTripPlaceDetail(placeDetail);
    //   setState(() {
    //     appState = AppState.SUCCESS;
    //   });
    // } catch (e) {
    //   ToastAlart.error(context, "Something went wrong. Please try again!");
    //   setState(() {
    //     appState = AppState.ERROR;
    //   });
    // }
  }

  _updateODO() async {
    if (odoCtl.text.isEmpty || int.parse(odoCtl.text.toString()) < 0) {
      ToastAlart.error(context, "ODO is required");
      return;
    }

    if (double.parse(odoCtl.text.toString()) < widget.odo) {
      ToastAlart.error(context, "ODO should be bigger than old value!!!");
      return;
    }
    try {
      setState(() {
        appState = AppState.LOADING;
      });
      final user = await getDataInLocal(
          key: AppLocalKeys.USERNAME, type: StorableDataType.String);
      int truckID = int.parse(widget.truckId.toString());

      Map<String, dynamic> res = await AppRepository.updateODO({
        "equipmentID": truckID,
        "odo": int.parse(odoCtl.text.toString()),
        "createUser": user,
      });
      if (!res['success']) {
        ToastAlart.error(context, res['message']);
        setState(() {
          appState = AppState.ACTION_ERROR;
        });
        return;
      }

      ToastAlart.success(context, "ODO updated successfully!");

      setState(() {
        appState = AppState.ACTION_SUCCESS;
      });
      // Navigator.pop(context);
    } catch (e) {
      ToastAlart.error(context, e.toString());
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
//         bottomNavigationBar: BottomNavigationBar(
//           backgroundColor: Theme.of(context).primaryColor,
//           unselectedLabelStyle: TextStyle(
//             color: Colors.grey,
//           ),
//           selectedItemColor: Colors.white,
//           unselectedItemColor: Colors.grey,
//           currentIndex: 1,
//           items: const [
//             BottomNavigationBarItem(
//                 icon: Icon(
//                   Icons.edit,
//                   color: Colors.white,
//                 ),
//                 label: "ODO Update"),
//             BottomNavigationBarItem(
//                 backgroundColor: Colors.white,
//                 icon: Icon(
//                   Icons.send,
//                   color: Colors.white,
//                 ),
//                 label: "Report Problem"),
//             BottomNavigationBarItem(
//                 icon: Icon(
//                   Icons.edit,
//                   color: Colors.white,
//                 ),
//                 label: "Repairs"),
//           ],
//           onTap: (int i) {
//             switch (i) {
//               case 0: // Update

//               case 1: // Add Note
//                 // Go to Update Place Page
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const TruckProblemPage()),
//                 );
//                 break;

//               case 2: // Details
// // Go to Update Place Page
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => const TruckODOPage()),
//                 );
//                 break;

//             }
//           },
//         ),
        appBar: AppBar(
          title: Text(pageStrings.truck_ODO_title),
          centerTitle: true,
          // backgroundColor: Theme.of(context).primaryColor,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          myInput(
                            context: context,
                            title: "Odometer",
                            hint: "Current ODO miles",
                            controller: odoCtl,
                            keyboard: TextInputType.numberWithOptions(),
                          ),
                          RoundButton(
                            context: context,
                            onTap: () async {
                              _updateODO();
                            },
                            title: "SUBMIT",
                            icon: const Icon(
                              Icons.send,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
        ),
      ),
    );
  }

  Widget myInput({
    required BuildContext context,
    required String title,
    required String hint,
    required TextEditingController controller,
    bool? enable,
    TextInputType? keyboard,
  }) {
    // Page Text Styles
    final textStyles = Theme.of(context).textTheme;
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: textStyles.headline6!.copyWith(color: Colors.white),
          ),
          const SizedBox(
            height: 10,
          ),
          commonTextForm(
            context: context,
            fieldname: hint,
            hint: hint,
            enable: enable ?? true,
            keyboard: keyboard ?? TextInputType.text,
            validator: (value) {
              // if (value == null || value.isEmpty) {
              //   return 'Please enter some text';
              // } else if (value.length < 3) {
              //   return 'The password must be at least 8 characters.';
              // }
              return null;
            },
            controller: controller,
          ),
        ],
      ),
    );
  }
}
