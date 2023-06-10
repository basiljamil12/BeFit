import 'dart:convert';
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
      var totalResults = jsonData['total_results'];
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
        var totalResults = jsonData['total_results'];
        if (totalResults >= 1) {
          // Return the existing data
          return stepData;
        }
      }
    }
    return response;
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
}
