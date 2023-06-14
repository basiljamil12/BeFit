import 'dart:convert';

import 'package:mybefitapp/model/body_model.dart';
import 'package:mybefitapp/services/Api/body_api_call.dart';

class BodyClient {
  BodyModel createBody(int height, int weight, String email) {
    return BodyModel(height: height, weight: weight, email: email);
  }

  Future<dynamic> checkAndGetBody(
    String email,
  ) async {
    var bodyData = await BaseBodyClient().getBodyApi(email);
    if (bodyData != null) {
      // Check if total_results is greater than 1
      var jsonData = jsonDecode(bodyData);
      var totalResults = jsonData['total_results'];
      if (totalResults >= 1) {
        // Return the existing data
        return bodyData;
      }
    } else {
      return '';
    }
  }

  double forBmi(int height, int weight) {
    double meterHeight = height / 100;
    double squaredHeight = meterHeight * meterHeight;
    double bmiBad = weight / squaredHeight;
    double bmi = double.parse((bmiBad).toStringAsFixed(2));

    return bmi;
  }
}
