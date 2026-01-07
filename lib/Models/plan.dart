class Plan {
  final int? planId;
  final String? trailerNumber;
  final String? driverName;
  final String? planNotes;
  final dynamic tripId;

  Plan(
      {this.planId,
      this.trailerNumber,
      this.driverName,
      this.planNotes,
      this.tripId});

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      driverName: json['DriverName'],
      planId: json['planID'],
      planNotes: json['PlanNotes'],
      trailerNumber: json['TrailerNumber'],
      tripId: json['tripID'],
    );
  }
}

class PlanDetails {
  final String? inbTrailerName;
  final int? shipNum;
  final String? routeType;
  final String? middleVendorCode;
  final String? middleVendorName;
  final String? shiperCityStateo;
  final String? consigCityStateale;
  final String? delvFromShort;
  final String? delvToShort;
  final String? pcs1;
  final String? uom;
  final int? weight;
  final int? id;
  final String? deliveryTrailerName;
  final String? planNotes;
  final int? proPics;

  PlanDetails(
      {this.inbTrailerName,
      this.shipNum,
      this.routeType,
      this.middleVendorCode,
      this.middleVendorName,
      this.shiperCityStateo,
      this.consigCityStateale,
      this.delvFromShort,
      this.delvToShort,
      this.pcs1,
      this.uom,
      this.weight,
      this.id,
      this.deliveryTrailerName,
      this.planNotes,
      this.proPics});
  factory PlanDetails.fromJson(Map<String, dynamic> json) {
    return PlanDetails(
      consigCityStateale: json['ConsigCityState'],
      deliveryTrailerName: json['DeliveryTrailerName'],
      delvFromShort: json['DelvFromShort'],
      delvToShort: json['DelvToShort'],
      id: json['id'],
      inbTrailerName: json['InbTrailerName'],
      middleVendorCode: json['MiddleVendorCode'],
      middleVendorName: json['MiddleVendorName'],
      pcs1: json['pcs1'],
      planNotes: json['PlanNotes'],
      proPics: json['pro_pics'],
      routeType: json['RouteType'],
      shipNum: json['shipNum'],
      shiperCityStateo: json['ShiperCityState'],
      uom: json['uom'],
      weight: json['weight'],
    );
  }
}
