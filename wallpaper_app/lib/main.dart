import 'package:flutter/material.dart';
import 'dart:async'; // For Timer
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:wallpaper_app/registration_screen.dart';
import 'package:wallpaper_app/splashscreen.dart';
import 'LoginScreen.dart';
import 'firebase_options.dart';
import 'forgot_password_screen.dart'; // Ensure this file is properly set up

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Initializes Firebase with the platform-specific options
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/', // Splash Screen is set as the initial route
      routes: {
        '/': (context) => SplashScreen(), // Default splash screen
        '/login': (context) => SignInScreen(), // Login page
        '/register': (context) => RegistrationScreen(), // Registration page
        '/forgot': (context) => ForgetPasswordScreen(), // Forgot password page
      },
    );
  }
}

