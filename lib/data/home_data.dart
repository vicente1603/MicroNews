import 'package:cloud_firestore/cloud_firestore.dart';

class HomeData{

  int marcacao;
  String description;
  List eventos;

  HomeData.fromDocument(DocumentSnapshot snapshot){
    description = snapshot.data["description"];
    marcacao = snapshot.data["marcacoes"];
  }

}