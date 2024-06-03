class MatchModel {
  bool? success;
  String? message;
  int? count;
  String? next;
  String? previous;
  List<MatchData>? data;



  MatchModel(
      {this.success,
        this.message,
        this.count,
        this.next,
        this.previous,
        this.data,
        });

  MatchModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['data'] != null) {
      data = <MatchData>[];
      json['data'].forEach((v) {
        data!.add(new MatchData.fromJson(v));
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

class MatchData {
  String? uuid;
  String? email;
  String? fullName;
  String? profilePicture;
  String? dob;
  int? age;
  String? gender;
  List<Interests>? interests;
  bool? liked;
  Interests? event;


  MatchData(
      {this.uuid,
        this.email,
        this.fullName,
        this.profilePicture,
        this.dob,
        this.age,
        this.gender,
        this.interests,
        this.liked ,
        this.event
      });

  MatchData.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    email = json['email'];
    fullName = json['full_name'];
    profilePicture = json['profile_picture'];
    dob = json['dob'];
    age = json['age'];
    gender = json['gender'];
    if (json['interests'] != null) {
      interests = <Interests>[];
      json['interests'].forEach((v) {
        interests!.add(new Interests.fromJson(v));
      });
    }
    liked = json['liked'];
    event =
    json['event'] != null ? new Interests.fromJson(json['event']) : null;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['email'] = this.email;
    data['full_name'] = this.fullName;
    data['profile_picture'] = this.profilePicture;
    data['dob'] = this.dob;
    data['age'] = this.age;
    data['gender'] = this.gender;
    if (this.interests != null) {
      data['interests'] = this.interests!.map((v) => v.toJson()).toList();
    }
    data['liked'] = this.liked;
    if (this.event != null) {
      data['event'] = this.event!.toJson();
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