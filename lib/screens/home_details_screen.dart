import 'package:chat_online/data/dicas_data.dart';
import 'package:chat_online/tiles/dicas_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeDetailScreen extends StatelessWidget {
  final DocumentSnapshot snapshot;

  HomeDetailScreen(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(snapshot.data["title"]),
          backgroundColor: Colors.blueAccent,
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Colors.blueAccent,
            Colors.white,
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: FutureBuilder<QuerySnapshot>(
              future: Firestore.instance
                  .collection("home")
                  .document(snapshot.documentID)
                  .collection("eventos")
                  .getDocuments(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());
                else
                  return ListView.builder(
                    padding: EdgeInsets.all(4.0),
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      return DicasTile(
                          "list",
                          DicasData.fromDocument(
                              snapshot.data.documents[index]));
                    },
                  );
              }),
        ));
  }
}
