import 'package:micro_news/screens/dicas_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:micro_news/screens/jogos_screen.dart';

class JogosTile extends StatelessWidget {
  final DocumentSnapshot snapshot;

  JogosTile(this.snapshot);

  @override
  Widget build(BuildContext context) {
    String link = snapshot.data["link"];
    String title = snapshot.data["title"];
    String icon = snapshot.data["icon"];

    return Card(
        elevation: 1.0,
        margin: new EdgeInsets.all(8.0),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
          decoration: BoxDecoration(color: Colors.blueAccent),
          child: new InkWell(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => JogosScreen(link, title)));
            },            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                SizedBox(height: 20.0),
                Center(child: Image.network(icon,height: 100.0,)),
                SizedBox(height: 10.0),
                new Center(
                  child: new Text(title,
                      style:
                          new TextStyle(fontSize: 25.0, color: Colors.white)),
                )
              ],
            ),
          ),
        ));
  }
}
