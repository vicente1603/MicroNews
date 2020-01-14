import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Teste MicroNews",
        theme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: Color.fromARGB(255, 4, 125, 141)),
        debugShowCheckedModeBanner: false,
        home: HomeScreen());
  }
}
