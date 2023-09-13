import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true
    );
  }
}

ColorScheme colorScheme(BuildContext context) {
  return Theme.of(context).colorScheme;
}

TextTheme textTheme(BuildContext context) {
  return Theme.of(context).textTheme;
}

TextTheme textThemePrimary(BuildContext context) {
  return Theme.of(context).primaryTextTheme;
}