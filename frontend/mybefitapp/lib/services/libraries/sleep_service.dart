import 'dart:convert';
import 'package:mybefitapp/model/sleep_model.dart';
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

  String getQuality(int hours) {
    if (hours <= 3) {
      return "Bad";
    } else if (hours > 3 && hours <= 6) {
      return "Average";
    } else if (hours > 6 && hours <= 9) {
      return "Good";
    } else if (hours > 9) {
      return "Over Sleep";
    } else {
      return "Can't measure quality.";
    }
  }

  Duration getDurationBetween(DateTime dateTime1, DateTime dateTime2) {
    DateTime startDateTime = dateTime1;
    DateTime endDateTime = dateTime2;

    // Swap the start and end DateTime if necessary
    if (startDateTime.isAfter(endDateTime)) {
      DateTime temp = startDateTime;
      startDateTime = endDateTime;
      endDateTime = temp;
    }

    Duration duration = endDateTime.difference(startDateTime);
    return duration;
  }
}
