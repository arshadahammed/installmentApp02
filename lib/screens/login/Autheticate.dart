import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_myinstalment_application/screens/home_screen.dart';
import 'package:flutter_myinstalment_application/screens/login/login_screen.dart';

class Authenticate extends StatelessWidget {
  final String clientName;
  final String clientKey;
  Authenticate({Key? key, required this.clientName, required this.clientKey})
      : super(key: key);
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    if (_auth.currentUser != null) {
      return HomeScreen();
    } else {
      return LoginScreen();
    }
  }
}
