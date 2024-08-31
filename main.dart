import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobiledevelopment/config/my_theme.dart';
import 'package:mobiledevelopment/screens/home_screen.dart';
import 'package:mobiledevelopment/screens/splash_screen.dart';
import 'package:mobiledevelopment/controller/theme_controller.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());

    return Obx(() {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My App',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: themeController.isDark.value ? ThemeMode.dark : ThemeMode.light,
        home: SplashScreen(),

      );
    });

  }
}
