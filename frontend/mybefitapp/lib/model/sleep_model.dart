import 'dart:convert';

SleepModel sleepModelFromJson(String str) =>
    SleepModel.fromJson(json.decode(str));

String sleepModelToJson(SleepModel data) => json.encode(data.toJson());

class SleepModel {
  String? id;
  DateTime starttime;
  DateTime endtime;
  String email;

  SleepModel({
    this.id,
    required this.starttime,
    required this.endtime,
    required this.email,
  });

  factory SleepModel.fromJson(Map<String, dynamic> json) {
    var sleeps = json['sleep'] as List<dynamic>;
    var sleep = sleeps.first;

    return SleepModel(
      id: sleep["_id"],
      starttime: DateTime.parse(sleep["starttime"]),
      endtime: DateTime.parse(sleep["endtime"]),
      email: sleep["email"],
    );
  }

  Map<String, dynamic> toJson() => {
        "starttime": starttime.toString(),
        "endtime": endtime.toString(),
        "email": email,
      };
}
