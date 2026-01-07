import 'package:logger/logger.dart';

class ShipmentDetailModel {
  final int? actualPCS;
  final int? actualSpots;
  final int? actualWeight;
  final String boLNumber;
  final String delvNotes;
  final String delvNumber;
  final String pickNotes;
  final String stopType;
  final String billingName;
  final String commodity;
  final String consigneeAddress1;
  final String consigneeCSZ;
  final String consigneeName;
  final String containerNumber;
  final String delvAPPTfrom;
  final String delvAPPTto;
  final String delvArrived;
  final String delvDone;
  final int loadID;
  final int pcs;
  final String pcsunits;
  final String pickAPPTfrom;
  final String pickAPPTto;
  final String pickArrived;
  final String pickDone;
  final String pickNumber;
  final String ref1;
  final String sealNumber;
  final double shipmentTotal;
  final String shipperAddress1;
  final String shipperCSZ;
  final String shipperName;
  final int spots;
  final int weight;

  ShipmentDetailModel({
    this.actualPCS,
    this.actualSpots = 0,
    this.actualWeight,
    required this.boLNumber,
    required this.delvNotes,
    required this.delvNumber,
    required this.pickNotes,
    required this.stopType,
    required this.billingName,
    required this.commodity,
    required this.consigneeAddress1,
    required this.consigneeCSZ,
    required this.consigneeName,
    required this.containerNumber,
    required this.delvAPPTfrom,
    required this.delvAPPTto,
    required this.delvArrived,
    required this.delvDone,
    required this.loadID,
    required this.pcs,
    required this.pcsunits,
    required this.pickAPPTfrom,
    required this.pickAPPTto,
    required this.pickArrived,
    required this.pickDone,
    required this.pickNumber,
    required this.ref1,
    required this.sealNumber,
    required this.shipmentTotal,
    required this.shipperAddress1,
    required this.shipperCSZ,
    required this.shipperName,
    this.spots = 0,
    this.weight = 0,
  });

  factory ShipmentDetailModel.fromJson(Map<String, dynamic> json) {
    Logger().e(json);
    return ShipmentDetailModel(
      actualPCS: json['ActualPCS'],
      actualSpots: json['ActualSpots'] ?? 0,
      actualWeight: json['ActualWeight'],
      boLNumber: json['BoLNumber'] ?? "",
      delvNotes: json['DelvNotes'] ?? "",
      delvNumber: json['DelvNumber'] ?? "",
      pickNotes: json['PickNotes'] ?? "",
      stopType: json['StopType'] ?? "",
      billingName: json['billingName'] ?? "",
      commodity: json['commodity'] ?? "",
      consigneeAddress1: json['consigneeAddress1'] ?? "",
      consigneeCSZ: json['consigneeCSZ'] ?? "",
      consigneeName: json['consigneeName'] ?? "",
      containerNumber: json['containerNumber'] ?? "",
      delvAPPTfrom: json['delvAPPTfrom'] ?? "",
      delvAPPTto: json['delvAPPTto'] ?? "",
      delvArrived: json['delvArrived'] ?? "",
      delvDone: json['delvDone'] ?? "",
      loadID: json['loadID'] ?? 0,
      pcs: json['pcs'] ?? 0,
      pcsunits: json['pcsunits'] ?? "",
      pickAPPTfrom: json['pickAPPTfrom'] ?? "",
      pickAPPTto: json['pickAPPTto'] ?? "",
      pickArrived: json['pickArrived'] ?? "",
      pickDone: json['pickDone'] ?? "",
      pickNumber: json['pickNumber'] ?? "",
      ref1: json['ref1'] ?? "",
      sealNumber: json['sealNumber'] ?? "",
      shipmentTotal:
          double.tryParse(json['shipmentTotal']?.toString() ?? "") ?? 0.0,
      shipperAddress1: json['shipperAddress1'] ?? "",
      shipperCSZ: json['shipperCSZ'] ?? "",
      shipperName: json['shipperName'] ?? "",
      spots: json['spots'] ?? 0,
      weight: json['weight'] ?? 0,
    );
  }
}
