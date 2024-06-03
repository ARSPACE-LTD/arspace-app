class TicketsModel {
  bool? success;
  String? message;
  int? count;
  String? next;
  Null? previous;
  List<Data>? data;

  TicketsModel(
      {this.success,
        this.message,
        this.count,
        this.next,
        this.previous,
        this.data});

  TicketsModel.fromJson(Map<String, dynamic> json) {
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
  Order? order;
  Ticket? ticket;
  double? price;
  String? createdAt;
  String? updatedAt;
  String? status;
  Event? event;

  Data(
      {this.uuid,
        this.order,
        this.ticket,
        this.price,
        this.createdAt,
        this.updatedAt,
        this.status,
        this.event});

  Data.fromJson(Map<String, dynamic> json) {
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
  String? type;

  Order({this.uuid, this.qty, this.total, this.status, this.type});

  Order.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    qty = json['qty'];
    total = json['total'];
    status = json['status'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['qty'] = this.qty;
    data['total'] = this.total;
    data['status'] = this.status;
    data['type'] = this.type;
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

class Event {
  String? uuid;
  String? name;
  String? date;
  String? time;
  String? location;
  String? created_at_utc;
  List<Images>? images;

  Event(
      {this.uuid, this.name, this.date, this.time, this.location, this.created_at_utc,  this.images});

  Event.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    name = json['name'];
    date = json['date'];
    time = json['time'];
    location = json['location'];
    created_at_utc = json['created_at_utc'];
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
    data['name'] = this.name;
    data['date'] = this.date;
    data['time'] = this.time;
    data['location'] = this.location;
    data['created_at_utc'] = this.created_at_utc;
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