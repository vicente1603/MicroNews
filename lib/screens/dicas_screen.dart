import 'package:chat_online/data/dicas_data.dart';
import 'package:chat_online/tiles/dicas_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DicasScreen extends StatelessWidget {
  final DocumentSnapshot snapshot;

  DicasScreen(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(snapshot.data["title"]),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body:
      Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.blueAccent,
              Colors.white,
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: FutureBuilder<QuerySnapshot>(
            future: Firestore.instance
                .collection("dicas")
                .document(snapshot.documentID)
                .collection("items")
                .getDocuments(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());
              else
                return ListView.builder(
                  padding: EdgeInsets.all(4.0),
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index){
                    return DicasTile("list", DicasData.fromDocument(snapshot.data.documents[index]));
                  },
                );

//              return GridView.builder(
//                  padding: EdgeInsets.all(4.0),
//                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                      crossAxisCount: 2,
//                      mainAxisSpacing: 4.0,
//                      crossAxisSpacing: 4.0,
//                      childAspectRatio: 0.65),
//                  itemCount: snapshot.data.documents.length,
//                  itemBuilder: (context, index){
//                    return DicasTile("grid", DicasData.fromDocument(snapshot.data.documents[index]));
//                  });
            }),
      )
    );
  }
}
