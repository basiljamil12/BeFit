import 'dart:convert';

import 'package:mybefitapp/model/body_model.dart';
import 'package:mybefitapp/model/sleep_model.dart';
import 'package:mybefitapp/services/Api/body_api_call.dart';
import 'package:mybefitapp/services/Api/sleep_api_call.dart';

class SleepClient {
  SleepModel createBody(DateTime starttime, DateTime endtime, String email) {
    return SleepModel(starttime: starttime, endtime: endtime, email: email);
  }

  Future<dynamic> checkAndGetSleep(
    String email,
  ) async {
    var sleepData = await BaseSleepClient().getSleepApi(email);
    if (sleepData != null) {
      // Check if total_results is greater than 1
      var jsonData = jsonDecode(sleepData);
      var totalResults = jsonData['total_results'];
      if (totalResults >= 1) {
        // Return the existing data
        return sleepData;
      }
    } else {
      return '';
    }
  }
}
