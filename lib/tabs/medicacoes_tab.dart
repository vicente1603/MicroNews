import 'dart:convert';
import 'dart:io';
import 'package:chat_online/tabs/chat_tab.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class MedicacoesTab extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<MedicacoesTab> {
  final _medicamento = TextEditingController();
  final _posologia = TextEditingController();

  FirebaseUser firebaseUser;

  String userID = "";

  void inputData() async {
    final FirebaseUser user = await auth.currentUser();
    final uid = user.uid;

    setState(() {
      var id = Timestamp.now().nanoseconds.toString().trim() +
          DateTime.now()
              .toString()
              .replaceAll(":", "")
              .replaceAll("-", "")
              .replaceAll(".", "")
              .trim();

      Firestore.instance
          .collection("users")
          .document(uid)
          .collection("medicacoes")
          .document(id)
          .setData({
        "id": id,
        "medicamento": _medicamento.text,
        "posologia": _posologia.text,
        "checked": false,
      });

      _medicamento.text = "";
      _posologia.text = "";
    });
  }

  void readDataUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    userID = user.uid;
  }

  //inputDataTest();

  @override
  Widget build(BuildContext context) {
    readDataUser();

    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    autofocus: true,
                    decoration: InputDecoration(
                        labelText: "Medicamento",
                        labelStyle: TextStyle(color: Colors.blueAccent)),
                    controller: _medicamento,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                        labelText: "Posologia / Quantidade",
                        labelStyle: TextStyle(color: Colors.blueAccent)),
                    controller: _posologia,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: RaisedButton(
              color: Colors.blueAccent,
              child: Text("Adicionar"),
              textColor: Colors.white,
              onPressed: inputData,
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: Firestore.instance
                  .collection("users")
                  .document(userID)
                  .collection("medicacoes")
                  .snapshots(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  default:
                    return ListView.builder(
                        reverse: false,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          List r = snapshot.data.documents.reversed.toList();
                          return MedicacoesList(r[index].data);
                        });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MedicacoesList extends StatelessWidget {
  final Map<String, dynamic> data;
  String userID = "";

  MedicacoesList(this.data);

  @override
  Widget build(BuildContext context) {
    readDataUser();

    return Dismissible(
        key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
        background: Container(
          color: Colors.red,
          child: Align(
            alignment: Alignment(-0.9, 0.0),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ),
        direction: DismissDirection.startToEnd,
        child: CheckboxListTile(
          title: Text("Medicamento: " + data["medicamento"]),
          subtitle: Text("Posologia: " + data["posologia"]),
          value: data["checked"],
          secondary: CircleAvatar(
            child: Icon(data["checked"] == true ? Icons.check : Icons.error),
          ),
          onChanged: (c) {
            if (data["checked"] == true) {
              Firestore.instance
                  .collection("users")
                  .document(userID)
                  .collection("medicacoes")
                  .document(data["id"])
                  .setData({
                "id": data["id"],
                "medicamento": data["medicamento"],
                "posologia": data["posologia"],
                "checked": false,
              });
            } else {
              Firestore.instance
                  .collection("users")
                  .document(userID)
                  .collection("medicacoes")
                  .document(data["id"])
                  .setData({
                "id": data["id"],
                "medicamento": data["medicamento"],
                "posologia": data["posologia"],
                "checked": true,
              });
            }
          },
        ),
        onDismissed: (direction) {
          Firestore.instance
              .collection("medicacoes")
              .document(data["id"])
              .delete();

          final snack = SnackBar(
            content: Text("Medicamento removido"),
            duration: Duration(seconds: 2),
          );

          Scaffold.of(context).removeCurrentSnackBar();
          Scaffold.of(context).showSnackBar(snack);
        });
  }

  void readDataUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    userID = user.uid;
  }
}
