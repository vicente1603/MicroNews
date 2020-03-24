import 'package:chat_online/data/home_data.dart';
import 'package:flutter/material.dart';

class HomeTile extends StatelessWidget {
  final String type;
  final HomeData home;

  HomeTile(this.type, this.home);

  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        new Padding(
            padding: const EdgeInsets.only(left: 50.0),
            child: new Container(
              margin: const EdgeInsets.only(
                top: 16.0,
                bottom: 16.0,
                left: 24.0,
                right: 24.0,
              ),
              width: double.infinity,
              height: 200.0,
              child: Card(
                color: Colors.white70,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 10,
                child: Padding(
                  padding: EdgeInsets.all(7),
                  child: Stack(children: <Widget>[
                    Align(
                      alignment: Alignment.centerRight,
                      child: Stack(
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.only(left: 10, top: 5),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        "${home.titulo}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0),
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  ),

                                ],
                              ))
                        ],
                      ),
                    )
                  ]),
                ),
              ),
            )),
        new Positioned(
          top: 0.0,
          bottom: 0.0,
          left: 35.0,
          child: new Container(
            height: double.infinity,
            width: 1.0,
            color: Colors.black,
          ),
        ),
        new Positioned(
          top: 100.0,
          left: 15.0,
          child: new Container(
            height: 40.0,
            width: 40.0,
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: new Container(
              margin: new EdgeInsets.all(5.0),
              height: 30.0,
              width: 30.0,
              decoration: new BoxDecoration(
                  shape: BoxShape.circle, color: Colors.blueAccent),
            ),
          ),
        )
      ],
    );
  }
}
