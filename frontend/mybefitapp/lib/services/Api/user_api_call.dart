import 'dart:convert';
import 'package:mybefitapp/model/user_model.dart';
import 'package:mybefitapp/utilities/constants.dart';

import 'package:http/http.dart' as http;

Map<String, dynamic> constants = Constants.getConstant();
String baseURL = constants['url'];

class BaseUserClient {
  var client = http.Client();

  //user data

  Future<dynamic> getUserApi(String api) async {
    var uri = Uri.parse('$baseURL/userprofile?id=$api');
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      //TODO throw exception
    }
  }

  Future<dynamic> postUserApi(dynamic object) async {
    var uri = Uri.parse('$baseURL/userprofile');
    var payload = userModelToJson(object);
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

  Future<dynamic> putUserApi(dynamic object, String api) async {
    var uri = Uri.parse('$baseURL/userprofile?id=$api');
    var payload = userModelToJson(object);
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

  Future<dynamic> deleteUserApi(String api) async {
    var uri = Uri.parse('$baseURL/userprofile?id=$api');
    var response = await client.delete(uri);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    } else {
      //TODO throw exception
    }
  }
}
