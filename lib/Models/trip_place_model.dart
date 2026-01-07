import 'dart:convert';

class TripPlaceModel {
  int tpID;
  int tripID;
  String FullName;
  String Add1;
  String Add2;
  String CSZ;
  String Ph1;
  String Fax;
  String directions;
  int scheduling_type;
  String open_from1;
  String open_to1;
  String open_from2;
  String open_to2;
  String open_from3;
  String open_to3;
  String open_from4;
  String open_to4;
  String open_from5;
  String open_to5;
  String open_from6;
  String open_to6;
  String open_from7;
  String open_to7;
  String delivery_notes;
  String timezone;
  String website;
  String Email;
  bool isDock;
  bool isResidential;
  bool isHighSecurity;
  bool isLumper;
  String pickup_notes;
  double miles;
  String date1;
  double stopPay;
  int displayOrder;
  bool isArrived;
  bool isDone;

  TripPlaceModel({
    this.tpID = 0,
    this.tripID = 0,
    this.FullName = "",
    this.Add1 = "",
    this.Add2 = "",
    this.CSZ = "",
    this.Ph1 = "",
    this.Fax = "",
    this.directions = "",
    this.scheduling_type = 0,
    this.open_from1 = "",
    this.open_to1 = "",
    this.open_from2 = "",
    this.open_to2 = "",
    this.open_from3 = "",
    this.open_to3 = "",
    this.open_from4 = "",
    this.open_to4 = "",
    this.open_from5 = "",
    this.open_to5 = "",
    this.open_from6 = "",
    this.open_to6 = "",
    this.open_from7 = "",
    this.open_to7 = "",
    this.delivery_notes = "",
    this.timezone = "",
    this.website = "",
    this.Email = "",
    this.isDock = false,
    this.isResidential = false,
    this.isHighSecurity = false,
    this.isLumper = false,
    this.pickup_notes = "",
    this.miles = 0.0,
    this.date1 = "",
    this.stopPay = 0.0,
    this.displayOrder = 0,
    this.isArrived = false,
    this.isDone = false,
  });

  TripPlaceModel.fromJson(Map<String, dynamic> json)
      : tpID = (json['tpID'] != null) ? int.parse(json['tpID'].toString()) : 0,
        tripID =
            (json['tripID'] != null) ? int.parse(json['tripID'].toString()) : 0,
        FullName = json['FullName'] ?? "",
        Add1 = json['Add1'] ?? "",
        Add2 = json['Add2'] ?? "",
        CSZ = json['CSZ'] ?? "",
        Ph1 = json['Ph1'] ?? "",
        Fax = json['Fax'] ?? "",
        directions = json['directions'] ?? "",
        scheduling_type = (json['scheduling_type'] != null)
            ? int.parse(json['scheduling_type'].toString())
            : 0,
        open_from1 = json['open_from1'] ?? "",
        open_from2 = json['open_from2'] ?? "",
        open_from3 = json['open_from3'] ?? "",
        open_from4 = json['open_from4'] ?? "",
        open_from5 = json['open_from5'] ?? "",
        open_from6 = json['open_from6'] ?? "",
        open_from7 = json['open_from7'] ?? "",
        open_to1 = json['open_to1'] ?? "",
        open_to2 = json['open_to2'] ?? "",
        open_to3 = json['open_to3'] ?? "",
        open_to4 = json['open_to4'] ?? "",
        open_to5 = json['open_to5'] ?? "",
        open_to6 = json['open_to6'] ?? "",
        open_to7 = json['open_to7'] ?? "",
        delivery_notes = json['delivery_notes'] ?? "",
        timezone = json['timezone'] ?? "",
        website = json['website'] ?? "",
        Email = json['Email'] ?? "",
        isDock = json['isDock'] ?? false,
        isResidential = json['isResidential'] ?? false,
        isHighSecurity = json['isHighSecurity'] ?? false,
        isLumper = json['isLumper'] ?? false,
        pickup_notes = json['pickup_notes'] ?? "",
        miles = (json['miles'] != null)
            ? double.parse(json['miles'].toString())
            : 0,
        stopPay = (json['stopPay'] != null)
            ? double.parse(json['stopPay'].toString())
            : 0,
        displayOrder = (json['displayOrder'] != null)
            ? int.parse(json['displayOrder'].toString())
            : 0,
        date1 = json['date1'] ?? "",
        isArrived = json['isArrived'] ?? false,
        isDone = json['isDone'] ?? false;

  Map<String, dynamic> toJson() {
    return {
      "tpID": tpID,
      "tripID": tripID,
      "fullName": FullName,
      "add1": Add1,
      "add2": Add2,
      "cas": CSZ,
      "ph1": Ph1,
      "fax": Fax,
      "directions": directions,
      "scheduling_type": scheduling_type,
      "open_from1": open_from1,
      "open_to1": open_to1,
      "open_from2": open_from2,
      "open_to2": open_to2,
      "open_from3": open_from3,
      "open_to3": open_to3,
      "open_from4": open_from4,
      "open_to4": open_to4,
      "open_from5": open_from5,
      "open_to5": open_to5,
      "open_from6": open_from6,
      "open_to6": open_to6,
      "open_from7": open_from7,
      "open_to7": open_to7,
      "delivery_notes": delivery_notes,
      "timezone": timezone,
      "website": website,
      "email": Email,
      "isDock": isDock,
      "isResidential": isResidential,
      "isHighSecurity": isHighSecurity,
      "isLumper": isLumper,
      "pickup_notes": pickup_notes,
      "miles": miles,
      "date1": date1,
      "stopPay": stopPay,
      "displayOrder": displayOrder,
      "isArrived": isArrived,
      "isDone": isDone
    };
  }
}
