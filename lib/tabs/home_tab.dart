import 'package:micro_news/data/consultas_data.dart';
import 'package:micro_news/data/home_data.dart';
import 'package:micro_news/tiles/consultas_tile.dart';
import 'package:micro_news/tiles/home_tile.dart';
import 'package:micro_news/widgets/custom_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeTab extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Future<bool> _onBackPressed() {
      return showDialog(
            context: context,
            builder: (context) => new AlertDialog(
              title: new Text('Tem certeza??'),
              content: new Text('Deseja sair do aplicativo?'),
              actions: <Widget>[
                new GestureDetector(
                  onTap: () => Navigator.of(context).pop(false),
                  child: Text("NÃO"),
                ),
                SizedBox(height: 16),
                new GestureDetector(
                  onTap: () => Navigator.of(context).pop(true),
                  child: Text("SIM"),
                ),
              ],
            ),
          ) ??
          false;
    }

    return new WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Colors.blueAccent,
              Colors.white,
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            child: FutureBuilder<QuerySnapshot>(
              future: Firestore.instance
                  .collection("home")
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
                      return HomeTile(doc);
                    }).toList(),
                  );
                }
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => launch("tel://192"),
            child: Icon(Icons.local_hospital),
            backgroundColor: Colors.red,
          ),
        ));
  }
}
