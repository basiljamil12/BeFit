import 'dart:convert';

StepModel stepModelFromJson(String str) => StepModel.fromJson(json.decode(str));
StepModel stepModelAllFromJson(String str) =>
    StepModel.fromJson(json.decode(str));
String stepModelToJson(StepModel data) => json.encode(data.toJson());

class StepModel {
  String? id;
  String steps;
  DateTime date;
  String email;
  StepModel({
    this.id,
    required this.steps,
    required this.date,
    required this.email,
  });

  factory StepModel.fromJson(Map<String, dynamic> json) {
    var stepList = json['steps'] as List<dynamic>;
    var forSteps = stepList.first;

    return StepModel(
        id: forSteps["_id"],
        steps: forSteps["steps"].toString(),
        date: DateTime.parse(forSteps["date"]),
        email: forSteps["email"]);
  }

  factory StepModel.fromAllJson(Map<String, dynamic> json) {
    return StepModel(
        id: json["_id"],
        steps: json["steps"].toString(),
        date: DateTime.parse(json["date"]),
        email: json["email"]);
  }

  Map<String, dynamic> toJson() => {
        "steps": steps.toString(),
        "date": date.toUtc().toString(),
        "email": email,
      };
}
