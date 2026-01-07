// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:opentrip/Models/index.dart';
import 'package:provider/provider.dart';

class AppProvider extends ChangeNotifier {
  static AppProvider of(BuildContext context, {bool listen = false}) =>
      Provider.of<AppProvider>(context, listen: listen);

  // API_URL
  String _apiURL = '';
  String get apiURL => _apiURL;
  void setApiURL(String api) {
    _apiURL = api;
    notifyListeners();
  }

  // API_SUFFIX
  String _apiSuffix = '';
  String get apiSuffix => _apiSuffix;
  void setApiSuffix(String apiSuffix) {
    _apiSuffix = apiSuffix;
    notifyListeners();
  }

  TripPlaceDetailModel _placeDetail = TripPlaceDetailModel();
  TripPlaceDetailModel get tripPlaceDetail => _placeDetail;
  void setTripPlaceDetail(TripPlaceDetailModel placeDetail) {
    _placeDetail = placeDetail;
    notifyListeners();
  }

  TripTaskModel _tripTask = TripTaskModel();
  TripTaskModel get tripTask => _tripTask;
  void setTripTask(TripTaskModel tripTask) {
    _tripTask = tripTask;
    notifyListeners();
  }
}
