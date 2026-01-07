import 'dart:convert';

class TripModel {
  int id;
  String descr;
  double miles;
  String truckName;
  int truckID;
  String trailerName;
  int trailerID;
  double tripPay;
  String appt;
  bool completed;
  bool isConfirmed;
  String confirmNotes;

  TripModel({
    this.id = 0,
    this.descr = "",
    this.miles = 0.0,
    this.truckName = "???",
    this.appt = "",
    this.truckID = 0,
    this.trailerName = "???",
    this.trailerID = 0,
    this.tripPay = 0.0,
    this.completed = false,
    this.isConfirmed = false,
    this.confirmNotes = "",
  });

  TripModel.fromJson(Map<String, dynamic> json)
      : id =
            (json['tripID'] != null) ? int.parse(json['tripID'].toString()) : 0,
        descr = (json['descr'] != null) ? json['descr'] : "",
        miles = (json['miles'] != null)
            ? double.parse(json['miles'].toString())
            : 0,
        truckName =
            (json['truckName'] != null) ? json['truckName'].toString() : "???",
        appt = (json['appt'] != null) ? json['appt'] : "",
        truckID = (json['truckID'] != null)
            ? int.parse(json['truckID'].toString())
            : 0,
        trailerName =
            (json['TrailerName'] != null) ? json['TrailerName'] : "???",
        trailerID = (json['TrailerID'] != null)
            ? int.parse(json['TrailerID'].toString())
            : 0,
        tripPay = (json['tripPay'] != null)
            ? double.parse(json['tripPay'].toString())
            : 0.0,
        completed = (json['completed'] != null) ? json['completed'] : false,
        isConfirmed =
            (json['isConfirmed'] != null) ? json['isConfirmed'] : false,
        confirmNotes =
            (json['ConfirmNotes'] != null) ? json['ConfirmNotes'] : "";

  Map<String, dynamic> toJson() {
    return {
      "id": (id == null) ? "" : id,
      "descr": (descr == null) ? "" : descr,
      "miles": (miles == null) ? 0.0 : miles,
      "truckName": (truckName == null) ? "" : truckName,
      "appt": (appt == null) ? "" : appt,
      "truckID": (truckID == null) ? 0 : truckID,
      "trailerName": (trailerName == null) ? "" : trailerName,
      "trailerID": (trailerID == null) ? 0 : trailerID,
      "tripPay": (tripPay == null) ? 0.0 : tripPay,
      "completed": (completed == null) ? false : completed,
      "isConfirmed": (isConfirmed == null) ? false : isConfirmed,
      "confirmNotes": (confirmNotes == null) ? "" : confirmNotes,
    };
  }
}
