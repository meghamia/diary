import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:goalsync/screens/habit_screen.dart';

import 'controller/task_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(TaskController()); // Initialize TaskController
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HabitScreen()
    );
  }
}
