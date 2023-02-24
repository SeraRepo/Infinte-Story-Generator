import 'dart:ui';

import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  static String routeName = '/profile';

  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: const Text(
          'ProfileView',
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
