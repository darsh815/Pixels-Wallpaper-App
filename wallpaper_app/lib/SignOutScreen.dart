import 'package:flutter/material.dart';
import 'LoginScreen.dart'; // Import the LoginScreen

class SignOutScreen extends StatelessWidget { void _showSignOutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sign Out'),
          content: Text('Do you want to sign out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _showSignOutSuccessDialog(context); // Show success dialog
              },
              child: Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }

  void _showSignOutSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('Sign out successful'),
        );
      },
    );

    Future.delayed(Duration(seconds: 1), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SignInScreen()),
            (Route<dynamic> route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Out'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _showSignOutConfirmationDialog(context);
          },
          child: Text('Sign Out'),
        ),
      ),
    );
  }
}
