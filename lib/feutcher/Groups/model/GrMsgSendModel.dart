// To parse this JSON data, do
//
//     final grMsgSendModel = grMsgSendModelFromJson(jsonString);

import 'dart:convert';

GrMsgSendModel grMsgSendModelFromJson(String str) => GrMsgSendModel.fromJson(json.decode(str));

String grMsgSendModelToJson(GrMsgSendModel data) => json.encode(data.toJson());

class GrMsgSendModel {
  bool? success;
  Data ?data;
  String? message;

  GrMsgSendModel({
    this.success,
    this.data,
    this.message,
  });

  factory GrMsgSendModel.fromJson(Map<String, dynamic> json) => GrMsgSendModel(
    success: json["success"],
    data: Data.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data!.toJson(),
    "message": message,
  };
}

class Data {
  int? id;
  String? message;
  String? path;
  String? type;
  String? locationLink;
  int? groupId;
  int? userId;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? time;

  Data({
    this.id,
    this.message,
    this.path,
    this.type,
    this.locationLink,
    this.groupId,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.time,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    message: json["message"],
    path: json["path"],
    type: json["type"],
    locationLink: json["location_link"],
    groupId: json["group_id"],
    userId: json["user_id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    time: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "message": message,
    "path": path,
    "type": type,
    "location_link": locationLink,
    "group_id": groupId,
    "user_id": userId,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
    "time": time,
  };
}
