import 'dart:io';
import 'package:micro_news/blocs/app_bloc.dart';
import 'package:micro_news/models/usuario_model.dart';
import 'package:micro_news/screens/credenciais/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import '../home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();

    readcontentEmail();
    readcontentPass();
  }

  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool remember = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.blueAccent,
          title: Text("MicroNews®", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0)),
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
      writeContentPass();
      writeContentEmail();
    }else {
      cleanContentEmail();
      cleanContentSenha();
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

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFileEmail async {
    final path = await _localPath;
    return File("$path/dataE.txt");
  }

  Future<File> get _localFilePass async {
    final path = await _localPath;
    return File("$path/dataP.txt");
  }

  Future<File> writeContentEmail() async {
    final file = await _localFileEmail;
    return file.writeAsString(_emailController.text.trim());
  }

  Future<File> writeContentPass() async {
    final file = await _localFilePass;
    return file.writeAsString(_senhaController.text.trim());
  }

  Future<String> readcontentEmail() async {
    try {
      final file = await _localFileEmail;
      String contents = await file.readAsString();
      _emailController.text = contents;

      if (contents == "") {
        remember = false;
      } else {
        remember = true;
      }

      setState(() {});

      return contents;
    } catch (e) {
      return 'Error';
    }
  }

  Future<String> readcontentPass() async {
    try {
      final file = await _localFilePass;
      String contents = await file.readAsString();
      _senhaController.text = contents;
      return contents;
    } catch (e) {
      return 'Error';
    }
  }

  Future<String> cleanContentEmail() async {
    try {
      final file = await _localFileEmail;
      file.writeAsString("");
      String contents = await file.readAsString();
      _emailController.text = contents;
      remember = false;
      return contents;
    } catch (e) {
      return 'Error';
    }
  }

  Future<String> cleanContentSenha() async {
    try {
      final file = await _localFilePass;
      file.writeAsString("");
      String contents = await file.readAsString();
      _senhaController.text = contents;
      remember = false;
      return contents;
    } catch (e) {
      return 'Error';
    }
  }
}
