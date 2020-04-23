import 'package:cloud_firestore/cloud_firestore.dart';

class HomeData{

  int marcacao;
  String description;
  String id;
  List eventos;

  HomeData.fromDocument(DocumentSnapshot snapshot){
    description = snapshot.data["description"];
    marcacao = snapshot.data["marcacoes"];
    id = snapshot.data["id"];
  }

}