class Cards {
  String? uuid;
  String? name;
  String? cardToken;
  bool? dfault;

  Cards({this.uuid, this.name, this.cardToken, this.dfault});

Cards.fromJson(Map<String, dynamic> json) {
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