class CreateCardResponse {
  bool? success;
  String? message;
  Data? data;

  CreateCardResponse({this.success, this.message, this.data});

  CreateCardResponse.fromJson(Map<String, dynamic> json) {
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
  String? name;
  String? cardToken;
  bool? dfault;

  Data({this.uuid, this.name, this.cardToken, this.dfault});

Data.fromJson(Map<String, dynamic> json) {
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