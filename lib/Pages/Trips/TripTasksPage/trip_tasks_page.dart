import 'package:flutter/material.dart';
import 'package:opentrip/Helpers/index.dart';
import 'package:opentrip/Helpers/library.dart';
import 'package:opentrip/Models/index.dart';
import 'package:opentrip/Models/trip_place_model.dart';
import 'package:opentrip/Pages/App/Provider/app_provider.dart';
import 'package:opentrip/Pages/App/Styles/index.dart';
import 'package:opentrip/Pages/Trips/StopDetailPage/stop_details_page.dart';
import 'package:opentrip/Pages/Trips/TripStopsPage/trip_stops_page.dart';
import 'package:opentrip/Repositories/index.dart';
import 'package:opentrip/Widgets/index.dart';

class TripTasksPage extends StatefulWidget {
  const TripTasksPage({Key? key, required this.tripPlace}) : super(key: key);
  final TripPlaceModel tripPlace;
  @override
  _TripTasksPageState createState() => _TripTasksPageState();
}

class _TripTasksPageState extends State<TripTasksPage> {
  final pageStrings = AppStrings();

  List<TripTaskModel> tripTasks = [];
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
      int tpID = widget.tripPlace.tpID;
      Map<String, dynamic> res = await AppRepository.getTripTasks(tpID);
      if (!res['success']) {
        ToastAlart.error(context, res['message']);
        setState(() {
          appState = AppState.ERROR;
        });
        return;
      }
      List data = res['data'];
      tripTasks = [];
      if (data[0]['error'] == null) {
        for (var item in data) {
          print("✨✨✨------------------");
          print(item);
          TripTaskModel task = TripTaskModel.fromJson(item);
          tripTasks.add(task);
        }
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
        title: Text(pageStrings.tripTasks_title),
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
                : tripTasks.length == 0
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
                        itemCount: tripTasks.length,
                        itemBuilder: (context, index) {
                          return listItem(
                            context: context,
                            data: tripTasks[index],
                            onTap: () async {
                              AppProvider.of(context)
                                  .setTripTask(tripTasks[index]);
                              //-------- Go To Trip Stops Page ----
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StopDetailsPage(
                                    tripTask: tripTasks[index],
                                  ),
                                ),
                              ).then((value) async {
                                // Refresh data or perform actions when returning from NewPage
                                await getInitData();
                              });
                            },
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.6),
                          );
                        },
                      ),
      ),
    );
  }

  Widget listItem({
    required BuildContext context,
    required TripTaskModel data,
    required Function onTap,
  }) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    getActionName(data.stopType),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${data.pcs} ${data.pcsunits} / ${data.weight} Lb ',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "PU#",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'PRO# ${data.pro}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    pageStrings.tripTasks_appt,
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          dateToString(stringToDate(data.appt_from.toString())),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                        Text(
                          dateToString(stringToDate(data.appt_to.toString())),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    pageStrings.tripTasks_note,
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  (data.Notes == null || data.Notes == "")
                      ? Container()
                      : Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            data.Notes,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(fontWeight: FontWeight.w400),
                          ),
                        ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              width: 50,
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
