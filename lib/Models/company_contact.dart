class CompanyContact {
  final String? fullName;
  final String? email;
  final String? cellPhone;
  final String? directPhone;
  final String? extension;
  final String? position;
  final String? id;

  CompanyContact(
      {this.fullName,
      this.email,
      this.cellPhone,
      this.directPhone,
      this.extension,
      this.position,
      this.id});
  factory CompanyContact.fromJson(Map<String, dynamic> json) {
    return CompanyContact(
        cellPhone: json['cellPhone'],
        directPhone: json['directPhone'],
        email: json['email'],
        extension: json['Extension'],
        fullName: json['FullName'],
        id: "${json['id']}",
        position: json['Position']);
  }
}
