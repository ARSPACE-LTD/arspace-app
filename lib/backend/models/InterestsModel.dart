
class InterestsModel {
  String? uuid;
  String? title;

  InterestsModel({this.uuid, this.title});

  InterestsModel.fromJson(Map<String, dynamic> json) {
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