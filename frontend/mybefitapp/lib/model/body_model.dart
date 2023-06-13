import 'dart:convert';

BodyModel bodyModelFromJson(String str) => BodyModel.fromJson(json.decode(str));
String bodyModeltoJson(BodyModel data) => json.encode(data.toJson());

class BodyModel {
  String? id;
  int height;
  int weight;
  String email;
  BodyModel({
    this.id,
    required this.height,
    required this.weight,
    required this.email,
  });

  factory BodyModel.fromJson(Map<String, dynamic> json) {
    var bodyList = json['Measurements'] as List<dynamic>;
    var forBody = bodyList.first;

    return BodyModel(
        id: forBody["_id"],
        height: forBody["height"],
        weight: forBody["weight"],
        email: forBody["email"]);
  }

  Map<String, dynamic> toJson() => {
        "height": height.toString(),
        "weight": weight.toString(),
        "email": email,
      };
}
