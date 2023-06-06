// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String? id;
  String password;
  String name;
  String gender;
  DateTime dob;
  String email;

  UserModel({
    this.id,
    required this.password,
    required this.name,
    required this.gender,
    required this.dob,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    var users = json['users'] as List<dynamic>;
    var user = users.first;

    return UserModel(
      id: user["_id"],
      password: user["password"],
      name: user["name"],
      gender: user["gender"],
      dob: DateTime.parse(user["dob"]),
      email: user["email"],
    );
  }
  Map<String, dynamic> toJson() => {
        "password": password,
        "name": name,
        "gender": gender,
        "dob": dob.toUtc().toString(),
        "email": email,
      };
}
