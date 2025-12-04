import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme/theme.dart';
import 'models/user_profile.dart';
import 'src/root.dart';
import 'src/common/bottom_nav_controller.dart';
import 'src/common/theme_controller.dart';
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
    // ThemeController 초기화
    Get.put(ThemeController());

    return GetMaterialApp(
      title: 'Gyurot Market',
      theme: MyTheme.theme.copyWith(
        textTheme: GoogleFonts.notoSansKrTextTheme(MyTheme.theme.textTheme),
      ),
      darkTheme: MyTheme.darkTheme.copyWith(
        textTheme: GoogleFonts.notoSansKrTextTheme(MyTheme.darkTheme.textTheme),
      ),
      themeMode: ThemeMode.dark,
      initialRoute: '/start',
      getPages: [
        GetPage(name: '/start', page: () => const StartScreen()),
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(
          name: '/home',
          page: () => const Root(),
          binding: BindingsBuilder(() {
            Get.put(BottomNavController());
          }),
        ),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}
