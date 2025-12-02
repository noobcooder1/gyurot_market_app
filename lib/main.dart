import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'theme/theme.dart';
import 'models/user_profile.dart';
import 'src/root.dart';
import 'screens/start_screen.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProfileProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Gyurot Market',
      theme: MyTheme.theme,
      initialRoute: '/start',
      getPages: [
        GetPage(name: '/start', page: () => const StartScreen()),
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/home', page: () => const Root()),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}
