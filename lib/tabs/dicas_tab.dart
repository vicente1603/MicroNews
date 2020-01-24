import 'package:chat_online/tiles/category_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DicasTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: Firestore.instance.collection("dicas").getDocuments(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator(),);
        }else{
          return ListView(
            children: snapshot.data.documents.map((doc){
              return CategoryTile(doc);
            }).toList(),
          );
        }
      },
    );
  }
}
