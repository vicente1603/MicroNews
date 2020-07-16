import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:micro_news/models/usuario_model.dart';
import 'package:random_string/random_string.dart';

class RegistroImcScreen extends StatefulWidget {
  @override
  _RegistroImcScreenState createState() => _RegistroImcScreenState();
}

class _RegistroImcScreenState extends State<RegistroImcScreen> {
  TextEditingController pesoController = TextEditingController();
  TextEditingController alturaController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _info = "Informe seus dados!";
  double peso;
  double altura;
  double imc;
  DateTime data;

  void _resetFields() {
    pesoController.text = "";
    alturaController.text = "";
    setState(() {
      _info = "Informe seus dados!";
      _formKey = GlobalKey<FormState>();
    });
  }

  void _calculate(uid) {
    setState(() {
      peso = double.parse(pesoController.text);
      altura = double.parse(alturaController.text) / 100;
      imc = peso / (altura * altura);
      if (imc < 18.6) {
        _info = "Abaixo do Peso (${imc.toStringAsPrecision(4)})";
      } else if (imc >= 18.6 && imc < 24.9) {
        _info = "Peso Ideal (${imc.toStringAsPrecision(4)})";
      } else if (imc >= 24.9 && imc < 29.9) {
        _info = "Levemente Acima do Peso (${imc.toStringAsPrecision(4)})";
      } else if (imc >= 29.9 && imc < 34.9) {
        _info = "Obesidade Grau I (${imc.toStringAsPrecision(4)})";
      } else if (imc >= 34.9 && imc < 39.9) {
        _info = "Obesidade Grau II (${imc.toStringAsPrecision(4)})";
      } else if (imc >= 40) {
        _info = "Obesidade Grau III (${imc.toStringAsPrecision(4)})";
      }
    });

    _salvar(_info, peso, altura, imc, uid);
  }

  void _salvar(_info, peso, altura, imc, uid) {
    var id = randomAlphaNumeric(15);

    Firestore.instance
        .collection("users")
        .document(uid)
        .collection("desenvolvimento_infantil")
        .document("imc")
        .collection("imcs")
        .document(id)
        .setData({
      "id": id,
      "peso": peso,
      "altura": altura,
      "imc": imc,
      "info": _info,
      "data": DateTime.now().toUtc().millisecondsSinceEpoch
    });
  }

  @override
  Widget build(BuildContext context) {
    if (UserModel.of(context).isLoggedIn()) {
      String uid = UserModel.of(context).firebaseUser.uid;

      return Scaffold(
        appBar: AppBar(
          title: Text("Registrar IMC"),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: _resetFields,
            )
          ],
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
                      labelText: "Peso (kg)",
                      labelStyle: TextStyle(color: Colors.blueAccent)),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.blueAccent, fontSize: 25.0),
                  controller: pesoController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Insira seu Peso!";
                    }
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: "Altura (cm)",
                      labelStyle: TextStyle(color: Colors.blueAccent)),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.blueAccent, fontSize: 25.0),
                  controller: alturaController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Insira sua Altura!";
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
                          _calculate(uid);
                        }
                      },
                      child: Text(
                        "Calcular",
                        style: TextStyle(color: Colors.white, fontSize: 25.0),
                      ),
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
                Text(
                  _info,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.blueAccent, fontSize: 25.0),
                )
              ],
            ),
          ),
        ),
      );
    }
  }
}
