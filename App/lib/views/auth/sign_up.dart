import 'dart:ui';

import 'package:esp_app/models/signup_form_model.dart';
import 'package:esp_app/providers/auth_provider.dart';
import 'package:esp_app/views/auth/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/signup_form_model.dart';

class SignUpView extends StatefulWidget {
  static String routeName = '/signup';
  const SignUpView({Key? key}) : super(key: key);

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final key = GlobalKey<FormState>();
  late SignupForm signupForm;
  FormState get form => key.currentState!;

  @override
  void initState() {
    signupForm = SignupForm(email: null, username: null, password: null);
    super.initState();
  }

  Future<void> submitform() async {
    if (form.validate()) {
      form.save();
      final error = await Provider.of<AuthProvider>(context, listen: false)
          .signup(signupForm);
      if (error == null) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const SigninView()));
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
                  'Sign Up',
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
                      signupForm.email = newValue;
                    }),
                    decoration: InputDecoration(
                        hintText: 'Email',
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
                      signupForm.username = newValue;
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
                      signupForm.password = newValue;
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
                          child: Text('Register'))
                    ]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
