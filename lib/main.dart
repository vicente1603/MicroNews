import 'package:chat_online/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'models/user_model.dart';
import 'screens/home_screen.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),
        child: MaterialApp(
            title: "Teste MicroNews",
            theme: ThemeData(
                primarySwatch: Colors.blue,
                primaryColor: Colors.blueAccent),
            debugShowCheckedModeBanner: false,
            home: LoginScreen()));
  }
}
