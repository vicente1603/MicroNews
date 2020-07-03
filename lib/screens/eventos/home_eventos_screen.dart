import 'package:micro_news/data/dicas_data.dart';
import 'package:micro_news/data/home_data.dart';
import 'package:micro_news/tiles/dicas_tile.dart';
import 'package:micro_news/tiles/home_details_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeEventosScreen extends StatelessWidget {
  final DocumentSnapshot snapshot;
  String docHome;
  String docFaixas;

  HomeEventosScreen(this.snapshot, this.docHome);

  @override
  Widget build(BuildContext context) {
    String docFaixas = snapshot.documentID;

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
                  .document(docHome)
                  .collection("faixas")
                  .document(docFaixas)
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
                      return HomeDetailTile(
                          docHome,
                          docFaixas,
                          "list",
                          HomeData.fromDocument(
                              snapshot.data.documents[index]));
                    },
                  );
              }),
        ));
  }
}
