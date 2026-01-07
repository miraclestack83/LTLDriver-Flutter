class MyTruck {
  final int? truckNum;
  final int? truckOrtrail;
  final String? truckName;
  final String? license;
  final String? licenseExp;
  final String? lastAnnualInsp;
  final int? odometer;
  final double? emptyWeight;
  final int? oilchanged;
  final double? defOil;
  final String? make;
  final String? model;
  final int? year;
  final String? notes;
  final String? vin;
  final double? mpg;
  final dynamic inUserFrom;

  MyTruck(
      {this.truckNum,
      this.truckOrtrail,
      this.truckName,
      this.license,
      this.licenseExp,
      this.lastAnnualInsp,
      this.odometer,
      this.emptyWeight,
      this.oilchanged,
      this.defOil,
      this.make,
      this.model,
      this.year,
      this.notes,
      this.vin,
      this.mpg,
      this.inUserFrom});

  factory MyTruck.fromJson(Map<String, dynamic> json) {
    return MyTruck(
      defOil:
          json['defOil'] != null ? double.parse(json['defOil'].toString()) : 0,
      emptyWeight: json['emptyWeight'] != null
          ? double.parse(json['emptyWeight'].toString())
          : 0,
      inUserFrom: json['inUseFrom'],
      lastAnnualInsp: json['lastAnnualInsp'],
      license: json['license'],
      licenseExp: json['license_exp'],
      make: json['Make'],
      model: json['Model'],
      mpg: json['mpg'] != null ? double.parse(json['mpg'].toString()) : 0,
      notes: json['notes'] ?? '',
      odometer:
          json['odometer'] != null ? int.parse(json['odometer'].toString()) : 0,
      oilchanged: json['oilchanged'],
      truckName: json['truckName'],
      truckNum: json['truckNum'],
      truckOrtrail: json['truckOrTrail'],
      vin: json['VIN'],
      year: json['year'],
    );
  }
}
