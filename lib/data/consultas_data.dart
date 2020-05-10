import 'package:cloud_firestore/cloud_firestore.dart';

class ConsultasData{

  String id;
  String titulo;
  String descricao;
  String local;
  String data;
  String horario;

  ConsultasData.fromDocument(DocumentSnapshot snapshot){
    id = snapshot.documentID;
    titulo = snapshot.data["titulo"];
    descricao = snapshot.data["descricao"];
    local = snapshot.data["local"];
    data = snapshot.data["data"];
    horario = snapshot.data["horario"];
  }

}