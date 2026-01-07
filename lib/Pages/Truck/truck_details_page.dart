import 'package:flutter/material.dart';

import '../../Helpers/local_storage.dart';
import '../../Models/my_truck.dart';
import '../../Repositories/app_repository.dart';
import '../../Widgets/toast_alert.dart';

class TruckDetailsPage extends StatefulWidget {
  const TruckDetailsPage({Key? key}) : super(key: key);

  @override
  State<TruckDetailsPage> createState() => _TruckDetailsPageState();
}

class _TruckDetailsPageState extends State<TruckDetailsPage> {
  List<MyTruck> myTrucks = [];
  String _driverId = '';
  bool _isLoading = false;
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
      final driverId = await getDataInLocal(
          key: AppLocalKeys.DRIVER_ID, type: StorableDataType.INT);
      _driverId = "$driverId";
      myTrucks = await AppRepository.getMyTruck("$driverId");
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
    return Builder(builder: (context) {
      if (_isLoading == false && myTrucks.isEmpty) {
        return Center(
          child: Text("No data found."),
        );
      }
      if (myTrucks.isNotEmpty) {
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Name: ${myTrucks.first.truckName}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  "${myTrucks.first.make} ${myTrucks.first.model}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  "Year: ${myTrucks.first.year}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  "License: ${myTrucks.first.license}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  "License Epirationx: ${myTrucks.first.licenseExp}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  "VIN: ${myTrucks.first.vin}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  "ODO: ${myTrucks.first.odometer}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  "Last Oil Changed: ${myTrucks.first.oilchanged}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  "Last Annual Inspection: ${myTrucks.first.lastAnnualInsp}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  "Notes: ${myTrucks.first.notes}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        );
      }
      return Container();
    });
  }
}
