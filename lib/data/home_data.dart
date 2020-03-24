import 'package:cloud_firestore/cloud_firestore.dart';

class HomeData{

  String titulo;
  String descricao;

  HomeData.fromDocument(DocumentSnapshot snapshot){
    titulo = snapshot.data["title"];
    descricao = snapshot.data["title"];
  }

}