import 'package:chat_online/data/home_data.dart';
import 'package:chat_online/screens/detalhes_eventos.dart';
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
            )),
        new Padding(
          padding: const EdgeInsets.only(right: 10.0, left: 70.0, top: 60.0),
          child: new Container(
            height: 100.0,
            color: Colors.black45,
            child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailEvent()));                },
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                leading: Container(
                  padding: EdgeInsets.only(right: 12.0),
                  decoration: new BoxDecoration(
                      border: new Border(
                          right: new BorderSide(
                              width: 1.0, color: Colors.white24))),
                  child: Image.network("https://img.icons8.com/dusk/2x/babys-room.png"),
                ),
                title: Text(
                  "${home.title}",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                subtitle: Row(
                  children: <Widget>[
                    Icon(Icons.linear_scale, color: Colors.blueAccent),
                    Text(" Nº de eventos: 3",
                        style: TextStyle(color: Colors.white))
                  ],
                ),
                trailing: Icon(Icons.keyboard_arrow_right,
                    color: Colors.white, size: 30.0)),
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
