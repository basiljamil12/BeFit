import 'dart:convert';

List<UserModel> todoFromJson(String str) =>
    List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

String todoToJson(List<UserModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserModel {
  String? id;
  String username;
  String password;
  String name;
  String gender;
  String dob;
  String email;

  UserModel(
      {this.id,
      required this.username,
      required this.password,
      required this.name,
      required this.gender,
      required this.dob,
      required this.email});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["_id"],
        username: json["username"],
        password: json["password"],
        name: json["name"],
        gender: json["gender"],
        dob: json["dob"], //DateTime.parse(json["dob"]),
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
        "name": name,
        "gender": gender,
        "dob": dob, //dob.toUtc().toString(),
        "email": email
      };
}
