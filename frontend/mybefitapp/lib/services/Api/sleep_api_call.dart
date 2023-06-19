import 'package:mybefitapp/model/sleep_model.dart';
import 'package:mybefitapp/utilities/constants.dart';
import 'package:http/http.dart' as http;

Map<String, dynamic> constants = Constants.getConstant();
String baseURL = constants['url'];

class BaseSleepClient {
  var client = http.Client();

  Future<dynamic> getSleepApi(String forID) async {
    var uri = Uri.parse('$baseURL/sleep?id=$forID');
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      //TODO throw exception
    }
  }

  Future<dynamic> postSleepApi(dynamic object) async {
    var uri = Uri.parse('$baseURL/sleep');
    var payload = sleepModelToJson(object);
    var headers = {
      'Content-Type': 'application/json',
    };
    var response = await client.post(uri, body: payload, headers: headers);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    } else {
      //TODO throw exception
    }
  }

  Future<dynamic> putSleepApi(dynamic object, String api) async {
    var uri = Uri.parse('$baseURL/sleep?id=$api');
    var payload = sleepModelToJson(object);
    var headers = {
      'Content-Type': 'application/json',
    };
    var response = await client.put(uri, body: payload, headers: headers);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    } else {
      //TODO throw exception
    }
  }
}
