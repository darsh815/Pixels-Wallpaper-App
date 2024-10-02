import 'package:flutter/material.dart';
import 'dart:async'; // For Timer
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'firebase_options.dart'; // Ensure this file is properly set up
import 'LoginScreen.dart'; // Import your login screen
import 'registration_screen.dart'; // Import your registration screen
import 'forgot_password_screen.dart'; // Import your forget password screen

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
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/', // Splash Screen is set as the initial route
      routes: {
        '/': (context) => SplashScreen(), // Navigate to SplashScreen first
        '/SignInScreen': (context) => SignInScreen(), // Navigate to SignInScreen
        '/RegistrationScreen': (context) => RegistrationScreen(), // Navigate to RegistrationScreen
        '/ForgetPasswordScreen': (context) => ForgetPasswordScreen(), // Navigate to ForgetPasswordScreen
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Using Timer to delay navigation to the SignInScreen after 3 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/SignInScreen'); // Navigate to SignInScreen after 3 seconds
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.blue, // Background color for the splash screen
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              // Your app logo or splash image
              Icon(
                Icons.cloud, // Example: Weather app icon
                size: 100.0,
                color: Colors.white,
              ),
              SizedBox(height: 20),
              Text(
                'Weather App',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white), // Loading indicator
              ),
            ],
          ),
        ),
      ),
    );
  }
}
