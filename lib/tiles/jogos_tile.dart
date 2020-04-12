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

    return ListTile(
      leading: CircleAvatar(
        radius: 25.0,
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage(snapshot.data["icon"]),
      ),
      title: Text(snapshot.data["title"], textAlign: TextAlign.center,),
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => JogosScreen(link, title)));
      },
    );
  }
}
