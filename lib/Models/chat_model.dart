import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:logger/logger.dart';

class RoomModel {
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? isGeneral;
  final List<UserChatModel>? users;
  final String? lastedMessage;
  final String? title;
  final String? type;
  final String? image;
  final String? id;
  final List<String>? userIds;
  final String? companyCode;
  final Map<String, dynamic>? metaData;
  final Map<String, dynamic>? unread;
  RoomModel({
    this.userIds,
    this.id,
    this.type,
    this.title,
    this.createdAt,
    this.updatedAt,
    this.companyCode,
    this.isGeneral,
    this.users,
    this.image,
    this.lastedMessage,
    this.metaData,
    this.unread,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json, String id) {
    Logger().d(json);
    DateTime? createdAt;
    DateTime? updatedAt;
    if (json['created_at'] is String) {
      createdAt = DateTime.tryParse(json['created_at']);
    } else if (json['creadted_at'] is Timestamp) {
      createdAt = (json['created_at'] as Timestamp).toDate();
    }
    if (json['updated_at'] is String) {
      updatedAt = DateTime.tryParse(json['updated_at']);
    } else if (json['updated_at'] is Timestamp) {
      updatedAt = (json['updated_at'] as Timestamp).toDate();
    }
    return RoomModel(
      metaData: json['meta_data'],
      userIds: (json['userIds'] as List).map((e) => e.toString()).toList(),
      id: id,
      type: json['type'],
      createdAt: createdAt,
      lastedMessage: json['lasted_message'],
      isGeneral: json['is_general'],
      image: json['image'],
      updatedAt: updatedAt,
      users: (json['users'] as List)
          .map((e) => UserChatModel.fromJson(e))
          .toList(),
      title: json['title'],
      companyCode: json['company_code'],
      unread: json['unread'],
    );
  }

  RoomModel copyWith({
    final DateTime? createdAt,
    final DateTime? updatedAt,
    final bool? isGeneral,
    final List<UserChatModel>? users,
    final String? lastedMessage,
    final String? title,
    final String? type,
    final String? image,
    final String? id,
    final List<String>? userIds,
    final String? companyCode,
    final Map<String, dynamic>? unread,
  }) {
    return RoomModel(
      metaData: metaData ?? this.metaData,
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
      image: image ?? this.image,
      isGeneral: isGeneral ?? this.isGeneral,
      lastedMessage: lastedMessage ?? this.lastedMessage,
      title: title ?? this.title,
      type: type ?? this.type,
      updatedAt: updatedAt ?? this.updatedAt,
      userIds: userIds ?? this.userIds,
      users: users ?? this.users,
      companyCode: companyCode ?? this.companyCode,
      unread: unread ?? this.unread,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "userIds": userIds,
      "id": id,
      "type": type,
      // "created_at": createdAt,
      "lasted_message": lastedMessage,
      "is_general": isGeneral,
      // "updated_at": updatedAt,
      "users": users?.map((e) => e.toMap()).toList(),
      "title": title,
      "company_code": companyCode,
      "image": image,
      "meta_data": metaData,
      "unread": unread,
    };
  }
}

class ChatModel extends types.Message {
  final String? message;
  final int? updatedAt;
  final int? createdAt;
  final Map<String, dynamic>? metaData;
  ChatModel(
      {this.updatedAt,
      this.createdAt,
      this.message,
      required super.author,
      required super.id,
      this.metaData,
      required super.type});

  factory ChatModel.fromJson(Map<String, dynamic> json, String id) {
    var map = types.MessageType.values.asNameMap();
    var x = 'text';
    if (json['type'] != null) {
      x = json['type'];
      if (x == 'text/plain' || x == 'text') {
        x = 'text';
      } else if (x == 'image') {
        x = "image";
      } else {
        x = "file";
      }
    }

    var createdAt;
    if (json['created_at'] is String) {
      createdAt = DateTime.parse(json['created_at']).millisecondsSinceEpoch;
    } else if (json['created_at'] is int) {
      createdAt = json['created_at'];
    }

    var updatedAt;
    if (json['updated_at'] != null) {
      if (json['updated_at'] is String) {
        updatedAt = DateTime.parse(json['updated_at']).millisecondsSinceEpoch;
      } else if (json['updated_at'] is int) {
        updatedAt = json['updated_at'];
      }
    }

    return ChatModel(
        metaData: json['meta_data'],
        createdAt: createdAt,
        updatedAt: updatedAt,
        author: types.User(
          id: json['senderId'],
          firstName: json['sender_name'],
        ),
        id: id,
        message: json['text'],
        type: map[x]!);
  }
  @override
  Map<String, dynamic> toJson() {
    final dateTime =
        DateTime.fromMillisecondsSinceEpoch(createdAt!, isUtc: true);
    return {
      "created_at": dateTime.toIso8601String(),
      "text": message,
      "senderId": author.id,
      "updated_at": dateTime.toIso8601String(),
      "type": type.name,
      "meta_data": metaData,
      "sender_name": author.firstName,
    };
  }

  @override
  types.Message copyWith(
      {types.User? author,
      int? createdAt,
      String? id,
      Map<String, dynamic>? metadata,
      String? remoteId,
      types.Message? repliedMessage,
      String? roomId,
      bool? showStatus,
      types.Status? status,
      int? updatedAt}) {
    return ChatModel(
      author: author ?? this.author,
      id: id ?? this.id,
      type: type,
      message: message,
      createdAt: createdAt,
      metaData: metaData,
      updatedAt: updatedAt,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class UserChatModel {
  final String? email;
  final String? name;
  final String? role;
  final String? companyCode;
  final String? docId;
  final String? fcmToken;
  UserChatModel(
      {this.docId,
      this.fcmToken,
      this.email,
      this.name,
      this.role,
      this.companyCode});

  factory UserChatModel.fromJson(Map<String, dynamic> json, {String? id}) {
    return UserChatModel(
      companyCode: json['companyCode'],
      email: json['email'],
      name: json['name'],
      role: json['role'],
      docId: json['id'] ?? id,
      fcmToken: json['fcm'],
    );
  }
  UserChatModel copyWith({String? fcmToken}) {
    return UserChatModel(
      companyCode: companyCode,
      docId: docId,
      email: email,
      fcmToken: fcmToken ?? this.fcmToken,
      name: name,
      role: role,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "companyCode": companyCode,
      "email": email,
      "name": name,
      "role": role,
      'fcm': fcmToken,
      'id': docId,
    };
  }
}
