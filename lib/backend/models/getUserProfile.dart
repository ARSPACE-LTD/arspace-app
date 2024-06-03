import 'InterestsModel.dart';

class GetProfileResponse {
  bool? success;
  String? message;
  Data? data;

  GetProfileResponse({this.success, this.message, this.data});

  GetProfileResponse.fromJson(Map<String, dynamic> json) {
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
  List<InterestsModel>? interests;
  List<Images>? images;
  Null? room;

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
      interests = <InterestsModel>[];
      json['interests'].forEach((v) {
        interests!.add(new InterestsModel.fromJson(v));
      });
    }
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(new Images.fromJson(v));
      });
    }
    room = json['room'];
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
    data['room'] = this.room;
    return data;
  }
}

/*class Interests {
  String? uuid;
  String? interest;

  Interests({this.uuid, this.interest});

  Interests.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    interest = json['interest'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['interest'] = this.interest;
    return data;
  }
}*/

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