import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:opentrip/Configs/app_styles.dart';
import 'package:opentrip/Pages/App/Styles/index.dart';
import 'package:opentrip/Repositories/index.dart';

import '../../../Helpers/local_storage.dart';
import '../../../Widgets/custom_appbar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../Widgets/loading_container.dart';
import '../../../Widgets/toast_alert.dart';

class CheckIn extends StatefulWidget {
  const CheckIn({Key? key}) : super(key: key);

  @override
  State<CheckIn> createState() => _CheckInState();
}

class _CheckInState extends State<CheckIn> {
  final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  bool _isLoading = false;

  // Completer<GoogleMapController> _controller = Completer();
  Completer<GoogleMapController> _controller = Completer();
  Position? _position;
  @override
  void initState() {
    _determinePosition();
    super.initState();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    final result = await Geolocator.getCurrentPosition();

    setState(() {
      _position = result;
    });
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(result.latitude, result.longitude))));
  }

  _checkIn() async {
    if (_position == null) {
      return;
    }
    try {
      setState(() {
        _isLoading = true;
      });
      final driverId = await getDataInLocal(
          key: AppLocalKeys.DRIVER_ID, type: StorableDataType.INT);
      final res = await AppRepository.checkIn({
        "driverId": int.parse(driverId.toString()),
        "latitude": _position!.latitude,
        "longitude": _position!.longitude,
        "timestamp": DateTime.now().millisecondsSinceEpoch
      });
      setState(() {
        _isLoading = false;
      });
      ToastAlart.success(context, "Check In successfully!");
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ToastAlart.error(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return LoadingContainer(
      context: context,
      isLoading: _isLoading,
      child: Scaffold(
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(horizontal: 21, vertical: 10),
          color: Theme.of(context).primaryColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Your current location",
                style: AppStyles.textSize16(color: Colors.white),
              ),
              Text(
                "Lat: ${_position?.latitude ?? ""}",
                style: AppStyles.textSize16(color: Colors.white),
              ),
              Text(
                "Lat: ${_position?.longitude ?? ""}",
                style: AppStyles.textSize16(color: Colors.white),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: CustomAppBar(title: "Check In"),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: _checkIn,
            label: Row(
              children: [
                Icon(Icons.location_on),
                const Text("Check In"),
              ],
            )),
        body: GoogleMap(
          mapType: MapType.hybrid,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
        // body: MapboxMap(
        //   accessToken: '<your access token>',
        //   onMapCreated: (controller) {
        //     _controller.complete(controller);
        //   },
        //   initialCameraPosition: CameraPosition(
        //     target: LatLng(37.7749, -122.4194),
        //     zoom: 12.0,
        //   ),
        // );
      ),
    );
  }
}
