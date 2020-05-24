import 'package:firebase_helpers/firebase_helpers.dart';

class EventModel extends DatabaseItem {
  final String id;
  final String titulo;
  final String descricao;
  final String local;
  final DateTime data;
  final String horario;

  EventModel(
      {this.id,
      this.titulo,
      this.descricao,
      this.local,
      this.data,
      this.horario})
      : super(id);

  factory EventModel.fromMap(Map data) {
    return EventModel(
      titulo: data['titulo'],
      descricao: data['descricao'],
      local: data['local'],
      data: data['data'],
      horario: data['horario'],
    );
  }

  factory EventModel.fromDS(String id, Map<String, dynamic> data) {
    return EventModel(
        id: id,
        titulo: data['titulo'],
        descricao: data['descricao'],
        local: data['local'],
        data: data['data'].toDate(),
        horario: data['horario']);
  }

  Map<String, dynamic> toMap() {
    return {
      "titulo": titulo,
      "descricao": descricao,
      "local": local,
      "data": data,
      "horario": horario,
      "id": id,
    };
  }
}
