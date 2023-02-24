import 'package:flutter/material.dart';

Column buildButtonTts(
    Color color, Color splashColor, IconData icon, Function func) {
  return Column(
    // mainAxisSize: MainAxisSize.min,

    // mainAxisAlignment: MainAxisAlignment.center,
    children: [
      IconButton(
        iconSize: 34.0,
        icon: Icon(icon),
        color: color,
        splashColor: splashColor,
        onPressed: () => func(),
      ),
    ],
  );
}
