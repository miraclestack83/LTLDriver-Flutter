import 'dart:convert';

import 'package:opentrip/Helpers/constant.dart';

class UserModel {
  String name;
  String email;
  int driverID;
  int lastShipment;
  int truckID;
  String theme;
  int terminalID;
  bool punchReqGPS;
  String profile;

  UserModel({
    this.name = "",
    this.email = "",
    this.driverID = 0,
    this.lastShipment = 0,
    this.profile = "",
    this.truckID = 0,
    this.theme = "a",
    this.terminalID = 0,
    this.punchReqGPS = false,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : name = (json['name'] != null) ? json['name'] : json['Name'] ?? "",
        email = '',
        driverID = (json['driverID'] != null)
            ? int.parse(json['driverID'].toString())
            : 0,
        lastShipment = (json['lastShipment'] != null)
            ? int.parse(json['lastShipment'].toString())
            : 0,
        profile = (json['profile'] != null) ? json['profile'] : UserRole.DRIVER,
        truckID = (json['truckID'] != null)
            ? int.parse(json['truckID'].toString())
            : 0,
        theme = (json['theme'] != null) ? json['theme'] : "a",
        terminalID = (json['terminalID'] != null)
            ? int.parse(json['terminalID'].toString())
            : 0,
        punchReqGPS =
            (json['punchReqGPS'] != null) ? json['punchReqGPS'] : false;

  Map<String, dynamic> toJson() {
    return {
      "name": (name == null) ? "" : name,
      "email": (email == null) ? "" : email,
      "driverID": (driverID == null) ? 0 : driverID,
      "lastShipment": (lastShipment == null) ? 0 : lastShipment,
      "profile": (profile == null) ? "" : profile,
      "truckID": (truckID == null) ? 0 : truckID,
      "theme": (theme == null) ? "a" : theme,
      "terminalID": (terminalID == null) ? 0 : terminalID,
      "punchReqGPS": (punchReqGPS == null) ? false : punchReqGPS,
    };
  }
}
