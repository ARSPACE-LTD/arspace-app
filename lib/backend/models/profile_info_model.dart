class ProfileInfoModel {
  bool? success;
  String? message;
  Data? data;

  ProfileInfoModel({this.success, this.message, this.data});

  ProfileInfoModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? uuid;
  String? email;
  String? fullName;
  String? dob;
  String? gender;
  String? intro;
  String? profilePicture;
  String? phone;
  String? location;
  String? latitude;
  String? longitude;
  bool? emailVerified;
  bool? isActive;
  bool? isProfileSetup;
  String? deviceToken;
  String? lastSeen;
  List<Interests>? interests;
  List<Images>? images;
  Room? room;

  Data(
      {this.uuid,
        this.email,
        this.fullName,
        this.dob,
        this.gender,
        this.intro,
        this.profilePicture,
        this.phone,
        this.location,
        this.latitude,
        this.longitude,
        this.emailVerified,
        this.isActive,
        this.isProfileSetup,
        this.deviceToken,
        this.lastSeen,
        this.interests,
        this.images,
        this.room});

  Data.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    email = json['email'];
    fullName = json['full_name'];
    dob = json['dob'];
    gender = json['gender'];
    intro = json['intro'];
    profilePicture = json['profile_picture'];
    phone = json['phone'];
    location = json['location'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    emailVerified = json['email_verified'];
    isActive = json['is_active'];
    isProfileSetup = json['is_profile_setup'];
    deviceToken = json['device_token'];
    lastSeen = json['last_seen'];
    if (json['interests'] != null) {
      interests = <Interests>[];
      json['interests'].forEach((v) {
        interests!.add(new Interests.fromJson(v));
      });
    }
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(new Images.fromJson(v));
      });
    }
    room = json['room'] != null ? new Room.fromJson(json['room']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['email'] = this.email;
    data['full_name'] = this.fullName;
    data['dob'] = this.dob;
    data['gender'] = this.gender;
    data['intro'] = this.intro;
    data['profile_picture'] = this.profilePicture;
    data['phone'] = this.phone;
    data['location'] = this.location;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['email_verified'] = this.emailVerified;
    data['is_active'] = this.isActive;
    data['is_profile_setup'] = this.isProfileSetup;
    data['device_token'] = this.deviceToken;
    data['last_seen'] = this.lastSeen;
    if (this.interests != null) {
      data['interests'] = this.interests!.map((v) => v.toJson()).toList();
    }
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    if (this.room != null) {
      data['room'] = this.room!.toJson();
    }
    return data;
  }
}

class Interests {
  String? uuid;
  String? title;

  Interests({this.uuid, this.title});

  Interests.fromJson(Map<String, dynamic> json) {
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

class Room {
  String? uuid;
  String? name;
  String? event;
  String? type;
  RoomSender? roomSender;
  RoomReceiver? roomReceiver;
  LatestMessage? latestMessage;
  String? createdAt;
  String? updatedAt;

  Room(
      {this.uuid,
        this.name,
        this.event,
        this.type,
        this.roomSender,
        this.roomReceiver,
        this.latestMessage,
        this.createdAt,
        this.updatedAt});

  Room.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    name = json['name'];
    event = json['event'];
    type = json['type'];
    roomSender = json['room_sender'] != null
        ? new RoomSender.fromJson(json['room_sender'])
        : null;
    roomReceiver = json['room_receiver'] != null
        ? new RoomReceiver.fromJson(json['room_receiver'])
        : null;
    latestMessage = json['latest_message'] != null
        ? new LatestMessage.fromJson(json['latest_message'])
        : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['name'] = this.name;
    data['event'] = this.event;
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
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class RoomSender {
  String? uuid;
  String? firstName;
  String? lastName;
  String? email;
  String? profilePicture;

  RoomSender(
      {this.uuid,
        this.firstName,
        this.lastName,
        this.email,
        this.profilePicture});

  RoomSender.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    profilePicture = json['profile_picture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['profile_picture'] = this.profilePicture;
    return data;
  }
}

class RoomReceiver {
  String? uuid;
  String? firstName;
  String? lastName;
  String? email;
  String? profilePicture;

  RoomReceiver(
      {this.uuid,
        this.firstName,
        this.lastName,
        this.email,
        this.profilePicture});

  RoomReceiver.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    profilePicture = json['profile_picture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
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

  LatestMessage({this.message, this.attachment, this.createdAt});

  LatestMessage.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    attachment = json['attachment'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['attachment'] = this.attachment;
    data['created_at'] = this.createdAt;
    return data;
  }
}