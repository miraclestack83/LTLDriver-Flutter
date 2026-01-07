import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logger/logger.dart';
import 'package:opentrip/Configs/app_routes.dart';
import 'package:opentrip/Helpers/index.dart';
import 'package:opentrip/Helpers/notification_service.dart';
import 'package:opentrip/Pages/App/Provider/auth_provider.dart';
import 'package:opentrip/Pages/Chats/chat_page.dart';
import 'package:opentrip/Pages/FindShipment/find_shipment_page.dart';
import 'package:opentrip/Pages/LastXShipments/last_x_shipments.dart';
import 'package:opentrip/Pages/Others/others_page.dart';
import 'package:opentrip/Pages/Trips/OpenTripsPage/open_trips_page.dart';
import 'package:opentrip/Pages/Truck/truck_page.dart';
import 'package:opentrip/Services/firestore_service.dart';

import '../InboundPlans/inbound_plans.dart';
import '../Inspection/inspection_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NotificationService notificationService = NotificationService();
  String profile = '';
  @override
  void initState() {
    _init();
    notificationService.settingNotifcation(context);
    super.initState();
  }

  _init() async {
    profile = await getDataInLocal(
        key: AppLocalKeys.PROFILE, type: StorableDataType.String);

    setState(() {});
    await FirestoreService.joinToGroupChatGeneral();
  }

  @override
  void didChangeDependencies() {
    _getUserChatModel();
    super.didChangeDependencies();
  }

  _getUserChatModel() async {
    var user = await FirestoreService.getCurrentUser();
    AuthProvider.of(context).setUseChatModel(user);
  }

  @override
  void dispose() {
    notificationService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Logger().i(profile);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("HOME"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              if (profile == UserRole.DRIVER ||
                  profile == UserRole.FORK_LIFT_OPERATOR)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: memuButton(
                        context: context,
                        onTap: () {
                          // Go to OpenTrils page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const OpenTripsPage()),
                          );
                        },
                        icon: FaIcon(
                          FontAwesomeIcons.plane,
                          // color: Theme.of(context).primaryColor,
                          color: Colors.white,
                          size: 30,
                        ),
                        title: "Trips",
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 5,
                      child: memuButton(
                        context: context,
                        onTap: () {
                          // Go to My Truck page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TruckPage()),
                          );
                        },
                        icon: FaIcon(
                          FontAwesomeIcons.truck,
                          // color: Theme.of(context).primaryColor,
                          color: Colors.white,
                        ),
                        title: "My Truck",
                      ),
                    ),
                  ],
                ),
              if (profile == UserRole.DISPATCHER ||
                  profile == UserRole.FORK_LIFT_OPERATOR)
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: memuButton(
                    context: context,
                    onTap: () {
                      // Go to OpenTrils page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LastXShipmentPage()),
                      );
                    },
                    icon: Icon(
                      Icons.refresh,
                      color: Colors.white,
                      size: 30,
                    ),
                    title: "Last 20 Shipments",
                  ),
                ),
              if (profile == UserRole.DISPATCHER ||
                  profile == UserRole.FORK_LIFT_OPERATOR)
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: memuButton(
                    context: context,
                    onTap: () {
                      // Go to OpenTrils page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FindShipmentPage()),
                      );
                    },
                    icon: Icon(
                      Icons.search_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                    title: "Find Shipment",
                  ),
                ),
              if (profile == UserRole.FORK_LIFT_OPERATOR ||
                  profile == UserRole.DISPATCHER)
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: memuButton(
                    context: context,
                    onTap: () {
                      // Go to OpenTrils page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const InsepctionPage()),
                      );
                    },
                    icon: Icon(
                      Icons.plagiarism_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                    title: "Inspection",
                  ),
                ),
              if (profile == UserRole.FORK_LIFT_OPERATOR ||
                  profile == UserRole.DISPATCHER)
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: memuButton(
                    context: context,
                    onTap: () {
                      // Go to My Truck page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const InboundPlans()),
                      );
                    },
                    icon:
                        Icon(Icons.source_sharp, size: 30, color: Colors.white),
                    title: "Inbounds Plans",
                  ),
                ),
              const SizedBox(height: 20),
              memuButton(
                context: context,
                onTap: () {
                  AppRoutes.push(context, const ChatPage());
                },
                icon: FaIcon(
                  FontAwesomeIcons.solidMessage,
                  // color: Theme.of(context).primaryColor,
                  color: Colors.white,
                ),
                title: "Messages",
              ),
              const SizedBox(height: 20),
              memuButton(
                context: context,
                onTap: () {
                  AppRoutes.push(context, const OthersPage());
                },
                icon: FaIcon(
                  FontAwesomeIcons.gears,
                  // color: Theme.of(context).primaryColor,
                  color: Colors.white,
                ),
                title: "Other",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget memuButton({
    required BuildContext context,
    required Function onTap,
    required Widget icon,
    required String title,
  }) {
    return InkWell(
      splashColor: Theme.of(context).primaryColor.withOpacity(0.3),
      onTap: () {
        return onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
        decoration: BoxDecoration(
          // color: Theme.of(context).primaryColor,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor,
              Color.fromARGB(255, 105, 6, 219),
            ],
          ),
          // border: Border.all(
          //   color: Theme.of(context).primaryColor,
          //   width: 2,
          // ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 15, 15, 15).withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(3, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            icon,
            const SizedBox(width: 10),
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .headline2!
                  .copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
