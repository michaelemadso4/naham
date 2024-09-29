// To parse this JSON data, do
//
//     final grAllMessageModel = grAllMessageModelFromJson(jsonString);

import 'dart:convert';

GrAllMessageModel grAllMessageModelFromJson(String str) => GrAllMessageModel.fromJson(json.decode(str));

String grAllMessageModelToJson(GrAllMessageModel data) => json.encode(data.toJson());

class GrAllMessageModel {
  bool ?success;
  List<Datum>? data;
  String? message;

  GrAllMessageModel({
    this.success,
    this.data,
    this.message,
  });

  factory GrAllMessageModel.fromJson(Map<String, dynamic> json) => GrAllMessageModel(
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
  int ?id;
  String? message;
  dynamic path;
  String ?type;
  dynamic locationLink;
  int ?groupId;
  int? userId;
  DateTime? createdAt;
  DateTime ?updatedAt;
  User ?user;

  Datum({
    this.id,
    this.message,
    this.path,
    this.type,
    this.locationLink,
    this.groupId,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    message: json["message"],
    path: json["path"],
    type: json["type"],
    locationLink: json["location_link"],
    groupId: json["group_id"],
    userId: json["user_id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    user: User.fromJson(json["user"]),
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
    "user": user!.toJson(),
  };
}

class User {
  int? id;
  String ?name;
  String ?profileImageFullUrl;

  User({
    this.id,
    this.name,
    this.profileImageFullUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    profileImageFullUrl: json["profile_image_full_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "profile_image_full_url": profileImageFullUrl,
  };
}
