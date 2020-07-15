import 'package:micro_news/models/dicas_data.dart';
import 'package:micro_news/tiles/dicas_tile.dart';
import 'package:micro_news/tiles/home_details_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:micro_news/tiles/home_tile.dart';
import 'package:micro_news/tiles/home_tile_faixas.dart';

class HomeDetailScreen extends StatelessWidget {
  final DocumentSnapshot snapshot;

  HomeDetailScreen(this.snapshot);

  @override
  Widget build(BuildContext context) {

    String docHome = snapshot.documentID;

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
                  .collection("faixas")
                  .orderBy("id")
                  .getDocuments(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView(
                  children: snapshot.data.documents.map((doc) {
                    return HomeTileFaixas(doc, docHome);
                  }).toList(),
                );
              }
            },
              ),
        ));
  }
}

//builder: (context, snapshot) {
//if (!snapshot.hasData)
//return Center(child: CircularProgressIndicator());
//else
//return ListView.builder(
//padding: EdgeInsets.all(4.0),
//itemCount: snapshot.data.documents.length,
//itemBuilder: (context, index) {
//return HomeDetailTile(
//"list",
//HomeData.fromDocument(
//snapshot.data.documents[index]));
//},
//);
//}
