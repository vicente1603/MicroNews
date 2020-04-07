import 'package:micro_news/data/consultas_data.dart';
import 'package:micro_news/models/user_model.dart';
import 'package:micro_news/screens/nova_consulta_screen.dart';
import 'package:micro_news/tiles/consultas_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ConsultasTab extends StatelessWidget {
  final DocumentSnapshot snapshot;

  ConsultasTab(this.snapshot);

  static String userID = "";

  @override
  Widget build(BuildContext context) {
    if (UserModel.of(context).isLoggedIn()) {
      String uid = UserModel.of(context).firebaseUser.uid;

      return Scaffold(
          body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Colors.blueAccent,
              Colors.white,
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            child: FutureBuilder<QuerySnapshot>(
                future: Firestore.instance
                    .collection("users")
                    .document(uid)
                    .collection("consultas")
                    .getDocuments(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(child: CircularProgressIndicator());
                  else
                    return ListView.builder(
                      padding: EdgeInsets.all(4.0),
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        return ConsultasTile(
                            "list",
                            ConsultasData.fromDocument(
                                snapshot.data.documents[index]));
                      },
                    );
                }),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NovaConsultaScreen()));
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.blueAccent,
          ));
    }
  }

  void readDataUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    userID = user.uid;
  }
}
