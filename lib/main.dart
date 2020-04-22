import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:micro_news/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:splashscreen/splashscreen.dart';
import 'models/user_model.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {



    return ScopedModel<UserModel>(
        model: UserModel(),
        child: MaterialApp(
            title: "MicroNews",
            theme: ThemeData(
                primarySwatch: Colors.blue, primaryColor: Colors.blueAccent),
            debugShowCheckedModeBanner: false,
            home: _introScreen()));
  }
}

Widget _introScreen() {
  return Stack(
    children: <Widget>[
      SplashScreen(
        seconds: 5,
        gradientBackground: LinearGradient(colors: [
          Colors.blueAccent,
          Colors.white,
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        navigateAfterSeconds: LoginScreen(),
        loaderColor: Colors.transparent,
      ),
      Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/images/login.png",
            ),
            fit: BoxFit.contain,
          ),
        ),
      ),
    ],
  );
}
