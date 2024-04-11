// import 'dart:io';
//
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get_navigation/src/root/get_material_app.dart';
// import 'package:my_chat/pages/home.dart';
// import 'package:my_chat/pages/login.dart';
// import 'package:my_chat/pages/phone.dart';
// import 'package:my_chat/services/otp.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   Platform.isAndroid
//       ? await Firebase.initializeApp(
//           options: FirebaseOptions(
//               apiKey: "AIzaSyBjD0j_yoH5rp5SYZrbBkW6S6RKCGdSYPg",
//               appId: "1:351851098778:android:297a620cc7e24f36e7a523",
//               messagingSenderId: "351851098778",
//               projectId: "mychat-43a59",
//               storageBucket: "mychat-43a59.appspot.com",
//               authDomain: "mychat-43a59.firebaseapp.com",
//               measurementId: "G-8CWKV80T10"),
//         )
//       : await Firebase.initializeApp();
//
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       title: 'My App',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         appBarTheme: AppBarTheme(
//           centerTitle: true,
//           elevation: 1,
//           iconTheme: IconThemeData(color: Colors.black38),
//           titleTextStyle: TextStyle(
//             color: Colors.black,fontWeight: FontWeight.normal,fontSize:19 ,
//             backgroundColor: Colors.white,
//           ),
//         ),
//       ),
//       //home: Home(),
//         home: LogIn(), // Set the initial page directly
//       routes: {
//       //  'Login':(context)=>LogIn(),
//         'phone': (context) => MyPhone(),
//         'verify':(context) => MyVerify(),
//       },
//     );
//
//   }
// }





import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:my_chat/screen/login_screen.dart';


import 'auth_controller.dart';
import 'home_page.dart';
import 'login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyBjD0j_yoH5rp5SYZrbBkW6S6RKCGdSYPg",
        appId: "1:351851098778:android:297a620cc7e24f36e7a523",
        messagingSenderId: "351851098778",
        projectId: "mychat-43a59",
        storageBucket: "mychat-43a59.appspot.com",
        authDomain: "mychat-43a59.firebaseapp.com",
        measurementId: "G-8CWKV80T10"),
  )
      : await Firebase.initializeApp();

  // Get.put(AuthController());

  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false ,
      home: LoginScreen(),
    );
  }
}