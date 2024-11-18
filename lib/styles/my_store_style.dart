import 'package:flutter/material.dart';

class MyStoreStyle {
  static ThemeData theme = ThemeData(
    appBarTheme: const AppBarTheme(color: Colors.teal),
    primarySwatch: Colors.teal,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.teal,
    ),
    fontFamily: 'Anton',
  );
}
