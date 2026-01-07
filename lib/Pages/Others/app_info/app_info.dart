import 'package:flutter/material.dart';
import 'package:opentrip/Configs/app_styles.dart';
import 'package:intl/intl.dart';
import 'package:opentrip/Helpers/local_storage.dart';
import 'package:opentrip/Pages/App/Provider/auth_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../Widgets/custom_appbar.dart';

class AppInfo extends StatefulWidget {
  const AppInfo({Key? key}) : super(key: key);

  @override
  State<AppInfo> createState() => _AppInfoState();
}

class _AppInfoState extends State<AppInfo> {
  String customerURL = '';

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  @override
  void initState() {
    getCustomerURL();
    _initPackageInfo();
    // TODO: implement initState
    super.initState();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  getCustomerURL() async {
    customerURL = await getDataInLocal(
            key: AppLocalKeys.API_URL, type: StorableDataType.String) ??
        '';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var user = AuthProvider.of(context).userModel;

    return Scaffold(
      appBar: const CustomAppBar(title: "App Info"),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "LTLDriver app is compatible with wide range of devices including smartphones, tablets, laptops and desktop computers.\nIt should run on any device which is capable of running java.",
              style: AppStyles.textSize16(),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text(
                  "For more information visit ",
                  style: AppStyles.textSize16(),
                ),
                GestureDetector(
                  onTap: () {
                    launchUrlString("http://www.ltlmaster.com/",
                        mode: LaunchMode.externalApplication);
                  },
                  child: Text(
                    "LTLMaster website",
                    style: AppStyles.textSize16(
                            fontWeight: FontWeight.w600, color: Colors.blue)
                        .copyWith(decoration: TextDecoration.underline),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                launchUrlString("tel:+13124040270");
              },
              child: Text(
                "To report a problem with this app Call +1-312-404-0270",
                style: AppStyles.textSize16(
                        fontWeight: FontWeight.w600, color: Colors.blue)
                    .copyWith(decoration: TextDecoration.underline),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "App is reporting current date, time and Time Zone as:",
              style: AppStyles.textSize16(fontWeight: FontWeight.w600),
            ),
            Text(DateFormat.yMd().add_jm().format(DateTime.now())),
            const SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Customer URL: ",
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                Expanded(
                    child: Text(customerURL,
                        style: TextStyle(fontWeight: FontWeight.w400))),
              ],
            ),
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("User Email:",
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                Expanded(
                    child: Text(user.email,
                        style: TextStyle(fontWeight: FontWeight.w400))),
              ],
            ),
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Driver ID: ",
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                Expanded(
                    child: Text(user.driverID.toString(),
                        style: TextStyle(fontWeight: FontWeight.w400))),
              ],
            ),
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Terminal ID: ",
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                Expanded(
                    child: Text(user.terminalID.toString(),
                        style: TextStyle(fontWeight: FontWeight.w400))),
              ],
            ),
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Role: ",
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                Expanded(
                    child: Text(user.profile,
                        style: TextStyle(fontWeight: FontWeight.w400))),
              ],
            ),
            SizedBox(height: 25),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                          image: AssetImage('lib/Assets/Images/icon.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 3),
                Text(_packageInfo.appName),
                // SizedBox(height: 5),
                Text(
                    "Version: ${_packageInfo.version} (${_packageInfo.buildNumber})"),
              ],
            )
          ],
        ),
      ),
    );
  }
}
