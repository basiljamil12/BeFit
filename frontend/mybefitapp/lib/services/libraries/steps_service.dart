import 'package:mybefitapp/model/step_model.dart';
import 'package:mybefitapp/services/Api/step_api_call.dart';

class StepsClient {
  StepModel createSteps(DateTime date, String email, String steps) {
    return StepModel(steps: steps, date: date, email: email);
  }

  // Future<dynamic> stepCheck(DateTime date, String email, String steps) async {
  //   Future<dynamic> stepData =
  //       await BaseStepClient().getStepApi(email, date.toUtc().toString());
  //   return stepData.then((response) async {
  //     StepModel stepsData = stepModelFromJson(response);

  //     if (stepsData != null) {
  //       // Use the `stepsData` object as needed
  //       // ...
  //       return stepsData;
  //     } else {
  //       StepModel postSteps = createSteps(date, email, steps);
  //       await BaseStepClient().postStepApi(postSteps).catchError((e) {});
  //       stepData =
  //           await BaseStepClient().getStepApi(email, date.toUtc().toString());
  //       return stepData;
  //     }
  //   }).catchError((error) {
  //     print('Error: $error');
  //   });
  // }

  Future<dynamic> getDataFromApiOrPostNew(
    String email,
    String steps,
    DateTime date,
  ) async {
    var stepData =
        await BaseStepClient().getStepApi(email, date.toUtc().toString());

    if (stepData == null) {
      // If the API response is null, post new data
      StepModel newData = createSteps(date, email, steps);
      var response = await BaseStepClient().postStepApi(newData);
      return response;
    } else {
      // If the API response is not null, return the existing data
      return stepData;
    }
  }
}
