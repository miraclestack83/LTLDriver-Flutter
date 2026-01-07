class RepairType {
  final int? repairTypeId;
  final String? repairTypeName;

  RepairType({this.repairTypeId, this.repairTypeName});
  factory RepairType.fromJson(Map<String, dynamic> json) {
    return RepairType(
      repairTypeId: json['repairTypeID'],
      repairTypeName: json['RepairTypeName'],
    );
  }
}
