import 'package:mybefitapp/model/body_model.dart';
import 'package:mybefitapp/utilities/constants.dart';
import 'package:http/http.dart' as http;

Map<String, dynamic> constants = Constants.getConstant();
String baseURL = constants['url'];

class BaseBodyClient {
  var client = http.Client();

  Future<dynamic> getBodyApi(String forID) async {
    var uri = Uri.parse('$baseURL/measurements?id=$forID');
    var response = await client.get(uri);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      //TODO throw exception
    }
  }

  Future<dynamic> postBodyApi(dynamic object) async {
    var uri = Uri.parse('$baseURL/measurements');
    var payload = bodyModeltoJson(object);
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

  Future<dynamic> putBodyApi(dynamic object, String api) async {
    var uri = Uri.parse('$baseURL/measurements?id=$api');
    print(uri);
    var payload = bodyModeltoJson(object);
    print(payload);
    var headers = {
      'Content-Type': 'application/json',
    };
    var response = await client.put(uri, body: payload, headers: headers);
    print(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    } else {
      //TODO throw exception
    }
  }
}
