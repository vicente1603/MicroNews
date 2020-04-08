import 'package:micro_news/models/user_model.dart';
import 'package:micro_news/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override
  void initState() {
    super.initState();

    rememberUser();
  }

  static String email ;

  final _emailController = TextEditingController(text: email);
  final _senhaController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool remember = false;

  Future<void> rememberUser() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString('email');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.blueAccent,
          title: Text("MicroNews"),
          centerTitle: true,
          actions: <Widget>[
            FlatButton(
              child: Text(
                "CRIAR CONTA",
                style: TextStyle(fontSize: 15.0),
              ),
              textColor: Colors.white,
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SignUpScreen()));
              },
            )
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Colors.blueAccent,
            Colors.white,
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: ScopedModelDescendant<UserModel>(
              builder: (context, child, model) {
            if (model.isLoading)
              return Center(
                child: CircularProgressIndicator(),
              );

            return Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: <Widget>[
                  Image.asset(
                    'assets/images/login.png',
                    height: 250,
                  ),
                  TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(hintText: "E-mail"),
                      keyboardType: TextInputType.emailAddress,
                      validator: (text) {
                        if (text.isEmpty || !text.contains("@"))
                          return "E-mail inválido";
                      }),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _senhaController,
                    decoration: InputDecoration(hintText: "Senha"),
                    obscureText: true,
                    validator: (text) {
                      if (text.isEmpty || text.length < 6)
                        return "Senha inválida";
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Checkbox(
                        value: remember,
                        onChanged: (bool value) {
                          setState(() {
                            remember = value;
                          });
                        },
                      ),
                      Text("Lembrar-me"),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FlatButton(
                      onPressed: () {
                        if (_emailController.text.isEmpty) {
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content:
                                Text("Insira seu e-mail para recuperação."),
                            backgroundColor: Colors.redAccent,
                            duration: Duration(seconds: 2),
                          ));
                        } else {
                          model.recoverPass(_emailController.text);
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text("Confira seu e-mail."),
                            backgroundColor: Colors.blueAccent,
                            duration: Duration(seconds: 2),
                          ));
                        }
                      },
                      child: Text("Esqueci minha senha",
                          textAlign: TextAlign.right),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  SizedBox(
                    height: 44.0,
                    child: RaisedButton(
                      child: Text("Entrar", style: TextStyle(fontSize: 18.0)),
                      textColor: Colors.white,
                      color: Colors.blueAccent,
                      onPressed: () {
                        if (_formKey.currentState.validate()) {}

                        model.signIn(
                            email: _emailController.text.trim(),
                            pass: _senhaController.text.trim(),
                            onSuccess: _onSuccess,
                            onFail: _onFail);
                      },
                    ),
                  ),
                ],
              ),
            );
          }),
        ));
  }

  void _onSuccess() async {
    if (remember == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('email', _emailController.text.trim()); //a

      setState(() {
        email = _emailController.text.trim();
      });
    }

    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Falha ao realizar o login!"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2),
    ));
  }
}
