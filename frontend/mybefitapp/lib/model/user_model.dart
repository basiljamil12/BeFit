// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  String? id;
  String? username;
  String? password;
  String? name;
  String? gender;
  DateTime? dob;
  String? email;

  UserModel({
    this.id,
    this.username,
    this.password,
    this.name,
    this.gender,
    this.dob,
    this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    var users = json['users'] as List<dynamic>;
    var user = users.first;

    return UserModel(
      id: user['_id'] as String?,
      username: user['username'] as String?,
      password: user['password'] as String?,
      name: user['name'] as String?,
      gender: user['gender'] as String?,
      dob: DateTime.parse(user['dob'] as String? ?? ''),
      email: user['email'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'password': password,
      'name': name,
      'gender': gender,
      'dob': dob?.millisecondsSinceEpoch,
      'email': email,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      username: map['username'] != null ? map['username'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      gender: map['gender'] != null ? map['gender'] as String : null,
      dob: map['dob'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['dob'] as int)
          : null,
      email: map['email'] != null ? map['email'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'UserModel(username: $username, password: $password, name: $name, gender: $gender, dob: $dob, email: $email)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.username == username &&
        other.password == password &&
        other.name == name &&
        other.gender == gender &&
        other.dob == dob &&
        other.email == email;
  }

  @override
  int get hashCode {
    return username.hashCode ^
        password.hashCode ^
        name.hashCode ^
        gender.hashCode ^
        dob.hashCode ^
        email.hashCode;
  }
}
