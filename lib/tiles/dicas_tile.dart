import 'package:chat_online/data/dicas_data.dart';
import 'package:flutter/material.dart';

class DicasTile extends StatelessWidget {
  final String type;
  final DicasData dicas;

  DicasTile(this.type, this.dicas);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        child: Row(
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Text(" ${dicas.title}: ${dicas.description}"),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
