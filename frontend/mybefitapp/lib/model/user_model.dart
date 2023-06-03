// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String? id;
  String username;
  String password;
  String name;
  String gender;
  DateTime dob;
  String email;

  UserModel({
    this.id,
    required this.username,
    required this.password,
    required this.name,
    required this.gender,
    required this.dob,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["_id"],
        username: json["username"],
        password: json["password"],
        name: json["name"],
        gender: json["gender"],
        dob: DateTime.parse(json["dob"]),
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
        "name": name,
        "gender": gender,
        "dob": dob.toUtc().toString(),
        "email": email,
      };
}
