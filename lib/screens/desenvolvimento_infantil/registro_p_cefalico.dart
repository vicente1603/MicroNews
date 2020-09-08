import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:micro_news/models/usuario_model.dart';
import 'package:micro_news/tabs/desenvolvimento_infantil_tab.dart';
import 'package:random_string/random_string.dart';

class RegistroPCefalicoScreen extends StatefulWidget {
  @override
  _RegistroPCefalicoScreenState createState() =>
      _RegistroPCefalicoScreenState();
}

class _RegistroPCefalicoScreenState extends State<RegistroPCefalicoScreen> {
  TextEditingController diametroController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  double diametro;
  DateTime data;


  void _salvar(diametro, uid) {
    var id = randomAlphaNumeric(15);

    diametro = double.parse(diametro);

    Firestore.instance
        .collection("users")
        .document(uid)
        .collection("desenvolvimento_infantil")
        .document("p_cefalico")
        .collection("ps_cefalicos")
        .document(id)
        .setData({
      "id": id,
      "diametro": diametro,
      "data": DateTime.now().toUtc().millisecondsSinceEpoch,
//      "cor": Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0)
    });

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => DesenvolvimentoInfantilTab()));
  }

  @override
  Widget build(BuildContext context) {
    if (UserModel.of(context).isLoggedIn()) {
      String uid = UserModel.of(context).firebaseUser.uid;

      return Scaffold(
        appBar: AppBar(
          title: Text("Registrar Perímetro Cefálico"),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Icon(Icons.person_outline,
                    size: 120.0, color: Colors.blueAccent),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Diâmetro (cm)",
                      labelStyle: TextStyle(color: Colors.blueAccent)),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.blueAccent, fontSize: 25.0),
                  controller: diametroController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Insira o diâmetro!";
                    }
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Container(
                    height: 50.0,
                    child: RaisedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _salvar(diametroController.text, uid);
                        }
                      },
                      child: Text(
                        "Salvar",
                        style: TextStyle(color: Colors.white, fontSize: 25.0),
                      ),
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
