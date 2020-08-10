import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:micro_news/models/usuario_model.dart';
import 'package:micro_news/tabs/desenvolvimento_infantil_tab.dart';

class ListTilePCefalico extends StatefulWidget {
  String id;
  double diametro;
  int data;

  ListTilePCefalico(this.id, this.diametro, this.data);

  @override
  _ListTilePCefalicoState createState() => _ListTilePCefalicoState();
}

class _ListTilePCefalicoState extends State<ListTilePCefalico> {
  String id;
  double diametro;
  int data;

  @override
  void initState() {
    id = widget.id;
    diametro = widget.diametro;
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
                  Text("Diâmetro: $diametro cm"),
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
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Remover'),
            content: new Text("Deseja remover o perímetro cefálico?"),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Text("NÃO"),
              ),
              SizedBox(height: 16),
              new GestureDetector(
                onTap: () {
                  Firestore.instance
                      .collection("users")
                      .document(uid)
                      .collection("desenvolvimento_infantil")
                      .document("p_cefalico")
                      .collection("ps_cefalicos")
                      .document(id)
                      .delete();

                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => DesenvolvimentoInfantilTab()));
                },
                child: Text("SIM"),
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
