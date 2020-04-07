import 'package:micro_news/models/user_model.dart';
import 'package:micro_news/screens/home_screen.dart';
import 'package:micro_news/tabs/home_tab.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.blueAccent,
            title: Text("Criar Conta"),
            centerTitle: true),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Colors.blueAccent,
            Colors.white,
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: ScopedModelDescendant<UserModel>(
            builder: (context, child, model) {
              if (model.isLoading)
                return Center(child: CircularProgressIndicator());

              return Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.all(16.0),
                  children: <Widget>[
                    TextFormField(
                        controller: _nomeController,
                        decoration: InputDecoration(hintText: "Nome Completo"),
                        validator: (text) {
                          if (text.isEmpty) return "Nome inválido";
                        }),
                    SizedBox(height: 16.0),
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
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _enderecoController,
                      decoration: InputDecoration(hintText: "Endereço"),
                      validator: (text) {
                        if (text.isEmpty) return "Endereço inválido";
                      },
                    ),
                    SizedBox(height: 16.0),
                    SizedBox(
                      height: 44.0,
                      child: RaisedButton(
                        child: Text("Criar Conta",
                            style: TextStyle(fontSize: 18.0)),
                        textColor: Colors.white,
                        color: Colors.blueAccent,
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            Map<String, dynamic> userData = {
                              "nome": _nomeController.text.trim(),
                              "email": _emailController.text.trim(),
                              "endereco": _enderecoController.text.trim()
                            };

                            model.signUp(
                                userData: userData,
                                pass: _senhaController.text.trim(),
                                onSuccess: _onSuccess,
                                onFail: _onFail);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ));
  }

  void _onSuccess() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Usuário criado com sucesso!"),
      backgroundColor: Colors.blueAccent,
      duration: Duration(seconds: 2),
    ));
    Future.delayed(Duration(seconds: 2)).then((_) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()));
    });
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Falha ao criar usuário."),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2),
    ));
  }
}
