import 'package:micro_news/data/consultas_data.dart';
import 'package:flutter/material.dart';

class ConsultasTile extends StatelessWidget {
  final String type;
  final ConsultasData consultas;

  ConsultasTile(this.type, this.consultas);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        child: Row(
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text("${consultas.titulo}",
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text("${consultas.descricao}",
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text("${consultas.local}",
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text("${consultas.data}",
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text("${consultas.horario}",
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center),
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.edit),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
