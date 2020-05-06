import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:micro_news/data/home_data.dart';
import 'package:flutter/material.dart';

class HomeDetailTile extends StatelessWidget {

  final String docHome;
  final String docFaixas;
  final String type;
  final HomeData eventos;

  DocumentSnapshot snapshot;

  HomeDetailTile(this.docHome, this. docFaixas, this.type, this.eventos);

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
                                child: Counter(docHome, docFaixas, eventos.marcacao, eventos.id),
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

  Counter(this.docHome, this.docFaixas, this.marcacao, this.id);

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

  @override
  void initState() {
    marcacao = widget.marcacao;
    docHome = widget.docHome;
    docFaixas = widget.docFaixas;
    id = widget.id;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.child_care, size: 40.0),
          color: Colors.black38,
          onPressed: () {
                Firestore.instance
                    .collection("home")
                    .document(docHome)
                    .collection("faixas")
                    .document(docFaixas)
                    .collection("eventos")
                    .document(id)
                    .updateData({
                  "marcacoes": marcacao + 1,
                });

                setState(() {
                  marcacao++;
                });
          },
        ),
        Padding(padding: EdgeInsets.only(right: 10.0),),
        Text(marcacao.toString(),
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black38)),
      ],
    );
  }
}
