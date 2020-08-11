import 'package:cloud_firestore/cloud_firestore.dart';

class ExerciciosData{

  String id;
  String title;
  String description;
  String image;

  ExerciciosData.fromDocument(DocumentSnapshot snapshot){
    id = snapshot.documentID;
    title = snapshot.data["title"];
    description = snapshot.data["description"];
    image = snapshot.data["image"];
  }

}