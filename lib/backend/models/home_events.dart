class HomeEvents {
  bool? success;
  String? message;
  int? count;
  Null? next;
  Null? previous;
  List<Data>? data;

  HomeEvents(
      {this.success,
        this.message,
        this.count,
        this.next,
        this.previous,
        this.data});

  HomeEvents.fromJson(Map<String, dynamic> json) {
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
  Club? club;
  String? title;
  String? description;
  String? date;
  String? time;
  String? latitude;
  String? longitude;
  String? createdAt;
  String? created_at_utc;
  List<Images>? images;
  List<Casts>? casts;
  List<Tickets>? tickets;
  List<InterestedUsers>? interestedUsers;

  Data(
      {this.uuid,
        this.club,
        this.title,
        this.description,
        this.date,
        this.time,
        this.latitude,
        this.longitude,
        this.createdAt,
        this.created_at_utc,
        this.images,
        this.casts,
        this.tickets,
        this.interestedUsers});

  Data.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    club = json['club'] != null ? new Club.fromJson(json['club']) : null;
    title = json['title'];
    description = json['description'];
    date = json['date'];
    time = json['time'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    createdAt = json['created_at'];
    created_at_utc = json['created_at_utc'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(new Images.fromJson(v));
      });
    }
    if (json['casts'] != null) {
      casts = <Casts>[];
      json['casts'].forEach((v) {
        casts!.add(new Casts.fromJson(v));
      });
    }
    if (json['tickets'] != null) {
      tickets = <Tickets>[];
      json['tickets'].forEach((v) {
        tickets!.add(new Tickets.fromJson(v));
      });
    }
    if (json['interested_users'] != null) {
      interestedUsers = <InterestedUsers>[];
      json['interested_users'].forEach((v) {
        interestedUsers!.add(new InterestedUsers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    if (this.club != null) {
      data['club'] = this.club!.toJson();
    }
    data['title'] = this.title;
    data['description'] = this.description;
    data['date'] = this.date;
    data['time'] = this.time;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['created_at'] = this.createdAt;
    data['created_at_utc'] = this.created_at_utc;
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    if (this.casts != null) {
      data['casts'] = this.casts!.map((v) => v.toJson()).toList();
    }
    if (this.tickets != null) {
      data['tickets'] = this.tickets!.map((v) => v.toJson()).toList();
    }
    if (this.interestedUsers != null) {
      data['interested_users'] =
          this.interestedUsers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class Club {
  String? uuid;
  String? title;
  String? contactNo;

  Club({this.uuid, this.title, this.contactNo});

  Club.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    title = json['title'];
    contactNo = json['contact_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['title'] = this.title;
    data['contact_no'] = this.contactNo;
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

class Casts {
  String? uuid;
  String? cast;
  String? image;

  Casts({this.uuid, this.cast, this.image});

  Casts.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    cast = json['cast'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['cast'] = this.cast;
    data['image'] = this.image;
    return data;
  }
}

class Tickets {
  String? uuid;
  String? name;
  double? price;
  String? currency;

  Tickets({this.uuid, this.name, this.price, this.currency});

  Tickets.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    name = json['name'];
    price = json['price'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['name'] = this.name;
    data['price'] = this.price;
    data['currency'] = this.currency;
    return data;
  }
}

class InterestedUsers {
  String? profilePicture;

  InterestedUsers({this.profilePicture});

  InterestedUsers.fromJson(Map<String, dynamic> json) {
    profilePicture = json['profile_picture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profile_picture'] = this.profilePicture;
    return data;
  }
}