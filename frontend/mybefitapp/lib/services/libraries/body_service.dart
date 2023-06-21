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
  String classifyBMI(double bmi) {
  if (bmi < 16) {
    return 'Severe Thinness';
  } else if (bmi >= 16 && bmi < 17) {
    return 'Moderate Thinness';
  } else if (bmi >= 17 && bmi < 18.5) {
    return 'Mild Thinness';
  } else if (bmi >= 18.5 && bmi < 25) {
    return 'Normal';
  } else if (bmi >= 25 && bmi < 30) {
    return 'Overweight';
  } else if (bmi >= 30 && bmi < 35) {
    return 'Obese Class I';
  } else if (bmi >= 35 && bmi < 40) {
    return 'Obese Class II';
  } else {
    return 'Obese Class III';
  }
}
String getHealthSuggestion(double bmi) {
  if (bmi < 16) {
    return 'You are in the Severe Thinness category. It is important to consult a healthcare professional for proper evaluation and guidance.';
  } else if (bmi >= 16 && bmi < 17) {
    return 'You are in the Moderate Thinness category. It is recommended to focus on improving your nutrition and consider seeking guidance from a healthcare professional.';
  } else if (bmi >= 17 && bmi < 18.5) {
    return 'You are in the Mild Thinness category. It is advisable to focus on a balanced diet and consider consulting a healthcare professional for guidance.';
  } else if (bmi >= 18.5 && bmi < 25) {
    return 'You are in the Normal category. Keep up the good work with maintaining a healthy lifestyle and regular exercise.';
  } else if (bmi >= 25 && bmi < 30) {
    return 'You are in the Overweight category. It is recommended to focus on healthy eating habits, regular exercise, and consult a healthcare professional for personalized advice.';
  } else if (bmi >= 30 && bmi < 35) {
    return 'You are in Obese Class I category. It is important to focus on a well-balanced diet, regular physical activity, and consult a healthcare professional for guidance.';
  } else if (bmi >= 35 && bmi < 40) {
    return 'You are in Obese Class II category. It is advisable to consult a healthcare professional for proper evaluation, guidance, and support.';
  } else {
    return 'You are in Obese Class III category. It is crucial to consult a healthcare professional for comprehensive evaluation, guidance, and support.';
  }
}


}
