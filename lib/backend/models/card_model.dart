class CardsModel {
  bool? success;
  String? message;
  int? count;
  String? next;
  Null? previous;
  List<CardDataList>? data;

  CardsModel({this.success, this.message, this.count, this.next, this.previous, this.data});

  CardsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['data'] != null) {
      data = <CardDataList>[];
      json['data'].forEach((v) { data!.add(new CardDataList.fromJson(v)); });
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

class CardDataList {
  String? uuid;
  String? name;
  String? cardToken;
  bool? dfault;

  CardDataList({this.uuid, this.name, this.cardToken, this.dfault});

  CardDataList.fromJson(Map<String, dynamic> json) {
uuid = json['uuid'];
name = json['name'];
cardToken = json['card_token'];
dfault = json['default'];
}

Map<String, dynamic> toJson() {
final Map<String, dynamic> data = new Map<String, dynamic>();
data['uuid'] = this.uuid;
data['name'] = this.name;
data['card_token'] = this.cardToken;
data['default'] = this.dfault;
return data;
}
}