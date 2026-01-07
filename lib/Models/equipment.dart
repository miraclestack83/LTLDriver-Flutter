class Equipment {
  final int? truckNum;
  final String? truckName;
  final String? category;
  final String? name;
  final String? make;
  final String? model;
  final int? builYear;
  final String? licensenum;

  Equipment(
      {this.truckNum,
      this.truckName,
      this.category,
      this.name,
      this.make,
      this.model,
      this.builYear,
      this.licensenum});

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      builYear: json['buildyear'],
      category: json['category'],
      licensenum: json['licensenum'],
      make: json['make'],
      model: json['model'],
      name: json['name'],
      truckName: json['truckname'],
      truckNum: json['trucknum'],
    );
  }
}
