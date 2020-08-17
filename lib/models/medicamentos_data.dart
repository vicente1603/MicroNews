import 'package:cloud_firestore/cloud_firestore.dart';

class MedicamentosData{

  String id;
  List<dynamic> idsNotificacoes;
  String nomeMedicamento;
  int dosagem;
  String tipoMedicamento;
  int intervalo;
  String horaInicio;

  MedicamentosData.fromDocument(DocumentSnapshot snapshot){
    id = snapshot.documentID;
    idsNotificacoes = snapshot.data["idsNotificacoes"];
    nomeMedicamento = snapshot.data["nomeMedicamento"];
    dosagem = snapshot.data["dosagem"];
    tipoMedicamento = snapshot.data["tipoMedicamento"];
    intervalo = snapshot.data["intervalo"];
    horaInicio = snapshot.data["horaInicio"];
  }

}