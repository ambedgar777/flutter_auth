import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/UI/auth/login_screen.dart';
import 'package:flutter_auth/post/post_screen.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    //to check rather the user is logged in or logged out.
    FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    //if already logged in then direct user to post screen otherwise login screen
    if (user != null) {
      Timer(
        const Duration(seconds: 3),
        () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostScreen(),
          ),
        ),
      );
    } else {
      Timer(
        const Duration(seconds: 3),
        () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        ),
      );
    }
  }
}
