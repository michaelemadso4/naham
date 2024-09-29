// To parse this JSON data, do
//
//     final groupInfoModel = groupInfoModelFromJson(jsonString);

import 'dart:convert';

GroupInfoModel groupInfoModelFromJson(String str) => GroupInfoModel.fromJson(json.decode(str));

String groupInfoModelToJson(GroupInfoModel data) => json.encode(data.toJson());

class GroupInfoModel {
  bool? success;
  Data? data;
  String? message;

  GroupInfoModel({
    this.success,
    this.data,
    this.message,
  });

  factory GroupInfoModel.fromJson(Map<String, dynamic> json) => GroupInfoModel(
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
  String? name;
  String? code;
  dynamic coordinates;
  String? activeChat;
  String? isActive;
  int? sectionId;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? usersCount;
  int? onlineUsersCount;

  Data({
    this.id,
    this.name,
    this.code,
    this.coordinates,
    this.activeChat,
    this.isActive,
    this.sectionId,
    this.createdAt,
    this.updatedAt,
    this.usersCount,
    this.onlineUsersCount,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    code: json["code"],
    coordinates: json["coordinates"],
    activeChat: json["active_chat"],
    isActive: json["is_active"],
    sectionId: json["section_id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    usersCount: json["users_count"],
    onlineUsersCount: json["online_users_count"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "code": code,
    "coordinates": coordinates,
    "active_chat": activeChat,
    "is_active": isActive,
    "section_id": sectionId,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
    "users_count": usersCount,
    "online_users_count": onlineUsersCount,
  };
}
