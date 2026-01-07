import 'dart:typed_data';

class Repair {
  final String? createdAt;
  final String? createUser;
  final String? doneby;
  final List<ImageRepair>? images;
  final String? repairTypeName;
  final int? rtid;
  final String? task;

  Repair(
      {this.createdAt,
      this.createUser,
      this.doneby,
      this.images,
      this.repairTypeName,
      this.rtid,
      this.task});

  factory Repair.fromJson(Map<String, dynamic> json) {
    return Repair(
      createUser: json['createUser'],
      createdAt: json['createDT'],
      doneby: json['doneBy'],
      images: (json['images'] as List? ?? [])
          .map((e) => ImageRepair.fromJson(e))
          .toList(),
      repairTypeName: json['RepairTypeName'],
      rtid: json['rtID'],
      task: json['task'],
    );
  }
}

class ImageRepair {
  final int? erimgid;
  final String? insertdt;
  final String? insertuser;
  final Uint8List? picture;
  final int? size;

  ImageRepair(
      {this.erimgid, this.insertdt, this.picture, this.insertuser, this.size});

  factory ImageRepair.fromJson(Map<String, dynamic> json) {
    return ImageRepair(
      erimgid: json['erimgID'],
      picture: json['picture1']?['data'] != null
          ? Uint8List.fromList(json['picture1']['data'].cast<int>())
          : null,
      insertdt: json['insertdt'],
      insertuser: json['insertuser'],
      size: json['size'],
    );
  }
}
