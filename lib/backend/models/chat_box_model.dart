
class ChatBoxModel {
  bool? success;
  String? message;
  int? count;
  String? next;
  String? previous;
  List<ChatBoxModelData>? data;

  ChatBoxModel(
      {this.success,
        this.message,
        this.count,
        this.next,
        this.previous,
        this.data});

  ChatBoxModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['data'] != null) {
      data = <ChatBoxModelData>[];
      json['data'].forEach((v) {
        data!.add(new ChatBoxModelData.fromJson(v));
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

class ChatBoxModelData {
  int? id;
  String? message;
  MessageSender? messageSender;
  Room? room;
  String? attachment;
  String? createdAt;
  String? updatedAt;
  String? created_at_utc;

  ChatBoxModelData(
      {this.id,
        this.message,
        this.messageSender,
        this.room,
        this.attachment,
        this.createdAt,
        this.updatedAt,
        this.created_at_utc});

  ChatBoxModelData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    messageSender = json['message_sender'] != null
        ? new MessageSender.fromJson(json['message_sender'])
        : null;
    room = json['room'] != null ? new Room.fromJson(json['room']) : null;
    attachment = json['attachment'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    created_at_utc = json['created_at_utc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['message'] = this.message;
    if (this.messageSender != null) {
      data['message_sender'] = this.messageSender!.toJson();
    }
    if (this.room != null) {
      data['room'] = this.room!.toJson();
    }
    data['attachment'] = this.attachment;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class MessageSender {
  String? uuid;
  String? firstName;
  String? lastName;
  String? profilePicture;

  MessageSender(
      {this.uuid, this.firstName, this.lastName, this.profilePicture});

  MessageSender.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    profilePicture = json['profile_picture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['profile_picture'] = this.profilePicture;
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