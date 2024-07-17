// To parse this JSON data, do
//
//     final groupModel = groupModelFromJson(jsonString);

import 'dart:convert';

GroupModel groupModelFromJson(String str) => GroupModel.fromJson(json.decode(str));

String groupModelToJson(GroupModel data) => json.encode(data.toJson());

class GroupModel {
  bool ?success;
  List<Datum>? data;
  String? message;

  GroupModel({
    this.success,
    this.data,
    this.message,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) => GroupModel(
    success: json["success"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    "message": message,
  };
}

class Datum {
  int? id;
  String? name;
  String? code;
  dynamic coordinates;
  String? activeChat;
  String? isActive;
  int? sectionId;
  String? createdAt;
  String? updatedAt;

  Datum({
    this.id,
    this.name,
    this.code,
    this.coordinates,
    this.activeChat,
    this.isActive,
    this.sectionId,
    this.createdAt,
    this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    code: json["code"],
    coordinates: json["coordinates"],
    activeChat: json["active_chat"],
    isActive: json["is_active"],
    sectionId: json["section_id"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "code": code,
    "coordinates": coordinates,
    "active_chat": activeChat,
    "is_active": isActive,
    "section_id": sectionId,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
