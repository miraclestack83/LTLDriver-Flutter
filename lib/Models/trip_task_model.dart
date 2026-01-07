import 'dart:convert';

class TripTaskModel {
  int srID;
  int pro;
  int tpmID;
  int tpID;
  String stopType;
  String placeType;
  String placeType2;
  String progress;
  int pcs;
  String pcsunits;
  double weight;
  String appt_from;
  String appt_to;
  String ArrivedDT;
  String doneDT;
  String PUNumber;
  String Notes;
  bool isPickup;
  int customerMoveID;
  int loadID;

  TripTaskModel({
    this.srID = 0,
    this.pro = 0,
    this.tpmID = 0,
    this.tpID = 0,
    this.stopType = "",
    this.placeType = "",
    this.placeType2 = "",
    this.progress = "",
    this.pcs = 0,
    this.pcsunits = "",
    this.weight = 0,
    this.appt_from = "",
    this.appt_to = "",
    this.ArrivedDT = "",
    this.doneDT = "",
    this.PUNumber = "",
    this.Notes = "",
    this.isPickup = false,
    this.customerMoveID = 0,
    this.loadID = 0,
  });

  TripTaskModel.fromJson(Map<String, dynamic> json)
      : srID = (json['SRID'] != null) ? int.parse(json['SRID'].toString()) : 0,
        pro = (json['pro'] != null) ? int.parse(json['pro'].toString()) : 0,
        tpmID =
            (json['tpmID'] != null) ? int.parse(json['tpmID'].toString()) : 0,
        tpID = (json['tpID'] != null) ? int.parse(json['tpID'].toString()) : 0,
        stopType = json['StopType'].trim() ?? "",
        placeType = json['placeType'].trim() ?? "",
        placeType2 = json['placeType2'].trim() ?? "",
        progress = json['progress'] ?? "",
        pcs = (json['pcs'] != null) ? int.parse(json['pcs'].toString()) : 0,
        pcsunits = json['pcsunits'] ?? "",
        appt_from = json['appt_from'] ?? "",
        appt_to = json['appt_to'] ?? "",
        ArrivedDT = json['ArrivedDT'] ?? "",
        PUNumber = json['PUNumber'] ?? "",
        doneDT = json['doneDT'] ?? "",
        Notes = json['Notes'] ?? "",
        weight = (json['weight'] != null)
            ? double.parse(json['weight'].toString())
            : 0,
        isPickup = json['isPickup'] ?? false,
        customerMoveID = (json['customerMoveID'] != null)
            ? int.parse(json['customerMoveID'].toString())
            : 0,
        loadID =
            (json['loadID'] != null) ? int.parse(json['loadID'].toString()) : 0;

  Map<String, dynamic> toJson() {
    return {
      "srid": srID,
      "pro": pro,
      "tpmID": tpmID,
      "tpID": tpID,
      "stopType": stopType,
      "placeType": placeType,
      "placeType2": placeType2,
      "progress": progress,
      "pcs": pcs,
      "pcsunits": pcsunits,
      "weight": weight,
      "appt_from": appt_from,
      "appt_to": appt_to,
      "arrivedDT": ArrivedDT,
      "doneDT": doneDT,
      "puNumber": PUNumber,
      "notes": Notes,
      "isPickup": isPickup,
      "customerMoveID": customerMoveID,
      "loadID": loadID,
    };
  }
}
