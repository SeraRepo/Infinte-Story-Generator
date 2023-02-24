import 'package:esp_app/models/signin_form_model.dart';
import 'package:esp_app/models/signup_form_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:esp_app/models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final String host = dotenv.env['API_URL']!;
  late String token;
  late Object tokenUser;
  final User unknownUser = User(
      username: "unknown",
      password: "unknown",
      email: "unknown",
      stories: [],
      token: "unknown",
      id: 0);

  Future<dynamic> signup(SignupForm signupForm) async {
    try {
      http.Response response = await http.post(Uri.parse('$host/signup'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(signupForm.toJson()));
      if (response.statusCode != 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getUser(token) async {
    try {
      http.Response responseData =
          await http.get(Uri.parse('$host/user'), headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-access-token': token,
      });
      final Map<String, dynamic> bodyUser = json.decode(responseData.body);
      final User user = User.fromJson(bodyUser['User']);
      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> signin(SigninForm signinForm) async {
    try {
      http.Response response = await http.post(Uri.parse('$host/signin'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(signinForm.toJson()));

      final Map<String, dynamic> body = json.decode(response.body);

      if (response.statusCode == 200 && body.containsKey('token')) {
        token = body['token'];
        return getUser(token);
      } else {
        return unknownUser;
      }
    } catch (e) {
      rethrow;
    }
  }
}
