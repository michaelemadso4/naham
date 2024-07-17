// To parse this JSON data, do
//
//     final contactModel = contactModelFromJson(jsonString);

import 'dart:convert';

ContactModel contactModelFromJson(String str) => ContactModel.fromJson(json.decode(str));

String contactModelToJson(ContactModel data) => json.encode(data.toJson());

class ContactModel {
  bool ?success;
  List<Datum> ?data;
  String? message;

  ContactModel({
    this.success,
    this.data,
    this.message,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) => ContactModel(
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
  String ?name;
  String? email;
  String? lastSignInTime;
  String? uid;
  dynamic status;
  String? fcmToken;
  String? guard;
  int? isOnline;
  int? sectionId;
  int? groupId;
  dynamic profileImage;
  double? lat;
  double? lng;
  String ?createdAt;
  String? updatedAt;
  String? profileImageFullUrl;

  Datum({
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
    this.profileImageFullUrl,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    lastSignInTime: json["lastSignInTime"],
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
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    profileImageFullUrl: json["profile_image_full_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "lastSignInTime": lastSignInTime,
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
    "created_at": createdAt,
    "updated_at": updatedAt,
    "profile_image_full_url": profileImageFullUrl,
  };
}
