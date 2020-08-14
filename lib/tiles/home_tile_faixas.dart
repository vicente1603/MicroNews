import 'package:micro_news/screens/eventos/home_details_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:micro_news/screens/eventos/home_eventos_screen.dart';

class HomeTileFaixas extends StatelessWidget {
  final DocumentSnapshot snapshot;
  String docHome;

  HomeTileFaixas(this.snapshot, this.docHome);

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
            )),
        new Padding(
          padding: const EdgeInsets.only(right: 10.0, left: 70.0, top: 60.0, bottom: 20.0),
          child: new Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.black45),
            child: ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          HomeEventosScreen(snapshot, docHome)));
                },
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                leading: Container(
                  padding: EdgeInsets.only(right: 12.0),
                  decoration: new BoxDecoration(
                      border: new Border(
                          right: new BorderSide(
                              width: 1.0, color: Colors.white24))),
                  child: Image.network(snapshot.data["icon"]),
                ),
                title: Align(
                    alignment: Alignment.center,
                    child: Text(
                      snapshot.data["title"],
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )),
                // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
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
        if (snapshot.data["color"] == "green")
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
                    shape: BoxShape.circle, color: Colors.green),
              ),
            ),
          )
        else if (snapshot.data["color"] == "orange")
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
                    shape: BoxShape.circle, color: Colors.orangeAccent),
              ),
            ),
          )
        else if (snapshot.data["color"] == "pink")
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
                    shape: BoxShape.circle, color: Colors.pinkAccent),
              ),
            ),
          )
        else if (snapshot.data["color"] == "purple")
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
                    shape: BoxShape.circle, color: Colors.deepPurpleAccent),
              ),
            ),
          )
        else if (snapshot.data["color"] == "red")
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
                    shape: BoxShape.circle, color: Colors.redAccent),
              ),
            ),
          )
        else if (snapshot.data["color"] == "indigo")
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
                    shape: BoxShape.circle, color: Colors.indigoAccent),
              ),
            ),
          )
        else
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
