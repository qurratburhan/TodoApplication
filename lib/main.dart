import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loginsignup/login.dart';
import 'package:loginsignup/signup.dart';
import 'package:loginsignup/todolist.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid ? await Firebase.initializeApp(
  options: const  FirebaseOptions(
    apiKey: 'AIzaSyDzjXc4miOyHMVLNjSotNWemA_5fXlbSts', 
    appId: "1:698182791669:android:462bf21254560a3a54b0bc", 
    messagingSenderId: "698182791669", 
    projectId: "todoapp-b1ee2")
  ):await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),

      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const Home(),}
    );
  }
}
