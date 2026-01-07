import 'dart:convert';

class TripPlaceDetailModel {
  String shipperName;
  String shipperAddress1;
  String shipperCSZ;
  String shipperTimeZone;
  String consigneeName;
  String consigneeAddress1;
  String consigneeCSZ;
  String consigneeTimeZone;
  String StopType;
  String APPT_from;
  String APPT_to;
  bool PickIsAppt;
  bool PickIsVerified;
  String PickApptDTFrom;
  String PickApptDTTo;
  bool DelvIsAppt;
  bool DelvIsVerified;
  String DelvApptDTFrom;
  String DelvApptDTTo;
  int pcs;
  String pcsunits;
  double weight;
  String ActualPCS;
  String ActualSpots;
  String ActualWeight;
  String containerNumber;
  String sealNumber;
  String BoLNumber;
  String arrived;
  String done;
  String notes;
  int loadID;

  TripPlaceDetailModel({
    this.shipperName = "",
    this.shipperAddress1 = "",
    this.shipperCSZ = "",
    this.shipperTimeZone = "",
    this.consigneeName = "",
    this.consigneeAddress1 = "",
    this.consigneeCSZ = "",
    this.consigneeTimeZone = "",
    this.StopType = "",
    this.APPT_from = "",
    this.APPT_to = "",
    this.PickIsAppt = false,
    this.PickIsVerified = false,
    this.PickApptDTFrom = "",
    this.PickApptDTTo = "",
    this.DelvIsAppt = false,
    this.DelvIsVerified = false,
    this.DelvApptDTFrom = "",
    this.DelvApptDTTo = "",
    this.pcs = 0,
    this.pcsunits = "",
    this.weight = 0,
    this.ActualPCS = "",
    this.ActualSpots = "",
    this.ActualWeight = "",
    this.containerNumber = "",
    this.sealNumber = "",
    this.BoLNumber = "",
    this.arrived = "",
    this.done = "",
    this.notes = "",
    this.loadID = 0,
  });

  TripPlaceDetailModel.fromJson(var json)
      : shipperName = json['shipperName'] ?? "",
        shipperAddress1 = json['shipperAddress1'] ?? "",
        shipperCSZ = json['shipperCSZ'] ?? "",
        shipperTimeZone = json['shipperTimeZone'] ?? "",
        consigneeName = json['consigneeName'] ?? "",
        consigneeAddress1 = json['consigneeAddress1'] ?? "",
        consigneeCSZ = json['consigneeCSZ'] ?? "",
        consigneeTimeZone = json['consigneeTimeZone'] ?? "",
        StopType = json['StopType'] ?? "",
        APPT_from = json['APPT_from'] ?? "",
        APPT_to = json['APPT_to'] ?? "",
        PickIsAppt = json['PickIsAppt'] == 1 ? true : false,
        PickIsVerified = json['PickIsVerified'] ?? false,
        PickApptDTFrom = json['PickApptDTFrom'] ?? "",
        PickApptDTTo = json['PickApptDTTo'] ?? "",
        DelvIsAppt = json['DelvIsAppt'] == 1 ? true : false,
        DelvIsVerified = json['DelvIsVerified'] ?? false,
        DelvApptDTFrom = json['DelvApptDTFrom'] ?? "",
        DelvApptDTTo = json['DelvApptDTTo'] ?? "",
        pcs = (json['pcs'] != null) ? int.parse(json['pcs'].toString()) : 0,
        pcsunits = json['pcsunits'] ?? "",
        weight = (json['weight'] != null)
            ? double.parse(json['weight'].toString())
            : 0,
        ActualPCS = json['ActualPCS']?.toString() ?? "",
        ActualSpots = json['ActualSpots']?.toString() ?? "",
        ActualWeight = json['ActualWeight']?.toString() ?? "",
        containerNumber = json['containerNumber'] ?? "",
        sealNumber = json['sealNumber'] ?? "",
        BoLNumber = json['BoLNumber'] ?? "",
        arrived = json['arrived']?.toString() ?? "",
        done = json['done'] ?? "",
        notes = json['Notes'] ?? "",
        loadID = json['loadID'] ?? 0;

  Map<String, dynamic> toJson() {
    return {
      "shipperName": shipperName,
      "shipperAddress1": shipperAddress1,
      "shipperCSZ": shipperCSZ,
      "shipperTimeZone": shipperTimeZone,
      "consigneeName": consigneeName,
      "consigneeAddress1": consigneeAddress1,
      "consigneeCSZ": consigneeCSZ,
      "consigneeTimeZone": consigneeTimeZone,
      "stopType": StopType,
      "appT_from": APPT_from,
      "appT_to": APPT_to,
      "pickIsAppt": PickIsAppt,
      "pickIsVerified": PickIsVerified,
      "pickApptDTFrom": PickApptDTFrom,
      "pickApptDTTo": PickApptDTTo,
      "delvIsAppt": DelvIsAppt,
      "delvIsVerified": DelvIsVerified,
      "delvApptDTFrom": DelvApptDTFrom,
      "delvApptDTTo": DelvApptDTTo,
      "pcs": pcs,
      "pcsunits": pcsunits,
      "weight": weight,
      "actualPCS": ActualPCS,
      "actualSpots": ActualSpots,
      "actualWeight": ActualWeight,
      "containerNumber": containerNumber,
      "sealNumber": sealNumber,
      "boLNumber": BoLNumber,
      "arrived": arrived,
      "done": done,
      "notes": notes,
      "loadID": loadID
    };
  }
}
