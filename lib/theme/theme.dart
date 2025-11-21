import 'package:flutter/material.dart';

class MyTheme {
  static const Color orange = Color(0xFFFF7E36);
  static const Color darkGrey = Color(0xFF212121);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color lightGrey = Color(0xFFF5F5F5);

  static ThemeData get theme {
    return ThemeData(
      primaryColor: orange,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: orange,
        secondary: orange,
      ),
    );
  }
}
