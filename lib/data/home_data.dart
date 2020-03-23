import 'package:cloud_firestore/cloud_firestore.dart';

class HomeData{

  String titulo;

  HomeData.fromDocument(DocumentSnapshot snapshot){
    titulo = snapshot.data["title"];
  }

}