import 'package:chat_online/data/dicas_data.dart';
import 'package:flutter/material.dart';

class DicasTile extends StatelessWidget {
  final String type;
  final DicasData dicas;

  DicasTile(this.type, this.dicas);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Container(
                margin: new EdgeInsets.only(left: 46.0, right: 46.0, bottom: 20.0, top: 10.0),
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
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(" ${dicas.description}",
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
    );
  }
}
