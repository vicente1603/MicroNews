import 'package:cloud_firestore/cloud_firestore.dart';

class HomeData{

  int marcacao;
  String description;
  String id;
  List eventos;
  List<dynamic> usuarios_like;
  List<dynamic> usuarios_deslike;

  HomeData.fromDocument(DocumentSnapshot snapshot){
    description = snapshot.data["description"];
    marcacao = snapshot.data["marcacoes"];
    id = snapshot.data["id"];
    usuarios_like = snapshot.data["usuarios_like"];
    usuarios_deslike = snapshot.data["usuarios_deslike"];
  }

}