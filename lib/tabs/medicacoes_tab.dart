import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:micro_news/models/user_model.dart';
import 'package:micro_news/tabs/chat_tab.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MedicacoesTab extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<MedicacoesTab> {
  final _medicamento = TextEditingController();
  final _posologia = TextEditingController();
  final _horario = TextEditingController();
  String _time;

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
        "horario": _horario.text,
        "checked": false,
      });

      _medicamento.text = "";
      _posologia.text = "";
      _horario.text = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    if (UserModel.of(context).isLoggedIn()) {
      String uid = UserModel.of(context).firebaseUser.uid;

      return Scaffold(
        body: Container(
          padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      autofocus: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.healing),
                          labelText: "Medicamento",
                          labelStyle: TextStyle(color: Colors.blueAccent)),
                      controller: _medicamento,
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.filter_1),
                          labelText: "Posologia / Quantidade",
                          labelStyle: TextStyle(color: Colors.blueAccent)),
                      controller: _posologia,
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.access_time),
                          labelText: "Horário",
                          hintText: _horario.text,
                          labelStyle: TextStyle(color: Colors.blueAccent)),
                      controller: _horario,
                      onTap: () {
                        {
                          DatePicker.showTimePicker(context,
                              theme: DatePickerTheme(
                                containerHeight: 210.0,
                              ),
                              showTitleActions: true, onConfirm: (time) {
                            _time = '${time.hour} : ${time.minute}';
                            setState(() {
                              _horario.text = _time;
                            });
                          },
                              currentTime: DateTime.now(),
                              locale: LocaleType.en);
                          setState(() {
                            _horario.text = _time;
                          });
                        }
                      },
                    ),
                  ),
                ],
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
                      .document(uid)
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
                              List r =
                                  snapshot.data.documents.reversed.toList();
                              return MedicacoesList(r[index].data);
                            });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}

class MedicacoesList extends StatelessWidget {
  final Map<String, dynamic> data;

  MedicacoesList(this.data);

  @override
  Widget build(BuildContext context) {
    if (UserModel.of(context).isLoggedIn()) {
      String uid = UserModel.of(context).firebaseUser.uid;

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
            subtitle: Text("Posologia: " + data["posologia"] + " | Horário: " + data["horario"]),
            value: data["checked"],
            secondary: CircleAvatar(
              child: Icon(data["checked"] == true ? Icons.check : Icons.error),
            ),
            onChanged: (c) {
              if (data["checked"] == true) {
                Firestore.instance
                    .collection("users")
                    .document(uid)
                    .collection("medicacoes")
                    .document(data["id"])
                    .setData({
                  "id": data["id"],
                  "medicamento": data["medicamento"],
                  "posologia": data["posologia"],
                  "horario": data["horario"],
                  "checked": false,
                });
              } else {
                Firestore.instance
                    .collection("users")
                    .document(uid)
                    .collection("medicacoes")
                    .document(data["id"])
                    .setData({
                  "id": data["id"],
                  "medicamento": data["medicamento"],
                  "posologia": data["posologia"],
                  "horario": data["horario"],
                  "checked": true,
                });
              }
            },
          ),
          onDismissed: (direction) {
            Firestore.instance
                .collection("users")
                .document(uid)
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
  }
}
