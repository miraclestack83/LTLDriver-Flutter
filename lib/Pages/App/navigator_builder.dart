import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:opentrip/Helpers/constant.dart';
import 'package:opentrip/Models/user_model.dart';
import 'package:opentrip/Pages/App/Provider/auth_provider.dart';
import 'package:opentrip/Pages/CodePage/code_page.dart';
import 'package:opentrip/Pages/HomePage/home_page.dart';
import 'package:opentrip/Pages/SignInPage/signin_page.dart';
import 'package:opentrip/Services/firestore_service.dart';
import 'package:opentrip/main.dart';

import '../../Helpers/local_storage.dart';
import '../../Repositories/user_repository.dart';
import 'package:http/http.dart' as http;

class NavigatorBuilder extends StatefulWidget {
  const NavigatorBuilder({Key? key}) : super(key: key);

  @override
  State<NavigatorBuilder> createState() => _NavigatorBuilderState();
}

class _NavigatorBuilderState extends State<NavigatorBuilder> {
  bool _isLoading = false;
  @override
  void initState() {
    _init();
    super.initState();
  }

  _init() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final String code = await getDataInLocal(
              key: AppLocalKeys.CODE, type: StorableDataType.String) ??
          '';

      final String apiURL = await getDataInLocal(
              key: AppLocalKeys.API_URL, type: StorableDataType.String) ??
          '';

      final token = await getDataInLocal(
              key: AppLocalKeys.TOKEN, type: StorableDataType.String) ??
          '';

      final email = await getDataInLocal(
              key: AppLocalKeys.EMAIL, type: StorableDataType.String) ??
          '';

      if (code.isEmpty || apiURL.isEmpty) {
        setState(() {
          _isLoading = false;
        });
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => CodePage()));
        return;
      }

      if (token.isEmpty) {
        setState(() {
          _isLoading = false;
        });
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => SignInPage()));
        return;
      }

      // Parse token to Map
      final Map profile = await getUserDetails(token);

      Map<String, dynamic> data = {
        'email': profile['name'],
        'companyCode': code,
      };
      Map<String, dynamic> res = await UserRepository.login(data);

      // Error Check
      if ((res['error'] != null && res['error'] != "")) {
        setState(() {
          _isLoading = false;
        });
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => SignInPage()));
      } else {
        // Save Data
        ///-------------------------------------
        /// SAVE INFOS
        /// ------------------------------------
        await storeDataToLocal(
          key: AppLocalKeys.TOKEN,
          value: token,
          type: StorableDataType.String,
        );

        await storeDataToLocal(
            key: AppLocalKeys.DRIVER_ID,
            value: res[AppLocalKeys.DRIVER_ID] != null
                ? int.parse(res[AppLocalKeys.DRIVER_ID].toString())
                : 0,
            type: StorableDataType.INT);

        await storeDataToLocal(
            key: AppLocalKeys.TERMINAL_ID,
            value: res[AppLocalKeys.TERMINAL_ID] != null
                ? int.parse(res[AppLocalKeys.TERMINAL_ID].toString())
                : 0,
            type: StorableDataType.INT);

        await storeDataToLocal(
            key: AppLocalKeys.TRUCK_ID,
            value: res[AppLocalKeys.TRUCK_ID] != null
                ? int.parse(res[AppLocalKeys.TRUCK_ID].toString())
                : 0,
            type: StorableDataType.INT);

        await storeDataToLocal(
            key: AppLocalKeys.PROFILE,
            value: res[AppLocalKeys.PROFILE] ?? UserRole.DRIVER,
            type: StorableDataType.String);

        await storeDataToLocal(
            key: AppLocalKeys.USERNAME,
            value: res['Name'].toString() ?? "",
            type: StorableDataType.String);

        await storeDataToLocal(
          key: AppLocalKeys.EMAIL,
          // value: 'adamwalan@yahoo.com',
          value: email,
          type: StorableDataType.String,
        );

        await storeDataToLocal(
            key: AppLocalKeys.LAST_SHIPMENT,
            value: res[AppLocalKeys.LAST_SHIPMENT] != null
                ? int.parse(res[AppLocalKeys.LAST_SHIPMENT].toString())
                : 0,
            type: StorableDataType.INT);

        await storeDataToLocal(
            key: AppLocalKeys.PUNCH_REQ_GPS,
            value: res[AppLocalKeys.PUNCH_REQ_GPS] ?? false,
            type: StorableDataType.BOOL);

        await storeDataToLocal(
            key: AppLocalKeys.THEME,
            value: res[AppLocalKeys.THEME] ?? "a",
            type: StorableDataType.String);

        UserModel userModel = UserModel.fromJson(res);
        userModel.email = email;
        AuthProvider.of(context).setUserModel(userModel);

        /// Save Firebase User
        await FirestoreService.addUser(
          email: email,
          name: userModel.name == '' ? email : userModel.name,
          role: userModel.profile,
          companyCode: code,
        );
        setState(() {
          _isLoading = false;
        });

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomePage()));
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (_) => SignInPage()));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const CodePage()));
    }

    // await flutterLocalNotificationsPlugin.initialize(
    //   InitializationSettings(),
    //   onDidReceiveNotificationResponse: (details) {
    //     print("tap!!!");
    //   },
    // );
  }

  // Get user profile
  Future<Map> getUserDetails(String accessToken) async {
    const String url = 'https://${Constant.AUTH0_DOMAIN}/userinfo';
    final http.Response response = await http.get(
      Uri.parse(url),
      headers: <String, String>{'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get user details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return const Scaffold(
        // backgroundColor: Color.fromARGB(239, 50, 19, 189),
        backgroundColor: Colors.white,
        body: Center(
            child: CircularProgressIndicator(
          color: Color.fromARGB(239, 50, 19, 189),
        )),
      );
    });
  }
}
