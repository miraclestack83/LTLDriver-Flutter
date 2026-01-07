import 'dart:convert';

class ShipmentModel {
  int shipNum;
  int statusCode;
  String? shipText;
  String? userID;
  String? createTime;
  String? Consignee;
  String? FullName;
  String? bookedBy;
  int movescount;
  String? ref1;
  String? soonestDelvDate;

  ShipmentModel({
    this.shipNum = 0,
    this.statusCode = 0,
    this.shipText,
    this.userID,
    this.createTime,
    this.Consignee,
    this.FullName,
    this.bookedBy,
    this.movescount = 0,
    this.ref1,
    this.soonestDelvDate,
  });

  ShipmentModel.fromJson(Map<String, dynamic> json)
      : shipNum = (json['shipNum'] != null)
            ? int.parse(json['shipNum'].toString())
            : 0,
        statusCode = (json['statusCode'] != null)
            ? int.parse(json['statusCode'].toString())
            : 0,
        movescount = (json['movescount'] != null)
            ? int.parse(json['movescount'].toString())
            : 0,
        shipText = json['shipText'],
        userID = json['userID'].toString(),
        createTime = json['createTime'],
        Consignee = json['Consignee'],
        FullName = json['FullName'],
        bookedBy = json['bookedBy'],
        ref1 = json['ref1'],
        soonestDelvDate = json['soonestDelvDate'];

  Map<String, dynamic> toJson() {
    return {
      "shipNum": (shipNum == null) ? 0 : shipNum,
      "statusCode": (statusCode == null) ? 0 : statusCode,
      "movescount": (movescount == null) ? 0 : movescount,
      "shipText": (shipText == null) ? 0 : shipText,
      "userID": (userID == null) ? "" : userID,
      "createTime": (createTime == null) ? "" : createTime,
      "Consignee": (Consignee == null) ? "" : Consignee,
      "FullName": (FullName == null) ? "" : FullName,
      "bookedBy": (bookedBy == null) ? "" : bookedBy,
      "ref1": (ref1 == null) ? "" : ref1,
      "soonestDelvDate": (soonestDelvDate == null) ? "" : soonestDelvDate,
    };
  }
}
