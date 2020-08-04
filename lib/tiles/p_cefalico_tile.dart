import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListTilePCefalico extends StatefulWidget {
  String id;
  double diametro;
  int data;

  ListTilePCefalico(this.id, this.diametro, this.data);

  @override
  _ListTilePCefalicoState createState() => _ListTilePCefalicoState();
}

class _ListTilePCefalicoState extends State<ListTilePCefalico> {
  String id;
  double diametro;
  int data;

  @override
  void initState() {
    id = widget.id;
    diametro = widget.diametro;
    data = widget.data;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _data = converterTimestamp(data);

    return ListTile(
        contentPadding: EdgeInsets.only(top: 5, left: 10),
        title: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Diâmetro: $diametro cm"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Text(
                    "Data: $_data",
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  String converterTimestamp(int timestamp) {
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var formattedDate = DateFormat("dd/MM/yyyy").format(date); // 16/07/2020
    var time = formattedDate;

    return time;
  }
}
