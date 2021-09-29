import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:micro_news/models/home_data.dart';
import 'package:micro_news/models/usuario_model.dart';
import 'package:giffy_dialog/giffy_dialog.dart';

class HomeDetailTile extends StatelessWidget {
  final String docHome;
  final String docFaixas;
  final String type;
  final HomeData eventos;
  DocumentSnapshot snapshot;

  HomeDetailTile(this.docHome, this.docFaixas, this.type, this.eventos);

  @override
  Widget build(BuildContext context) {
    return new Container(
        margin: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 24.0,
        ),
        child: new Stack(
          children: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: Container(
                        margin: new EdgeInsets.only(left: 20.0, right: 10.0),
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.rectangle,
                          borderRadius: new BorderRadius.circular(20.0),
                          boxShadow: <BoxShadow>[
                            new BoxShadow(
                              color: Colors.blueGrey,
                              blurRadius: 20.0,
                              offset: new Offset(0.0, 10.0),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 50.0, left: 30.0, right: 30.0, bottom: 10.0),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(" ${eventos.description}",
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black38),
                                        textAlign: TextAlign.center),
                                  )
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Counter(
                                    docHome,
                                    docFaixas,
                                    eventos.marcacao,
                                    eventos.id,
                                    eventos.usuarios_like,
                                    eventos.usuarios_deslike),
                              ),
                            ],
                          ),
                        )),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}

class Counter extends StatefulWidget {
  int marcacao;
  String docHome;
  String docFaixas;
  String id;
  List<dynamic> usuarios_like;
  List<dynamic> usuarios_deslike;

  Counter(this.docHome, this.docFaixas, this.marcacao, this.id,
      this.usuarios_like, this.usuarios_deslike);

  static _CounterState of(BuildContext context) =>
      context.ancestorStateOfType(const TypeMatcher<_CounterState>());

  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int marcacao;
  String docHome;
  String docFaixas;
  String id;
  List<dynamic> usuarios_like;
  List<dynamic> usuarios_deslike;

  @override
  void initState() {
    marcacao = widget.marcacao;
    docHome = widget.docHome;
    docFaixas = widget.docFaixas;
    id = widget.id;
    usuarios_like = widget.usuarios_like;
    usuarios_deslike = widget.usuarios_deslike;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FlatButton(
          child: usuarios_like.contains(UserModel.of(context).firebaseUser.uid)
              ? Image.asset("assets/images/smile_color.png",
                  width: 60, height: 100)
              : Image.asset("assets/images/smile_pb.png",
                  width: 60, height: 100),
          onPressed: () {
            if (!usuarios_like
                .contains(UserModel.of(context).firebaseUser.uid)) {
              usuarios_like.add(UserModel.of(context).firebaseUser.uid);
              usuarios_deslike.remove(UserModel.of(context).firebaseUser.uid);

              Firestore.instance
                  .collection("home")
                  .document(docHome)
                  .collection("faixas")
                  .document(docFaixas)
                  .collection("eventos")
                  .document(id)
                  .updateData({
                "usuarios_like": usuarios_like,
                "usuarios_deslike": usuarios_deslike,
              });

              usuarios_deslike.remove(UserModel.of(context).firebaseUser.uid);

              setState(() {});

              showDialog(
                  context: context,
                  builder: (_) => NetworkGiffyDialog(
                        image: Image.network(
                          "https://cdn.dribbble.com/users/514480/screenshots/2088977/children.gif",
                          fit: BoxFit.cover,
                        ),
                        entryAnimation: EntryAnimation.TOP,
                        title: Text(
                          'Very well!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.w600),
                        ),
                        description: Text(
                          'Keep encouraging your child.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18.0),
                        ),
                        onOkButtonPressed: () {
                          Navigator.of(context).pop(true);
                        },
                      ));
            }
          },
        ),
//        SizedBox(width: 60.0),
        FlatButton(
          child: usuarios_deslike
                  .contains(UserModel.of(context).firebaseUser.uid)
              ? Image.asset("assets/images/sad_color.png",
                  width: 53, height: 90)
              : Image.asset("assets/images/sad_pb.png", width: 53, height: 90),
          onPressed: () {
            if (!usuarios_deslike
                .contains(UserModel.of(context).firebaseUser.uid)) {
              usuarios_deslike.add(UserModel.of(context).firebaseUser.uid);
              usuarios_like.remove(UserModel.of(context).firebaseUser.uid);

              Firestore.instance
                  .collection("home")
                  .document(docHome)
                  .collection("faixas")
                  .document(docFaixas)
                  .collection("eventos")
                  .document(id)
                  .updateData({
                "usuarios_like": usuarios_like,
                "usuarios_deslike": usuarios_deslike,
              });

              usuarios_like.remove(UserModel.of(context).firebaseUser.uid);

              setState(() {});

              showDialog(
                  context: context,
                  builder: (_) => NetworkGiffyDialog(
                        image: Image.network(
                          "https://i.pinimg.com/originals/61/b2/d3/61b2d33f39927afa72e5f57a28cc7c83.gif",
                          fit: BoxFit.cover,
                        ),
                        entryAnimation: EntryAnimation.TOP,
                        title: Text(
                          'Não se preocupe',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.w600),
                        ),
                        description: Text(
                          'Continue estimulando sua criança e ela vai conseguir!',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18.0),
                        ),
                        onOkButtonPressed: () {
                          Navigator.of(context).pop(true);
                        },
                      ));
            }
          },
        ),
//        Padding(
//          padding: EdgeInsets.only(right: 10.0),
//        ),
//        Text(marcacao.toString(),
//            style: TextStyle(
//                fontSize: 20.0,
//                fontWeight: FontWeight.bold,
//                color: Colors.black38)),
      ],
    );
  }
}
