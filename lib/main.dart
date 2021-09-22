import 'package:flutter/material.dart';
import 'package:micro_news/blocs/app_bloc.dart';
import 'package:micro_news/models/usuario_model.dart';
import 'package:micro_news/screens/credenciais/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(MicroNews());
}

class MicroNews extends StatefulWidget {
  @override
  _MicroNewsState createState() => _MicroNewsState();
}

class _MicroNewsState extends State<MicroNews> {
  GlobalBloc globalBloc;

  void initState() {
    globalBloc = GlobalBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var doc;

    return Provider<GlobalBloc>.value(
      value: globalBloc,
      child: ScopedModel<UserModel>(
          model: UserModel(),
          child: MaterialApp(
            title: "MicroNews",
            theme: ThemeData(
                primarySwatch: Colors.blue, primaryColor: Colors.blueAccent),
            debugShowCheckedModeBanner: false,
            home: _introScreen(),
          )),
    );
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
