import 'package:faculty_app1/Screens/portofiloscreen/othersections/Expertise&Valueeddtion.dart';
import 'package:faculty_app1/Screens/portofiloscreen/Dashboard/dashboard.dart';
import 'package:faculty_app1/Screens/portofiloscreen/othersections/teaching.dart';
import 'package:faculty_app1/Screens/signandLogin/Login.dart';
import 'package:faculty_app1/Screens/signandLogin/signup.dart';
import 'package:flutter/material.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aditya University',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFFF7EE),
      ),
      home:  SignUpScreen(),
    );
  }
}

