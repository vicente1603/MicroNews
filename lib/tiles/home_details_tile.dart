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
        height: 120.0,
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
                        height: 124.0,
                        margin: new EdgeInsets.only(left: 46.0),
                        decoration: new BoxDecoration(
                          color: Colors.black45,
                          shape: BoxShape.rectangle,
                          borderRadius: new BorderRadius.circular(8.0),
                          boxShadow: <BoxShadow>[
                            new BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10.0,
                              offset: new Offset(0.0, 10.0),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(top: 16.0, left: 16.0),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(" ${eventos.description}",
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                        textAlign: TextAlign.center),
                                  )
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text("0",
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                          textAlign: TextAlign.center),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )),
                  )
                ],
              ),
            ),
            Container(
                alignment: FractionalOffset.centerLeft,
                child: new Container(
                  decoration: const ShapeDecoration(
                      color: Colors.lightBlue, shape: CircleBorder()),
                  margin: EdgeInsets.all(20),
                  child: IconButton(
                    icon: Icon(Icons.add),
                    color: Colors.white,
                    onPressed: () {},
                  ),
                )),
          ],
        ));
  }
}
