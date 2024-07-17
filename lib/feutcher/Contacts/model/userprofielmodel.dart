// To parse this JSON data, do
//
//     final userprofileModel = userprofileModelFromJson(jsonString);

import 'dart:convert';

UserprofileModel userprofileModelFromJson(String str) => UserprofileModel.fromJson(json.decode(str));

String userprofileModelToJson(UserprofileModel data) => json.encode(data.toJson());

class UserprofileModel {
  bool ?success;
  Data ?data;
  String? message;

  UserprofileModel({
    this.success,
    this.data,
    this.message,
  });

  factory UserprofileModel.fromJson(Map<String, dynamic> json) => UserprofileModel(
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
  String ?name;
  String ?email;
  String ?guard;
  String? uid;
  int ?isOnline;
  dynamic profileImage;
  String? profileImageFullUrl;

  Data({
    this.id,
    this.name,
    this.email,
    this.guard,
    this.uid,
    this.isOnline,
    this.profileImage,
    this.profileImageFullUrl,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    guard: json["guard"],
    uid: json["uid"],
    isOnline: json["is_online"],
    profileImage: json["profile_image"],
    profileImageFullUrl: json["profile_image_full_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "guard": guard,
    "uid": uid,
    "is_online": isOnline,
    "profile_image": profileImage,
    "profile_image_full_url": profileImageFullUrl,
  };
}
