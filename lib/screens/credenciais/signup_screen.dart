import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:micro_news/models/usuario_model.dart';
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
  final _confirmarEmailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _estadoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String nomeEstado = "";
  var _estados = [
    'Acre',
    'Alagoas',
    'Amapá',
    'Amazonas',
    'Bahia',
    'Ceará',
    'Distrito Federal',
    'Espirito Santo',
    'Goiás',
    'Maranhão',
    'Mato Grosso do Sul',
    'Mato Grosso',
    'Minas Gerais',
    'Pará',
    'Paraíba',
    'Paraná',
    'Pernambuco',
    'Piauí',
    'Rio de Janeiro',
    'Rio Grande do Norte',
    'Rio Grande do Sul',
    'Rondônia',
    'Roraima',
    'Santa Catarina',
    'São Paulo',
    'Sergipe',
    'Tocantins',
  ];
  var _itemSelecionado = 'Acre';

  var maskTelefone = MaskTextInputFormatter(
      mask: "(##) #####-####", filter: {"#": RegExp(r'[0-9]')});

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
                        controller: _confirmarEmailController,
                        decoration:
                            InputDecoration(hintText: "Confirmar e-mail"),
                        keyboardType: TextInputType.emailAddress,
                        validator: (text) {
                          if (text.isEmpty || !text.contains("@"))
                            return "Confirmação de e-mail inválida";
                        }),
                    SizedBox(height: 16.0),
                    criaDropDownButton(),
                    TextFormField(
                      inputFormatters: [maskTelefone],
                      controller: _telefoneController,
                      decoration: InputDecoration(hintText: "Telefone"),
                      validator: (text) {
                        if (text.isEmpty) return "Telefone inválido";
                      },
                    ),
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
                      controller: _confirmarSenhaController,
                      decoration: InputDecoration(hintText: "Confirmar senha"),
                      obscureText: true,
                      validator: (text) {
                        if (text.isEmpty || text.length < 6)
                          return "Confirmação de senha inválida";
                      },
                    ),
                    SizedBox(height: 32.0),
                    SizedBox(
                      height: 44.0,
                      child: RaisedButton(
                        child: Text("Criar Conta",
                            style: TextStyle(fontSize: 18.0)),
                        textColor: Colors.white,
                        color: Colors.blueAccent,
                        onPressed: () {
                          if (_formKey.currentState.validate() &&
                              validarCampos() == true) {
                            Map<String, dynamic> userData = {
                              "nome": _nomeController.text.trim(),
                              "email": _emailController.text.trim(),
                              "estado": _estadoController.text.trim(),
                              "telefone": _telefoneController.text.trim()
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

  criaDropDownButton() {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                "Estado",
                style: TextStyle(fontSize: 17, color: Colors.black54),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              DropdownButton<String>(
                  items: _estados.map((String dropDownStringItem) {
                    return DropdownMenuItem<String>(
                      value: dropDownStringItem,
                      child: Text(dropDownStringItem),
                    );
                  }).toList(),
                  onChanged: (String novoItemSelecionado) {
                    _dropDownItemSelected(novoItemSelecionado);
                    setState(() {
                      this._itemSelecionado = novoItemSelecionado;
                      _estadoController.text = novoItemSelecionado;
                    });
                  },
                  value: _itemSelecionado),
            ],
          )
        ],
      ),
    );
  }

  void _dropDownItemSelected(String novoItem) {
    setState(() {
      this._itemSelecionado = novoItem;
    });
  }

  bool validarCampos() {
    var valido = false;

    if (_emailController.text.trim() != _confirmarEmailController.text.trim()) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Os e-mails não são iguais."),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ));
      valido = false;
    } else if (_senhaController.text.trim() !=
        _confirmarSenhaController.text.trim()) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("As senhas não são iguais."),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ));
      valido = false;
    } else {
      valido = true;
    }
    return valido;
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
