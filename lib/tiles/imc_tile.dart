import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListTileImc extends StatefulWidget {
  String id;
  double peso;
  double altura;
  double imc;
  String info;
  int data;

  ListTileImc(this.id, this.peso, this.altura, this.imc, this.info, this.data);

  @override
  _ListTileImcState createState() => _ListTileImcState();
}

class _ListTileImcState extends State<ListTileImc> {
  String id;
  double peso;
  double altura;
  double imc;
  String info;
  int data;

  @override
  void initState() {
    id = widget.id;
    peso = widget.peso;
    altura = widget.altura;
    imc = widget.imc;
    info = widget.info;
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
                Text("Peso: $peso kg"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Altura: $altura cm"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Imc: " + imc.toStringAsPrecision(3)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Text(
                    "Info: $info",
                    textAlign: TextAlign.center,
                  ),
                ),
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
    var now = new DateTime.now();
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var formattedDate = DateFormat("dd/MM/yyyy").format(date); // 16/07/2020
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = formattedDate;
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + ' DAY AGO';
      } else {
        time = diff.inDays.toString() + ' DAYS AGO';
      }
    } else {
      if (diff.inDays == 7) {
        time = (diff.inDays / 7).floor().toString() + ' WEEK AGO';
      } else {
        time = (diff.inDays / 7).floor().toString() + ' WEEKS AGO';
      }
    }

    return time;
  }

}