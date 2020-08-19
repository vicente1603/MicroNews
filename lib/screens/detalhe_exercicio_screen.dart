import 'package:flutter/material.dart';
import 'package:share/share.dart';

class DetalheExercicioScreen extends StatelessWidget {
  String title;
  String description;

  DetalheExercicioScreen(this.title, this.description);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(title),
        actions: <Widget>[
          FlatButton(
            child: IconButton(
              icon: Icon(Icons.share, color: Colors.white),
            ),
            textColor: Colors.white,
            onPressed: () {
              final RenderBox box = context.findRenderObject();

              Share.share(title.toUpperCase() + ": \n \n" + description,
                  sharePositionOrigin:
                  box.localToGlobal(Offset.zero) & box.size);
            },
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Colors.blueAccent,
          Colors.white,
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        padding: new EdgeInsets.symmetric(horizontal: 32.0),
        child: ListView(
          padding: new EdgeInsets.fromLTRB(0.0, 32.0, 0.0, 32.0),
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text("Descrição:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    )),
                Separator(),
                new Text(
                  description,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.justify,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Separator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
        margin: new EdgeInsets.symmetric(vertical: 8.0),
        height: 2.0,
        width: 18.0,
        color: Colors.deepOrange);
  }
}
