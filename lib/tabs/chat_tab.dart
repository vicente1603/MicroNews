import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:micro_news/helper/convert_time.dart';
import 'package:micro_news/models/usuario_model.dart';
import 'package:micro_news/widgets/custom_drawer_guitar.dart';
import 'package:scoped_model/scoped_model.dart';

String uid;

class ChatTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      centerTitle: true,
      title: Text(
        "Support network",
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 25.0, color: Colors.white),
        textAlign: TextAlign.center,
      ),
      leading: Builder(
        builder: (context) {
          return IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => CustomGuitarDrawer.of(context).open(),
          );
        },
      ),
    );
    Widget child = _ChatTab(appBar: appBar);

    child = CustomGuitarDrawer(child: child);

    return child;
  }
}

class _ChatTab extends StatefulWidget {
  final AppBar appBar;

  _ChatTab({Key key, @required this.appBar}) : super(key: key);

  @override
  __ChatTabState createState() => __ChatTabState();
}

class __ChatTabState extends State<_ChatTab> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
        appBar: widget.appBar,
        body: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder(
                stream: Firestore.instance
                    .collection("mensagens_chat")
                    .orderBy('horaDataEnvio')
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
                          reverse: true,
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            List r = snapshot.data.documents.reversed.toList();
                            return MensagemTile(
                                r[index].data, r[index].data["uid"] == uid);
                          });
                  }
                },
              ),
            ),
            Divider(
              height: 1.0,
            ),
            Container(
              decoration: BoxDecoration(color: Theme.of(context).cardColor),
              child: CampoTexto(),
            )
          ],
        ),
      ),
    );
  }
}

class CampoTexto extends StatefulWidget {
  @override
  _CampoTextoState createState() => _CampoTextoState();
}

class _CampoTextoState extends State<CampoTexto> {
  final _textController = TextEditingController();
  bool _isComposing = false;

  void _reset() {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
  }

  void _sendMessage(
      {String text,
      String imgUrl,
      String nomeUsuario,
      String fotoUsuario}) async {
    Firestore.instance.collection("mensagens_chat").add({
      "texto": text,
      "imgUrl": imgUrl,
      "remetente": nomeUsuario,
      "uid": uid,
      "fotoRemetenteUrl": fotoUsuario,
      "horaDataEnvio": DateTime.now().millisecondsSinceEpoch
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
      builder: (context, child, model) {
        uid = model.firebaseUser.uid;
        return IconTheme(
          data: IconThemeData(color: Theme.of(context).accentColor),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            decoration: Theme.of(context).platform == TargetPlatform.iOS
                ? BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.grey[200])))
                : null,
            child: Row(
              children: <Widget>[
                Container(
                  child: IconButton(
                      icon: Icon(Icons.photo_camera),
                      onPressed: () async {
                        File imgFile = await ImagePicker.pickImage(
                            source: ImageSource.camera);
                        if (imgFile == null) return;
                        StorageUploadTask task = FirebaseStorage.instance
                            .ref()
                            .child(model.firebaseUser.uid.toString() +
                                DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString())
                            .putFile(imgFile);

                        StorageTaskSnapshot taskSnapshot =
                            await task.onComplete;
                        String url = await taskSnapshot.ref.getDownloadURL();
                        _sendMessage(
                            imgUrl: url,
                            nomeUsuario: model.userData["nome"],
                            fotoUsuario: model.userData["foto"]);
                      }),
                ),
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration:
                        InputDecoration.collapsed(hintText: "Send a message"),
                    onChanged: (text) {
                      setState(() {
                        _isComposing = text.length > 0;
                      });
                    },
                    onSubmitted: (text) {
                      _sendMessage(
                          text: text,
                          nomeUsuario: model.userData["nome"],
                          fotoUsuario: model.userData["foto"]);
                      _reset();
                    },
                  ),
                ),
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Theme.of(context).platform == TargetPlatform.iOS
                        ? CupertinoButton(
                            child: Text("Enviar"),
                            onPressed: _isComposing
                                ? () {
                                    _sendMessage(
                                        text: _textController.text,
                                        nomeUsuario: model.userData["nome"],
                                        fotoUsuario: model.userData["foto"]);
                                    _reset();
                                  }
                                : null,
                          )
                        : IconButton(
                            icon: Icon(Icons.send),
                            onPressed: _isComposing
                                ? () {
                                    _sendMessage(
                                        text: _textController.text,
                                        nomeUsuario: model.userData["nome"],
                                        fotoUsuario: model.userData["foto"]);
                                    _reset();
                                  }
                                : null,
                          ))
              ],
            ),
          ),
        );
      },
    );
  }
}

class MensagemTile extends StatelessWidget {
  final Map<String, dynamic> data;
  bool sendByMe;

  MensagemTile(this.data, this.sendByMe);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8, bottom: 8, left: sendByMe ? 0 : 24, right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin:
            sendByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: sendByMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23))
                : BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
              colors: sendByMe
                  ? [const Color(0xFF81D4FA), const Color(0xFF81D4FA)]
                  : [const Color(0xFFB0BEC5), const Color(0xFFB0BEC5)],
            )),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                backgroundImage: data["fotoRemetenteUrl"] == null
                    ? NetworkImage(
                        "https://icon-library.com/images/default-user-icon/default-user-icon-4.jpg")
                    : NetworkImage(data["fotoRemetenteUrl"]),
                radius: 30,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    data["remetente"] + " :",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      child: data["imgUrl"] != null
                          ? Image.network(
                              data["imgUrl"],
                              width: 250.0,
                            )
                          : Text(data["texto"])),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        readTimestamp(data["horaDataEnvio"]),
                        style: TextStyle(fontSize: 13),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String readTimestamp(int timestamp) {
    var format = new DateFormat('dd/MM/yyyy HH:mm a');
    var date = new DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);

    var time = format.format(date);

    return time;
  }
}
