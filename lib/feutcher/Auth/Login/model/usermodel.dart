// To parse this JSON data, do
//
//     final usermodel = usermodelFromJson(jsonString);

import 'dart:convert';

Usermodel usermodelFromJson(String str) => Usermodel.fromJson(json.decode(str));

String usermodelToJson(Usermodel data) => json.encode(data.toJson());

class Usermodel {
  bool? success;
  Data ?data;
  String? message;

  Usermodel({
    this.success,
    this.data,
    this.message,
  });

  factory Usermodel.fromJson(Map<String, dynamic> json) => Usermodel(
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
  int ?id;
  String ?name;
  String ?email;
  DateTime ? lastSignInTime;
  String? uid;
  String? status;
  String? fcmToken;
  String ?guard;
  int? isOnline;
  int? sectionId;
  int? groupId;
  String? profileImage;
  double? lat;
  double? lng;
  DateTime? createdAt;
  DateTime? updatedAt;
  String ?accessToken;
  String? profileImageFullUrl;
  Group? group;

  Data({
    this.id,
    this.name,
    this.email,
    this.lastSignInTime,
    this.uid,
    this.status,
    this.fcmToken,
    this.guard,
    this.isOnline,
    this.sectionId,
    this.groupId,
    this.profileImage,
    this.lat,
    this.lng,
    this.createdAt,
    this.updatedAt,
    this.accessToken,
    this.profileImageFullUrl,
    this.group,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    lastSignInTime: DateTime.parse(json["lastSignInTime"]),
    uid: json["uid"],
    status: json["status"],
    fcmToken: json["FcmToken"],
    guard: json["guard"],
    isOnline: json["is_online"],
    sectionId: json["section_id"],
    groupId: json["group_id"],
    profileImage: json["profile_image"],
    lat: json["lat"],
    lng: json["lng"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    accessToken: json["access_token"],
    profileImageFullUrl: json["profile_image_full_url"],
    group: Group.fromJson(json["group"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "lastSignInTime": lastSignInTime!.toIso8601String(),
    "uid": uid,
    "status": status,
    "FcmToken": fcmToken,
    "guard": guard,
    "is_online": isOnline,
    "section_id": sectionId,
    "group_id": groupId,
    "profile_image": profileImage,
    "lat": lat,
    "lng": lng,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
    "access_token": accessToken,
    "profile_image_full_url": profileImageFullUrl,
    "group": group!.toJson(),
  };
}

class Group {
  int? id;
  String? name;

  Group({
    this.id,
    this.name,
  });

  factory Group.fromJson(Map<String, dynamic> json) => Group(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
