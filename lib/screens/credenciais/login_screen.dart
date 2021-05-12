import 'dart:io';
import 'package:flutter/services.dart';
import 'package:micro_news/models/usuario_model.dart';
import 'package:micro_news/screens/credenciais/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:micro_news/tabs/home_tab.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

    readcontentEmailBiometric();
    readcontentPassBiometric();

    getLeitorDigital();
    getAutorizacaoDigital();
  }

  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  String emailPrefs;
  String senhaPrefs;
  bool leitorDigital = false;
  bool biometriaAutorizada = false;
  bool loginAutorizado = false;
  bool remember = false;
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  UserModel user = new UserModel();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.blueAccent,
          title: Text("MicroNews®",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0)),
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
            user = model;

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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Leitor biométrico", style: TextStyle(fontSize: 17)),
                      SizedBox(width: 15),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 0),
                        height: 40.0,
                        width: 60.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: leitorDigital
                              ? Colors.blueAccent.withOpacity(0.5)
                              : Colors.redAccent.withOpacity(0.5),
                        ),
                        child: Stack(
                          children: <Widget>[
                            AnimatedPositioned(
                              duration: Duration(milliseconds: 0),
                              curve: Curves.easeIn,
                              top: 3.0,
                              left: leitorDigital ? 25.0 : 00,
                              right: leitorDigital ? 0.0 : 25.0,
                              child: InkWell(
                                onTap: _leitorDigital,
                                child: AnimatedSwitcher(
                                    duration: Duration(milliseconds: 0),
                                    child: leitorDigital
                                        ? Icon(Icons.check_circle,
                                            color: Colors.lightBlue[900],
                                            size: 35.0,
                                            key: UniqueKey())
                                        : Icon(Icons.remove_circle_outline,
                                            color: Colors.red,
                                            size: 35.0,
                                            key: UniqueKey())),
                              ),
                            )
                          ],
                        ),
                      ),
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

                        print("model:");
                        print(model);

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
    } else {
      cleanContentEmail();
      cleanContentSenha();
    }

    if (leitorDigital) {
      if (biometriaAutorizada == false) {
        biometriaAutorizada = true;
        setAutorizacaoDigital(biometriaAutorizada);
      }
    } else {
      biometriaAutorizada = false;
    }

    loginAutorizado = true;

    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => HomeTab()));
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

  Future<String> get _localPathBiometric async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFileEmailBiometric async {
    final path = await _localPathBiometric;
    return File("$path/dataEBiometric.txt");
  }

  Future<File> get _localFilePassBiometric async {
    final path = await _localPathBiometric;
    return File("$path/dataPBiometric.txt");
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

  Future<String> readcontentEmailBiometric() async {
    try {
      final file = await _localFileEmailBiometric;
      String contents = await file.readAsString();
      emailPrefs = contents;
      return contents;
    } catch (e) {
      return 'Error';
    }
  }

  Future<String> readcontentPassBiometric() async {
    try {
      final file = await _localFilePassBiometric;
      String contents = await file.readAsString();
      senhaPrefs = contents;
      return contents;
    } catch (e) {
      return 'Error';
    }
  }

  getLeitorDigital() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    leitorDigital = prefs.getBool('leitorDigital');

    if (leitorDigital == null) {
      leitorDigital = false;
    }

    setState(() {});
  }

  getAutorizacaoDigital() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    biometriaAutorizada = prefs.getBool('biometriaAutorizada');
    if (biometriaAutorizada == null) {
      biometriaAutorizada = false;
    }

    if (loginAutorizado == false) {
      abrirTelaDigital();
    }
  }

  abrirTelaDigital() {
    if (biometriaAutorizada) {
      _authorizeNow();
    }
  }

  void _authorizeNow() async {
    bool isAuthorized = false;

    try {
      isAuthorized = await _localAuthentication.authenticateWithBiometrics(
          localizedReason: "Toque no sensor para realizar o login",
          useErrorDialogs: true,
          stickyAuth: false);
    } on PlatformException catch (e) {
      print(e);
    }

    if (!mounted) return;

    setState(() {
      if (isAuthorized) {
        print("usuario:");
        print(user);

        user.signIn(
            email: _emailController.text.trim(),
            pass: _senhaController.text.trim(),
            onSuccess: _onSuccess,
            onFail: _onFail);
      } else {
        print("falha no login");
      }
    });
  }

  _leitorDigital() {
    setState(() {
      leitorDigital = !leitorDigital;
      if (leitorDigital) {
        _mostrarDialogLeitorDigital();
      } else {
        setAutorizacaoDigital(false);
      }
      setLeitorDigital(leitorDigital);
    });
  }

  setAutorizacaoDigital(bool biometriaAutorizada) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('biometriaAutorizada', biometriaAutorizada);

    writeContentEmailBiometric();
    writeContentPassBiometric();

    getAutorizacaoDigital();

    setState(() {});
  }

  setLeitorDigital(bool leitorDigital) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('leitorDigital', leitorDigital);
  }

  _mostrarDialogLeitorDigital() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Leitor biométrico"),
            content:
                Text("O leitor biométrico será habilitado no próximo login."),
            actions: <Widget>[
              FlatButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop(
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  })
            ],
          );
        });
  }

  Future<File> writeContentEmailBiometric() async {
    final file = await _localFileEmailBiometric;
    return file.writeAsString(_emailController.text.trim());
  }

  Future<File> writeContentPassBiometric() async {
    final file = await _localFilePassBiometric;
    return file.writeAsString(_senhaController.text.trim());
  }
}
