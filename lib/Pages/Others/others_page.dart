import 'package:flutter/material.dart';
import 'package:opentrip/Configs/app_routes.dart';
import 'package:opentrip/Helpers/local_storage.dart';
import 'package:opentrip/Helpers/navigator_service.dart';
import 'package:opentrip/Pages/App/Provider/auth_provider.dart';
import 'package:opentrip/Pages/Chats/chat_page.dart';
import 'package:opentrip/Pages/CodePage/code_page.dart';
import 'package:opentrip/Pages/Others/TimeCard/time_card.dart';
import 'package:opentrip/Pages/Others/app_info/app_info.dart';
import 'package:opentrip/Pages/Others/check%20in%20and%20check%20out/check_in.dart';
import 'package:opentrip/Pages/Others/check%20in%20and%20check%20out/check_out.dart';
import 'package:opentrip/Pages/Others/contacts/contacts_page.dart';
import 'package:opentrip/Pages/Others/messages/messages_history.dart';
import 'package:opentrip/Pages/Others/settings/settings_page.dart';
import 'package:opentrip/Pages/SignInPage/signin_page.dart';
import 'package:opentrip/Pages/Trips/Documents/documents_page.dart';
import 'package:opentrip/Repositories/index.dart';
import 'package:opentrip/Services/firestore_service.dart';
import 'package:opentrip/Widgets/custom_appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Configs/app_styles.dart';
import '../../Widgets/loading_container.dart';
import 'TripsHistory/trips_history.dart';

enum OtherType {
  settings,
  contacts,
  // messages,
  checkIn,
  checkOut,
  document,
  timeCard,
  tripsHistory,
  resetFactory,
  about,
  deleteAccount,
  logout
}

class OthersPage extends StatefulWidget {
  const OthersPage({Key? key}) : super(key: key);

  @override
  State<OthersPage> createState() => _OthersPageState();
}

class _OthersPageState extends State<OthersPage> {
  bool _isLoading = false;

  // get otsherType => null;
  _onTap(OtherType otherType) async {
    switch (otherType) {
      case OtherType.settings:
        AppRoutes.push(context, const SettingsPage());
        break;
      // case OtherType.messages:
      //   AppRoutes.push(context,
      //       ChatPage()); // AppRoutes.push(context, const MessagesHistory());
      //   break;
      case OtherType.checkIn:
        AppRoutes.push(context, const CheckIn());
        break;
      case OtherType.checkOut:
        AppRoutes.push(context, const CheckOut());
        break;
      case OtherType.document:
        AppRoutes.push(
            context,
            DocumentsPage(
              truckName: "",
              trailerName: "",
              truckId: "0",
              trailerId: "0",
            ));
        break;
      case OtherType.timeCard:
        AppRoutes.push(context, const TimeCard());
        break;
      case OtherType.tripsHistory:
        AppRoutes.push(context, const TripsHistory());
        break;
      case OtherType.resetFactory:
        AppRoutes.push(context, const CodePage());
        break;
      case OtherType.about:
        AppRoutes.push(context, const AppInfo());
        break;
      case OtherType.logout:
        try {
          setState(() {
            _isLoading = true;
          });
          var user = AuthProvider.of(context).userChatModel;
          await FirestoreService.updateFCM(
              email: user?.email ?? "", fcmToken: "");
          SharedPreferences _sharedPreferences =
              await SharedPreferences.getInstance();
          await _sharedPreferences.remove(AppLocalKeys.TOKEN);
          // await _sharedPreferences.remove(AppLocalKeys.PASSWORD);
          // await _sharedPreferences.clear();
          setState(() {
            _isLoading = false;
          });
        } catch (e) {
          setState(() {
            _isLoading = false;
          });
        }
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => SignInPage()));
        break;
      case OtherType.contacts:
        AppRoutes.push(context, const ContactsPage());
        break;
      case OtherType.deleteAccount:
        _deleteAccount();
        break;
    }
  }

  _deleteAccount() async {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text("Are you sure?"),
            content: Text("Are you sure delete this account?"),
            actions: [
              TextButton(
                onPressed: () {
                  pop(context);
                },
                child: Text("Cancel"),
              ),
              TextButton(
                  onPressed: () async {
                    pop(context);
                    try {
                      setState(() {
                        _isLoading = true;
                      });
                      var user = AuthProvider.of(context).userModel;
                      await AppRepository.deleteAccount(user.driverID);
                      await FirestoreService.updateFCM(
                          email: user.email, fcmToken: "");
                      SharedPreferences _sharedPreferences =
                          await SharedPreferences.getInstance();
                      await _sharedPreferences.remove(AppLocalKeys.TOKEN);
                      Navigator.popUntil(context, (route) => route.isFirst);
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) => SignInPage()));
                      setState(() {
                        _isLoading = false;
                      });
                    } catch (e) {
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  },
                  child: Text(
                    "Delete",
                  ))
            ],
          );
        });
  }

  String _mapTitle(OtherType otherType) {
    switch (otherType) {
      case OtherType.settings:
        return "Settings";

      // case OtherType.messages:
      //   return "Messages";

      case OtherType.checkIn:
        return "Check-In";

      case OtherType.checkOut:
        return "Check-Out";

      case OtherType.document:
        return "Documents";

      case OtherType.timeCard:
        return "TimeCard";

      case OtherType.tripsHistory:
        return "Trips History";

      case OtherType.resetFactory:
        return "Customer Code";

      case OtherType.about:
        return "About";

      case OtherType.logout:
        return "Logout";
      case OtherType.contacts:
        return "Contacts";
      case OtherType.deleteAccount:
        return "Delete account";
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingContainer(
      isLoading: _isLoading,
      context: context,
      child: Scaffold(
        appBar: const CustomAppBar(title: "Others"),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 21, vertical: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0xffe2e2e2),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(OtherType.values.length, (index) {
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        _onTap(OtherType.values[index]);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _mapTitle(OtherType.values[index]),
                              style: AppStyles.textSize16(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Icon(Icons.keyboard_arrow_right),
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                      height: 1,
                      color: Color(0xffe2e2e2),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
