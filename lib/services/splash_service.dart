import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/ui/auth/login_screen.dart';
import 'package:firebase_practice/ui/home_screen.dart';
import 'package:flutter/material.dart';

class SplashService {

  void isLogin(BuildContext context) {
    final auth=FirebaseAuth.instance;
    final user= auth.currentUser;

    if(user!=null){
      Timer(Duration(seconds: 3), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      });
    }
    else{
      Timer(Duration(seconds: 3), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      });
    }

  }
}
