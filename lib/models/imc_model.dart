import 'package:cloud_firestore/cloud_firestore.dart';

class Imc {
  final String id;
  final double peso;
  final double altura;
  final double imc;
  final String info;
  final int data;
//  final int cor;

  Imc(this.id, this.peso, this.altura, this.imc, this.info, this.data);

  Imc.fromMap(Map<String, dynamic> map)
      : assert(map['id'] != null),
        assert(map['peso'] != null),
        assert(map['altura'] != null),
        assert(map['imc'] != null),
        assert(map['info'] != null),
        assert(map['data'] != null),
//        assert(map['cor'] != null),
        id = map['id'],
        peso = map['peso'],
        altura = map['altura'],
        imc = map['imc'],
        info = map['info'],
        data = map['data'];
//        cor = map['cor'];

//  @override
//  String toString() => "Record<$taskVal:$taskDetails>";
}
