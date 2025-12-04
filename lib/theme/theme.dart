import 'package:flutter/material.dart';

class MyTheme {
  static const Color orange = Color(0xFFFF7E36);
  static const Color darkGrey = Color(0xFF212121);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color lightGrey = Color(0xFFF5F5F5);

  // Light Theme
  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.light,
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
        brightness: Brightness.light,
      ),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: orange,
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        elevation: 0.5,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF212123),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
      colorScheme: ColorScheme.fromSwatch(brightness: Brightness.dark).copyWith(
        primary: orange,
        secondary: orange,
        surface: const Color(0xFF1E1E1E),
      ),
      cardColor: const Color(0xFF1E1E1E),
      dividerColor: Colors.grey[800],
    );
  }
}
