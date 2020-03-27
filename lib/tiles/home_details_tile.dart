import 'package:chat_online/data/dicas_data.dart';
import 'package:chat_online/data/home_data.dart';
import 'package:flutter/material.dart';

class HomeDetailTile extends StatelessWidget {
  final String type;
  final HomeData eventos;

  HomeDetailTile(this.type, this.eventos);

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
                                            color: Colors.black),
                                        textAlign: TextAlign.center),
                                  )
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    IconButton(
                                      icon:
                                          Icon(Icons.outlined_flag, size: 40.0),
                                      color: Colors.black,
                                      onPressed: () {},
                                    ),
                                    Text("0",
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black)),
                                  ],
                                ),
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
