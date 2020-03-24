import 'package:chat_online/data/consultas_data.dart';
import 'package:chat_online/data/home_data.dart';
import 'package:chat_online/screens/nova_consulta_screen.dart';
import 'package:chat_online/tiles/consultas_tile.dart';
import 'package:chat_online/tiles/home_tile.dart';
import 'package:chat_online/widgets/custom_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.blueAccent,
              Colors.white,
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: FutureBuilder<QuerySnapshot>(
            future: Firestore.instance
                .collection("home")
                .orderBy("title")
                .getDocuments(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());
              else
                return ListView.builder(
                  padding: EdgeInsets.all(4.0),
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    return HomeTile(
                        "list",
                        HomeData.fromDocument(
                            snapshot.data.documents[index]));
                  },
                );
            }),
      ),
    );
  }
}
