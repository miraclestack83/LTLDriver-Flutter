import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:opentrip/Helpers/index.dart';
import 'package:opentrip/Models/index.dart';
import 'package:opentrip/Models/repair.dart';
import 'package:opentrip/Models/trip_place_detail_model.dart';
import 'package:opentrip/Models/trip_place_model.dart';
import 'package:opentrip/Pages/App/Provider/app_provider.dart';
import 'package:opentrip/Pages/App/Styles/index.dart';
import 'package:opentrip/Pages/Trips/StopDetailPage/AddNotePage/add_note_page.dart';
import 'package:opentrip/Pages/Trips/StopDetailPage/POD/pod_page.dart';
import 'package:opentrip/Pages/Trips/StopDetailPage/ShipPicturePage/ship_picture_page.dart';
import 'package:opentrip/Pages/Trips/StopDetailPage/UpdatePlacePage/update_place_page.dart';
import 'package:opentrip/Pages/Truck/truck_ODO_page.dart';
import 'package:opentrip/Pages/Truck/truck_problem_page.dart';
import 'package:opentrip/Repositories/index.dart';
import 'package:opentrip/Widgets/index.dart';
import 'package:opentrip/Widgets/loading_container.dart';
import 'package:opentrip/Widgets/round_button.dart';

class TruckRepairPage extends StatefulWidget {
  final String truckID;
  const TruckRepairPage({
    Key? key,
    required this.truckID,
    // required this.tripTask,
  }) : super(key: key);
  // final TripTaskModel tripTask;
  @override
  _TruckRepairPageState createState() => _TruckRepairPageState();
}

class _TruckRepairPageState extends State<TruckRepairPage> {
  final pageStrings = AppStrings();
  TripPlaceDetailModel placeDetail = TripPlaceDetailModel();
  bool _isLoading = false;
  List<Repair> repairs = [];
  // Gloabal key for progress dialog
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  String error = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Get Data
    getInitData();
  }

  Future<void> getInitData() async {
    try {
      setState(() {
        _isLoading = true;
        error = '';
      });

      repairs = await AppRepository.getTruckRepairs(widget.truckID);

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      error = "No Repairs found for Equipment ID: ${widget.truckID}";
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
        // bottomNavigationBar: BottomNavigationBar(
        //   backgroundColor: Theme.of(context).primaryColor,
        //   unselectedLabelStyle: TextStyle(
        //     color: Colors.grey,
        //   ),
        //   selectedItemColor: Colors.white,
        //   unselectedItemColor: Colors.grey,
        //   currentIndex: 1,
        //   items: const [
        //     BottomNavigationBarItem(
        //         icon: Icon(
        //           Icons.edit,
        //           color: Colors.white,
        //         ),
        //         label: "ODO Update"),
        //     BottomNavigationBarItem(
        //         backgroundColor: Colors.white,
        //         icon: Icon(
        //           Icons.send,
        //           color: Colors.white,
        //         ),
        //         label: "Report Problem"),
        //     BottomNavigationBarItem(
        //         icon: Icon(
        //           Icons.edit,
        //           color: Colors.white,
        //         ),
        //         label: "Repairs"),
        //   ],
        //   onTap: (int i) {
        //     print('click index=$i');
        //     switch (i) {
        //       case 0: // Update
        //         // Go to Update Place Page
        //         Navigator.push(
        //           context,
        //           MaterialPageRoute(builder: (context) => const TruckODOPage()),
        //         );
        //         break;

        //       case 1: // Add Note
        //         // Go to Update Place Page
        //         Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //               builder: (context) => const TruckProblemPage()),
        //         );
        //         break;

        //       case 2: // Details

        //         break;
        //     }
        //   },
        // ),
        appBar: AppBar(
          title: Text(pageStrings.truck_repair_title),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          // backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Builder(builder: (context) {
          if (_isLoading == false && error.isNotEmpty) {
            return Center(
              child: Text("$error"),
            );
          }
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
            child: repairs.isEmpty
                ? Center(child: Text("No Data"))
                : SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: repairs.map((e) {
                        return TruckRepairItem(
                          repair: e,
                          refreshData: () {
                            getInitData();
                          },
                        );
                      }).toList(),
                    ),
                  ),
          );
        }),
      ),
    );
  }
}
