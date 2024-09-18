// To parse this JSON data, do
//
//     final chatMessageModel = chatMessageModelFromJson(jsonString);
// ChatMessageModel

class ChatMessageModel {
  bool? success;
  List<ChatMessage>? data;
  Links? links;
  Meta? meta;
  String? message;

  ChatMessageModel({this.success, this.data, this.links, this.meta, this.message});

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      success: json['success'],
      data: (json['data'] as List?)?.map((i) => ChatMessage.fromJson(i)).toList(),
      links: json['links'] != null ? Links.fromJson(json['links']) : null,
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.map((i) => i.toJson()).toList(),
      'links': links?.toJson(),
      'meta': meta?.toJson(),
      'message': message,
    };
  }
}

class ChatMessage {
  int? id;
  int? senderId;
  int? receiverId;
  String? message;
  String? path;
  String? type;
  String? locationLink;
  String? createdAt;
  String? updatedAt;
  String? time;
  String? touserid;

  ChatMessage({
    this.id,
    this.senderId,
    this.receiverId,
    this.message,
    this.path,
    this.type,
    this.locationLink,
    this.createdAt,
    this.updatedAt,
    this.time,
    this.touserid,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      message: json['message'],
      path: json['path'],
      type: json['type'],
      locationLink: json['location_link'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      time: json['time'],
      touserid: json['to_user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'message': message,
      'path': path,
      'type': type,
      'location_link': locationLink,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'time': time,
      'to_user_id': touserid,
    };
  }
}

class Links {
  String? prev;
  String? next;

  Links({this.prev, this.next});

  factory Links.fromJson(Map<String, dynamic> json) {
    return Links(
      prev: json['prev'],
      next: json['next'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'prev': prev,
      'next': next,
    };
  }
}

class Meta {
  int? total;
  int? perPage;
  int? currentPage;
  int? lastPage;

  Meta({this.total, this.perPage, this.currentPage, this.lastPage});

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      total: json['total'],
      perPage: json['per_page'],
      currentPage: json['current_page'],
      lastPage: json['last_page'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'per_page': perPage,
      'current_page': currentPage,
      'last_page': lastPage,
    };
  }
}

