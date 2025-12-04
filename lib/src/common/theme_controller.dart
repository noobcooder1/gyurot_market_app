import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  RxBool isDarkMode = true.obs;

  ThemeMode get themeMode =>
      isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    isDarkMode.toggle();
    Get.changeThemeMode(themeMode);
  }

  void setDarkMode(bool value) {
    isDarkMode.value = value;
    Get.changeThemeMode(themeMode);
  }
}
