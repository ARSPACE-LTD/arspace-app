class OrderResponse {
  bool? success;
  String? message;
  Data? data;

  OrderResponse({this.success, this.message, this.data});

  OrderResponse.fromJson(Map<String, dynamic> json) {
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
  Event? event;
  int? qty;
  String? paymentStatus;
  List<OrderItems>? orderItems;
  List<OtherPaidUsers>? otherPaidUsers;
  String? createdAt;
  String? updatedAt;
  double? total;

  Data(
      {this.uuid,
        this.event,
        this.qty,
        this.paymentStatus,
        this.orderItems,
        this.otherPaidUsers,
        this.createdAt,
        this.updatedAt,
        this.total});

  Data.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    event = json['event'] != null ? new Event.fromJson(json['event']) : null;
    qty = json['qty'];
    paymentStatus = json['payment_status'];
    if (json['order_items'] != null) {
      orderItems = <OrderItems>[];
      json['order_items'].forEach((v) {
        orderItems!.add(new OrderItems.fromJson(v));
      });
    }
    if (json['other_paid_users'] != null) {
      otherPaidUsers = <OtherPaidUsers>[];
      json['other_paid_users'].forEach((v) {
        otherPaidUsers!.add(new OtherPaidUsers.fromJson(v));
      });
    }
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    if (this.event != null) {
      data['event'] = this.event!.toJson();
    }
    data['qty'] = this.qty;
    data['payment_status'] = this.paymentStatus;
    if (this.orderItems != null) {
      data['order_items'] = this.orderItems!.map((v) => v.toJson()).toList();
    }
    if (this.otherPaidUsers != null) {
      data['other_paid_users'] =
          this.otherPaidUsers!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['total'] = this.total;
    return data;
  }
}

class Event {
  String? uuid;
  String? title;
  String? date;
  String? time;
  String? clubContactNo;
  String? latitude;
  String? longitude;
  String? location;
  List<Images>? images;
  Room? room;

  Event(
      {this.uuid,
        this.title,
        this.date,
        this.time,
        this.clubContactNo,
        this.latitude,
        this.longitude,
        this.location,
        this.images,
        this.room});

  Event.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    title = json['title'];
    date = json['date'];
    time = json['time'];
    clubContactNo = json['club_contact_no'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    location = json['location'];
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
    data['title'] = this.title;
    data['date'] = this.date;
    data['time'] = this.time;
    data['club_contact_no'] = this.clubContactNo;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['location'] = this.location;
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    if (this.room != null) {
      data['room'] = this.room!.toJson();
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

class Room {
  String? uuid;
  String? name;
  Event? event;
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
    event = json['event'] != null ? new Event.fromJson(json['event']) : null;
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


class OrderItems {
  String? uuid;
  Order? order;
  Ticket? ticket;
  double? price;
  String? createdAt;
  String? updatedAt;
  String? status;
  Event? event;

  OrderItems(
      {this.uuid,
        this.order,
        this.ticket,
        this.price,
        this.createdAt,
        this.updatedAt,
        this.status,
        this.event});

  OrderItems.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    order = json['order'] != null ? new Order.fromJson(json['order']) : null;
    ticket =
    json['ticket'] != null ? new Ticket.fromJson(json['ticket']) : null;
    price = json['price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
    event = json['event'] != null ? new Event.fromJson(json['event']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    if (this.order != null) {
      data['order'] = this.order!.toJson();
    }
    if (this.ticket != null) {
      data['ticket'] = this.ticket!.toJson();
    }
    data['price'] = this.price;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['status'] = this.status;
    if (this.event != null) {
      data['event'] = this.event!.toJson();
    }
    return data;
  }
}

class Order {
  String? uuid;
  int? qty;
  double? total;
  String? status;

  Order({this.uuid, this.qty, this.total, this.status});

  Order.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    qty = json['qty'];
    total = json['total'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['qty'] = this.qty;
    data['total'] = this.total;
    data['status'] = this.status;
    return data;
  }
}

class Ticket {
  String? uuid;
  String? name;

  Ticket({this.uuid, this.name});

  Ticket.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['name'] = this.name;
    return data;
  }
}



class OtherPaidUsers {
  String? uuid;
  String? fullName;
  String? profilePicture;

  OtherPaidUsers({this.uuid, this.fullName, this.profilePicture});

  OtherPaidUsers.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    fullName = json['full_name'];
    profilePicture = json['profile_picture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['full_name'] = this.fullName;
    data['profile_picture'] = this.profilePicture;
    return data;
  }
}