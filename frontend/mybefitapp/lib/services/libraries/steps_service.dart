import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:mybefitapp/model/step_model.dart';
import 'package:mybefitapp/services/Api/step_api_call.dart';

class StepsClient {
  StepModel createSteps(DateTime date, String email, String steps) {
    return StepModel(steps: steps, date: date, email: email);
  }

  Future<dynamic> getDataFromApiOrPostNew(
    String email,
    String steps,
    DateTime date,
  ) async {
    String utcString = date.toString();
    var stepData = await BaseStepClient().getStepApi(email, utcString);
    if (stepData != null) {
      // Check if total_results is greater than 1
      var jsonData = jsonDecode(stepData);
      var totalResults = jsonData['total_steps'];
      if (totalResults >= 1) {
        // Return the existing data
        return stepData;
      }
    }

    // If total_results is not greater than 1 or the API response is null, post new data
    StepModel newData = createSteps(date, email, steps);
    var response = await BaseStepClient().postStepApi(newData);
    if (response != null) {
      var stepData = await BaseStepClient().getStepApi(email, utcString);
      if (stepData != null) {
        // Check if total_results is greater than 1
        var jsonData = jsonDecode(stepData);
        var totalResults = jsonData['total_steps'];
        if (totalResults >= 1) {
          // Return the existing data
          return stepData;
        }
      }
    }
    return response;
  }

  Future<dynamic> getAllStepData(String email) async {
    var stepData = await BaseStepClient().getAllStepApi(email);
    if (stepData != null) {
      // Check if total_results is greater than 1
      var jsonData = jsonDecode(stepData);
      var totalResults = jsonData['total_steps'];
      if (totalResults >= 1) {
        // Return the existing data
        return stepData;
      }
    } else {
      return '';
    }
  }

  void updateSteps(
    String email,
    DateTime date,
    int trackedSteps,
  ) async {
    String utcString = date.toString();
    int steps = 0;
    String id = '';

    var stepData = await BaseStepClient().getStepApi(email, utcString);

    if (stepData != null) {
      var jsonData = jsonDecode(stepData);
      var stepsList = jsonData['steps'];

      if (stepsList != null) {
        steps = stepsList[0]['steps'];
        id = stepsList[0]['_id'];
      }
    }

    steps += trackedSteps;
    StepModel newData = createSteps(date, email, steps.toString());
    await BaseStepClient().putStepApi(newData, id);
  }

  List<dynamic> parseJsonToList(String jsonString) {
    dynamic jsonData = json.decode(jsonString);
    List<dynamic> jsonList = jsonData['steps'];
    return jsonList;
  }

  double calculateAverageSteps(List<dynamic> filteredList) {
    int totalSteps = 0;
    int numberOfSteps = filteredList.length;

    for (dynamic step in filteredList) {
      int steps = step['steps'];
      totalSteps += steps;
    }

    double averageSteps = totalSteps / numberOfSteps;
    return averageSteps;
  }

  List<dynamic> filterStepsByMonth(
      List<dynamic> stepList, int month, int year) {
    List<dynamic> filteredList = [];

    for (dynamic step in stepList) {
      DateTime stepDate = DateFormat('yyyy-MM-dd').parse(step['date']);

      if (stepDate.month == month && stepDate.year == year) {
        filteredList.add(step);
      }
    }

    return filteredList;
  }

  List<dynamic> filterStepsList(List<dynamic> stepList) {
    List<dynamic> filteredList = [];
    DateTime currentDate = DateTime.now();

    for (dynamic step in stepList) {
      DateTime stepDate = DateFormat('yyyy-MM-dd').parse(step['date']);

      if (stepDate.isAfter(currentDate.subtract(const Duration(days: 7))) &&
          stepDate.isBefore(currentDate)) {
        filteredList.add(step);
      }
    }

    return filteredList;
  }

  List<dynamic> filterStepsByYear(List<dynamic> stepList, int year) {
    List<dynamic> filteredList = [];

    for (dynamic step in stepList) {
      DateTime stepDate = DateFormat('yyyy-MM-dd').parse(step['date']);

      if (stepDate.year == year) {
        filteredList.add(step);
      }
    }

    return filteredList;
  }
}
