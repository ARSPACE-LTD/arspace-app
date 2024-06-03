class ChatListModel {
  bool? success;
  String? message;
  int? count;
  String? next;
  String? previous;
  List<Data>? data;

  ChatListModel(
      {this.success,
        this.message,
        this.count,
        this.next,
        this.previous,
        this.data});

  ChatListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

class Data {
  String? uuid;
  String? name;
  Event? event;
  String? type;
  RoomSender? roomSender;
  RoomSender? roomReceiver;
  LatestMessage? latestMessage;
  int? latest_messages_count;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.uuid,
        this.name,
        this.event,
        this.type,
        this.roomSender,
        this.roomReceiver,
        this.latestMessage,
        this.latest_messages_count,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    name = json['name'];
    event = json['event'] != null ? new Event.fromJson(json['event']) : null;
    type = json['type'];
    roomSender = json['room_sender'] != null
        ? new RoomSender.fromJson(json['room_sender'])
        : null;
    roomReceiver = json['room_receiver'] != null
        ? new RoomSender.fromJson(json['room_receiver'])
        : null;
    latestMessage = json['latest_message'] != null
        ? new LatestMessage.fromJson(json['latest_message'])
        : null;
    latest_messages_count = json['latest_messages_count'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['name'] = this.name;
    if (this.event != null) {
      data['event'] = this.event!.toJson();
    }
    data['type'] = this.type;
    if (this.roomSender != null) {
      data['room_sender'] = this.roomSender!.toJson();
    }
    if (this.roomReceiver != null) {
      data['room_receiver'] = this.roomReceiver!.toJson();
    }
    if (this.latestMessage != null) {
      data['latest_message'] = this.latestMessage!.toJson();
    }
    data['latest_messages_count'] = this.latest_messages_count;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Event {
  String? uuid;
  String? title;
  List<Images>? images;

  Event({this.uuid, this.title, this.images});

  Event.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    title = json['title'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(new Images.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['title'] = this.title;
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Images {
  String? uuid;
  String? image;

  Images({this.uuid, this.image});

  Images.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['image'] = this.image;
    return data;
  }
}

class RoomSender {
  String? uuid;
  String? full_name;
  String? firstName;
  String? lastName;
  String? email;
  String? profilePicture;

  RoomSender(
      {this.uuid,
        this.full_name,
        this.firstName,
        this.lastName,
        this.email,
        this.profilePicture});

  RoomSender.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    full_name  = json['full_name'];
    lastName = json['last_name'];
    email = json['email'];
    profilePicture = json['profile_picture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['full_name'] = this.full_name;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['profile_picture'] = this.profilePicture;
    return data;
  }
}

class LatestMessage {
  String? message;
  String? attachment;
  String? createdAt;
  String? sender;

  LatestMessage({this.message, this.attachment, this.createdAt});

  LatestMessage.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    attachment = json['attachment'];
    createdAt = json['created_at'];
    sender = json['sender'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['attachment'] = this.attachment;
    data['created_at'] = this.createdAt;
    data['sender'] = this.sender;
    return data;
  }
}