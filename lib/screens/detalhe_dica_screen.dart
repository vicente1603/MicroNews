import 'package:flutter/material.dart';
import 'package:share/share.dart';

class DetalheDicaScreen extends StatelessWidget {
  String title;
  String description;

  DetalheDicaScreen(this.title, this.description);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(title),
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
                ),
                const Padding(padding: EdgeInsets.only(top: 24.0)),
                Builder(
                  builder: (BuildContext context) {
                    return RaisedButton(
                      child: const Text('Share'),
                      onPressed: () {
                        // A builder is used to retrieve the context immediately
                        // surrounding the RaisedButton.
                        //
                        // The context's `findRenderObject` returns the first
                        // RenderObject in its descendent tree when it's not
                        // a RenderObjectWidget. The RaisedButton's RenderObject
                        // has its position and size after it's built.
                        final RenderBox box = context.findRenderObject();

                        Share.share(title,
                            subject: description,
                            sharePositionOrigin:
                            box.localToGlobal(Offset.zero) & box.size);
                      },
                    );
                  },
                ),
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
