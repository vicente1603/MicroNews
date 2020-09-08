import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:micro_news/models/usuario_model.dart';
import 'package:micro_news/screens/home_screen.dart';
import 'package:micro_news/tabs/chat_tab.dart';
import 'package:micro_news/tabs/desenvolvimento_infantil_tab.dart';
import 'package:micro_news/widgets/custom_drawer.dart';

class ListTileImc extends StatefulWidget {
  String id;
  double peso;
  double altura;
  double imc;
  String info;
  int data;

  ListTileImc(this.id, this.peso, this.altura, this.imc, this.info, this.data);

  @override
  _ListTileImcState createState() => _ListTileImcState();
}

class _ListTileImcState extends State<ListTileImc> {
  String id;
  double peso;
  double altura;
  double imc;
  String info;
  int data;

  @override
  void initState() {
    id = widget.id;
    peso = widget.peso;
    altura = widget.altura;
    imc = widget.imc;
    info = widget.info;
    data = widget.data;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (UserModel.of(context).isLoggedIn()) {
      var uid = UserModel.of(context).firebaseUser.uid;
      var _data = converterTimestamp(data);

      return ListTile(
          contentPadding: EdgeInsets.only(top: 5, left: 10),
          title: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Peso: $peso kg"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Altura: $altura cm"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Imc: " + imc.toStringAsPrecision(3)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "Info: $info",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "Data: $_data",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      openAlertBox(context, uid);
                    },
                  )
                ],
              ),
            ],
          ));
    }
  }

  openAlertBox(BuildContext context, String uid) {
    return showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: new Text('Remover'),
            content: new Text("Deseja remover o imc?"),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text("NÃO"),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              CupertinoDialogAction(
                child: Text("SIM"),
                onPressed: () {
                  Firestore.instance
                      .collection("users")
                      .document(uid)
                      .collection("desenvolvimento_infantil")
                      .document("imc")
                      .collection("imcs")
                      .document(id)
                      .delete();

                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => DesenvolvimentoInfantilTab()));
                },
                isDestructiveAction: true,
              ),
            ],
          );
        });
  }

  String converterTimestamp(int timestamp) {
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var formattedDate = DateFormat("dd/MM/yyyy").format(date); // 16/07/2020
    var time = formattedDate;

    return time;
  }
}
