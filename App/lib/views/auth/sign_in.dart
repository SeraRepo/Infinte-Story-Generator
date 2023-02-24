import 'dart:ui';

import 'package:esp_app/providers/auth_provider.dart';
import 'package:esp_app/views/GPT/story_generator.dart';
import 'package:esp_app/views/home_view.dart';
import 'package:esp_app/views/my_stories_view.dart';
import 'package:esp_app/models/secure_storage_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/signin_form_model.dart';
import '../../models/user_model.dart';
import '../../providers/user_provider.dart';
import '../profile_view.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SigninView extends StatefulWidget {
  static String routeName = '/signin';
  const SigninView({Key? key}) : super(key: key);

  @override
  State<SigninView> createState() => _SigninViewState();
}

class _SigninViewState extends State<SigninView> {
  final key = GlobalKey<FormState>();
  late SigninForm signinForm;
  FormState get form => key.currentState!;
  SecureStorage secureStorage =
      SecureStorage(keyUserName: "", keyUserToken: "");
  String? error;

  @override
  void initState() {
    signinForm = SigninForm(username: null, password: null);
    super.initState();
  }

  Future<void> setSecureStorageData(username, token) async {
    username = await secureStorage.setUserName(username) ?? '';
    token = await secureStorage.setUserToken(token) ?? '';
  }

  Future<void> submitform() async {
    if (form.validate()) {
      form.save();
      final User response =
          await Provider.of<AuthProvider>(context, listen: false)
              .signin(signinForm);

      if (response.token == "unknown") {
        return print("Unknown user");
      } else {
        setSecureStorageData(response.username, response.token);
        String token = response.token;
        Navigator.pushNamed(
          context,
          HomeView.routeName,
          // arguments: token,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: const [
                BackButton(),
                Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: SizedBox.fromSize(
                child: Image.asset(
                  'assets/images/logo_sans_texte.png',
                  fit: BoxFit.cover,
                  width: 300,
                ),
              ),
            ),
            Form(
              key: key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    onSaved: ((newValue) {
                      signinForm.username = newValue;
                    }),
                    decoration: InputDecoration(
                        hintText: 'Login',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.deepPurple, width: 2.0),
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 3.0)),
                  TextFormField(
                    onSaved: ((newValue) {
                      signinForm.password = newValue;
                    }),
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: 'Password',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.deepPurple, width: 2.0),
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 3.0)),
                  ElevatedButton(
                    onPressed: submitform,
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        )),
                    child: Column(children: const [
                      Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Text('Login'))
                    ]),
                  ),
                ],
              ),
            ),
            const Text(
              'Forgot Password?',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
