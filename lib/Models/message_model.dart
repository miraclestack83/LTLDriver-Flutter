class MessageModel {
  final String? type;
  final String? dateTime;
  final String? createdBy;
  final String? msgFrom;
  final String? msgTo;
  final String? subject;
  final String? msgBody;

  MessageModel(
      {this.type,
      this.dateTime,
      this.createdBy,
      this.msgFrom,
      this.msgTo,
      this.subject,
      this.msgBody});

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      createdBy: json['createdBy'],
      dateTime: json['Datetime'],
      msgBody: json['MsgBody'],
      msgFrom: json['MsgFrom'],
      msgTo: json['MsgTo'],
      subject: json['subject'],
      type: json['type'],
    );
  }
}
