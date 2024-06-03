class NotificationModel {
  bool? success;
  String? message;
  int? count;
  String? next;
  String? previous;
  List<NotificationData>? data;

  NotificationModel(
      {this.success,
        this.message,
        this.count,
        this.next,
        this.previous,
        this.data});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['data'] != null) {
      data = <NotificationData>[];
      json['data'].forEach((v) {
        data!.add(new NotificationData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['count'] = this.count;
    data['next'] = this.next;
    data['previous'] = this.previous;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NotificationData {
  String? uuid;
  String? title;
  String? message;
  String? type;
  bool? status;
  Room? room;
  Event? event;
  LikedBy? likedBy;
  String? createdAt;
  String? updatedAt;

  NotificationData(
      {this.uuid,
        this.title,
        this.message,
        this.type,
        this.status,
        this.room,
        this.event,
        this.likedBy,
        this.createdAt,
        this.updatedAt});

  NotificationData.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    title = json['title'];
    message = json['message'];
    type = json['type'];
    status = json['status'];
    room = json['room'] != null ? new Room.fromJson(json['room']) : null;
    event = json['event'] != null ? new Event.fromJson(json['event']) : null;
    likedBy = json['liked_by'] != null
        ? new LikedBy.fromJson(json['liked_by'])
        : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['title'] = this.title;
    data['message'] = this.message;
    data['type'] = this.type;
    data['status'] = this.status;
    if (this.room != null) {
      data['room'] = this.room!.toJson();
    }
    if (this.event != null) {
      data['event'] = this.event!.toJson();
    }
    if (this.likedBy != null) {
      data['liked_by'] = this.likedBy!.toJson();
    }
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Room {
  String? uuid;
  String? name;
  String? type;

  Room({this.uuid, this.name, this.type});

  Room.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    name = json['name'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['name'] = this.name;
    data['type'] = this.type;
    return data;
  }
}

class Event {
  String? uuid;
  String? title;

  Event({this.uuid, this.title});

  Event.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['title'] = this.title;
    return data;
  }
}

class LikedBy {
  String? uuid;
  String? email;

  LikedBy({this.uuid, this.email});

  LikedBy.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['email'] = this.email;
    return data;
  }
}