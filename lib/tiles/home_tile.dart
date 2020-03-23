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
          child: new Card(
            margin: new EdgeInsets.all(20.0),
            child: new Container(
              width: double.infinity,
              height: 200.0,
              color: Colors.white,
              child: Text("${home.titulo}"),
            ),
          ),
        ),
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
