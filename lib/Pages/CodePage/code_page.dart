import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:majascan/majascan.dart';
import 'package:opentrip/Configs/app_routes.dart';
import 'package:opentrip/Helpers/index.dart';
import 'package:opentrip/Pages/App/Provider/app_provider.dart';
import 'package:opentrip/Pages/Others/others_page.dart';
import 'package:opentrip/Pages/SignInPage/signin_page.dart';
import 'package:opentrip/Pages/Trips/OpenTripsPage/open_trips_page.dart';
import 'package:opentrip/Pages/Truck/truck_page.dart';
import 'package:opentrip/Repositories/app_repository.dart';
import 'package:opentrip/Widgets/custom_textform.dart';
import 'package:opentrip/Widgets/toast_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../InboundPlans/inbound_plans.dart';
import '../Inspection/inspection_page.dart';

class CodePage extends StatefulWidget {
  const CodePage({Key? key}) : super(key: key);

  @override
  _CodePageState createState() => _CodePageState();
}

class _CodePageState extends State<CodePage> {
  String profile = '';
  TextEditingController codeCtl = new TextEditingController();
  bool isLoading = false;
  @override
  void initState() {
    _init();
    super.initState();
  }

  _init() async {
    // profile = await getDataInLocal(
    //     key: AppLocalKeys.PROFILE, type: StorableDataType.String);
    setState(() {
      codeCtl.text = "DEMO";
    });
  }

  // Scan QR Code
  Future<void> scanQR() async {
    String? qrResult = await MajaScan.startScan(
      title: "QRcode scanner",
      barColor: Theme.of(context).primaryColor,
      titleColor: Colors.white,
      qRCornerColor: Colors.yellow,
      qRScannerColor: Colors.yellow,
      flashlightEnable: true,
      scanAreaScale: 0.8,
    );
    print(qrResult);
    setState(() {
      codeCtl.text = qrResult!;
    });
  }

  // Save URL
  Future<void> save() async {
    if (codeCtl.text == "") {
      ToastAlart.error(context, "Please enter customer code");
      return;
    }
    await setCode(codeCtl.text.toUpperCase());
  }

  // Reset
  Future<void> reset() async {
    // Remove API_URL
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppLocalKeys.CODE);
    await prefs.remove(AppLocalKeys.API_URL);
    await prefs.remove(AppLocalKeys.API_SUFFIX);
    await setCode("DEMO");
  }

  Future<void> setCode(String code) async {
    setState(() {
      isLoading = true;
    });
    Map res = await AppRepository.getURLWithCode(code);
    print(res);

    if (res['success']) {
      Map data = res['data'];
      String siteURL = data['siteURL'] ?? '';
      String apiSuffix = data['api_suffix'] ?? "";
      try {
        // CODE
        await storeDataToLocal(
            key: AppLocalKeys.CODE,
            value: codeCtl.text.toUpperCase(),
            type: StorableDataType.String);

        // APP URL
        await storeDataToLocal(
            key: AppLocalKeys.API_URL,
            value: siteURL,
            type: StorableDataType.String);

        // API SUFFIX
        await storeDataToLocal(
            key: AppLocalKeys.API_SUFFIX,
            value: apiSuffix,
            type: StorableDataType.String);

        // Notify to Provider
        AppProvider.of(context).setApiURL(siteURL);
        AppProvider.of(context).setApiSuffix(apiSuffix);

        setState(() {
          isLoading = false;
        });

        // Show Success Page
        ToastAlart.success(context, "Customer URL is changed successfully!");

        // Go to SignIn Page
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => SignInPage()),
          (Route<dynamic> route) => false,
        );
      } catch (e) {
        ToastAlart.error(context, e.toString());
      }
    } else {
      setState(() {
        isLoading = false;
      });
      ToastAlart.error(
          context, "Sorry, Server error!. Please contact administrator.");
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Code Page"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: isLoading
          ? const Center(
              child: const CircularProgressIndicator(),
            )
          : Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Please type your code",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 29, 28, 28),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  customTextForm(
                    context: context,
                    controller: codeCtl,
                    fieldname: "Code",
                    icon: Icon(
                      Icons.key,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        "or Scan QR Code",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 29, 28, 28),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: IconButton(
                          onPressed: () async {
                            await scanQR();
                          },
                          icon: const Icon(
                            Icons.qr_code_2,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  memuButton(
                    context: context,
                    onTap: () async {
                      await save();
                    },
                    icon: const FaIcon(
                      Icons.save,
                      color: Colors.white,
                    ),
                    title: "SAVE",
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  memuButton(
                    context: context,
                    onTap: () async {
                      await reset();
                    },
                    icon: const FaIcon(
                      Icons.restore,
                      color: Colors.white,
                    ),
                    title: "RESET FACTORY SETTING",
                    backColor: Colors.red[700],
                  ),
                ],
              ),
            ),
    );
  }

  Widget memuButton({
    required BuildContext context,
    required Function onTap,
    required Widget icon,
    required String title,
    Color? backColor,
  }) {
    return InkWell(
      splashColor: Theme.of(context).primaryColor.withOpacity(0.3),
      onTap: () {
        return onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        decoration: BoxDecoration(
          color: backColor ?? Theme.of(context).primaryColor,
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
