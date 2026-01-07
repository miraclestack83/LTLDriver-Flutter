import 'dart:typed_data';

class Document {
  final int? id;
  final String? docType;
  final String? mimeType1;
  final int? docSize;
  final String? descr;
  final Uint8List? picture;

  Document(
      {this.id,
      this.docType,
      this.mimeType1,
      this.docSize,
      this.descr,
      this.picture});
  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      descr: json['descr'],
      docSize: json['docSize'],
      docType: json['docType'],
      id: json['id'],
      mimeType1: json['mimeType1'],
      picture: json['picture1']?['data'] != null
          ? Uint8List.fromList(json['picture1']['data'].cast<int>())
          : null,
    );
  }
}
