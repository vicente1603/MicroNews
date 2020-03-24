import 'package:chat_online/data/dicas_data.dart';
import 'package:chat_online/data/home_data.dart';
import 'package:flutter/material.dart';

class HomeDetailTile extends StatelessWidget {
  final String type;
  final HomeData eventos;

  HomeDetailTile(this.type, this.eventos);

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
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(" ${eventos.description}",
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
      ),
    );
  }
}
