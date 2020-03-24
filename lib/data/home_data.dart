import 'package:cloud_firestore/cloud_firestore.dart';

class HomeData{

  String title;
  String description;
  List eventos;

  HomeData.fromDocument(DocumentSnapshot snapshot){
    title = snapshot.data["title"];
    description = snapshot.data["description"];
  }

}