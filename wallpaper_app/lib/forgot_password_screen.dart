import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgetPasswordScreen extends StatefulWidget {
  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  // Function to send password reset email
  Future<void> sendResetEmail() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text("Password Reset Email has been sent!",
                style: TextStyle(fontSize: 20)),
          ),
        );
        // Wait for 3 seconds before navigating to the login screen
        await Future.delayed(Duration(seconds: 3));
        Navigator.pushReplacementNamed(context, '/SignInScreen'); // Navigate to sign-in screen
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text("User Not Found",
                  style: TextStyle(fontSize: 20)),
            ),
          );
        }
      }
    }
  }

  // Validation for email input
  String? validateEmail(String? email) {
    RegExp emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (email == null || email.isEmpty || !emailRegex.hasMatch(email)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bgimage.jpeg'), // Your background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Overlay with forgot password form
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Reset Password',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.8),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: validateEmail,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: sendResetEmail,
                        child: Text('Send Password Reset Email'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
