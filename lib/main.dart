import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:quanly_duan/screens/home/admin/admin_screen.dart';
import 'package:quanly_duan/screens/login/sign_in/sign_in.dart';

import 'layout/bottom_navigation_bar/bottom_navigation_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid?
  await Firebase.initializeApp(
    // name:"b-idea-b5e02",
      options: const FirebaseOptions(
          apiKey: 'AIzaSyBwacakQbI7UdT6gyx5_RPTQ-I6EkZ3SZY',
          appId: '1:12108652905:android:8c6a2c8c6936b2b82e1df8',
          messagingSenderId: '12108652905',
          projectId: 'manager-task-4bd60',
          storageBucket: "manager-task-4bd60.appspot.com"
      )) :
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: const Color(0xFFe0efff),
        useMaterial3: true,
      ),
      home:  const SignInScreen(),
      // home:AccountPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
