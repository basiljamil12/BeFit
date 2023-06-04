import 'dart:convert';
import 'package:mybefitapp/utilities/constants.dart';

import 'package:http/http.dart' as http;

import '../../model/step_model.dart';

Map<String, dynamic> constants = Constants.getConstant();
String baseURL = constants['url'];

class BaseStepClient {
  var client = http.Client();

  Future<dynamic> getStepApi(String api) async {
    var uri = Uri.parse('$baseURL/steps?id=$api');
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      //TODO throw exception
    }
  }

  Future<dynamic> postStepApi(dynamic object) async {
    var uri = Uri.parse('$baseURL/steps');
    var payload = stepModelToJson(object);
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

  Future<dynamic> putStepApi(dynamic object, String api) async {
    var uri = Uri.parse('$baseURL/steps?id=$api');
    var payload = stepModelToJson(object);
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
