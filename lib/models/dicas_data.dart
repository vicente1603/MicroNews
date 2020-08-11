import 'package:cloud_firestore/cloud_firestore.dart';

class DicasData{

  String category;
  String id;
  String title;
  String description;
  List<dynamic> usuarios_like;
  int likes;

  DicasData.fromDocument(DocumentSnapshot snapshot){

    id = snapshot.documentID;
    title = snapshot.data["title"];
    description = snapshot.data["description"];
    usuarios_like = snapshot.data["usuarios_like"];
    likes = snapshot.data["likes"];

  }

}