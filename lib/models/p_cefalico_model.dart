
class PCefalico {
  final String id;
  final double diametro;
  final int data;

  PCefalico(this.id, this.diametro, this.data);

  PCefalico.fromMap(Map<String, dynamic> map)
      : assert(map['id'] != null),
        assert(map['diametro'] != null),
        assert(map['data'] != null),
        id = map['id'],
        diametro = map['diametro'],
        data = map['data'];
}
