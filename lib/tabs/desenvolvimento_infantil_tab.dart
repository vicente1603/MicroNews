import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:micro_news/models/imc_model.dart';
import 'package:micro_news/models/usuario_model.dart';
import 'package:micro_news/screens/registro_imc_screen.dart';
import 'package:micro_news/tiles/imc_tile.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class DesenvolvimentoInfantilTab extends StatefulWidget {
  @override
  _DesenvolvimentoInfantilTabState createState() =>
      _DesenvolvimentoInfantilTabState();
}

class _DesenvolvimentoInfantilTabState
    extends State<DesenvolvimentoInfantilTab> {
  Function(DateTime) onItemClicked;
  List<charts.Series<Imc, DateTime>> _seriesLineIMCData;

//  List<charts.Series<Imc, DateTime>> _seriesLineData1;
  List<charts.Series> seriesList;
  List<Imc> mydata;

  _generateData(mydata) {
    _seriesLineIMCData = List<charts.Series<Imc, DateTime>>();
    _seriesLineIMCData.add(
      charts.Series<Imc, DateTime>(
        id: 'Imc',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (Imc sales, _) =>
            DateTime.parse(converterTimestampChart(sales.data)),
        measureFn: (Imc sales, _) => sales.imc,
        data: mydata,
      ),
    );

//    _seriesLineData.add(
//      charts.Series<Imc, DateTime>(
//        id: 'Altura',
//        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
//        domainFn: (Imc sales, _) =>
//            DateTime.parse(converterTimestamp(sales.data)),
//        measureFn: (Imc sales, _) => sales.altura,
//        data: mydata,
//      ),
//    );
//
//    _seriesLineData.add(
//      charts.Series<Imc, DateTime>(
//        id: 'Peso',
//        colorFn: (_, __) => charts.MaterialPalette.deepOrange.shadeDefault,
//        domainFn: (Imc sales, _) =>
//            DateTime.parse(converterTimestamp(sales.data)),
//        measureFn: (Imc sales, _) => sales.peso,
//        data: mydata,
//      ),
//    );

//    _seriesLineData1 = List<charts.Series<Imc, DateTime>>();
//    _seriesLineData1.add(
//      charts.Series<Imc, DateTime>(
//        id: 'Imc',
//        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
//        domainFn: (Imc sales, _) =>
//            DateTime.parse(converterTimestamp(sales.data)),
//        measureFn: (Imc sales, _) => sales.altura,
//        data: mydata,
//      ),
//    );
  }

  Widget _buildBody(BuildContext context, uid) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection("users")
          .document(uid)
          .collection("desenvolvimento_infantil")
          .document("imc")
          .collection("imcs")
          .orderBy("data")
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          List<Imc> imcs = snapshot.data.documents
              .map((documentSnapshot) => Imc.fromMap(documentSnapshot.data))
              .toList();
          return _buildChart(context, imcs);
        }
      },
    );
  }

  showAlertDialog(BuildContext context, data, peso, altura, imc, info) {
    // configura o button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    AlertDialog alerta = AlertDialog(
      scrollable: true,
      title: Text("Dados"),
      content: Column(
        children: <Widget>[
          Row(
            children: <Widget>[Text("Data: $data")],
          ),
          Row(
            children: <Widget>[Text("Peso: $peso")],
          ),
          Row(
            children: <Widget>[Text(" Altura: $altura")],
          ),
          Row(
            children: <Widget>[Text("Imc: " + imc.toStringAsPrecision(3))],
          ),
          Row(
            children: <Widget>[
              Expanded(child: Text("Classificação de risco: $info"))
            ],
          ),
        ],
      ),
      actions: [
        okButton,
      ],
    );
    // exibe o dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alerta;
      },
    );
  }

  _onSelectionChanged(charts.SelectionModel<DateTime> model) {
    var data = converterTimestamp(model.selectedDatum.first.datum.data);
    var peso = model.selectedDatum.first.datum.peso;
    var altura = model.selectedDatum.first.datum.altura;
    var imc = model.selectedDatum.first.datum.imc;
    var info = model.selectedDatum.first.datum.info;

    showAlertDialog(context, data, peso, altura, imc, info);
  }

  Widget _buildChart(BuildContext context, List<Imc> data) {
    mydata = data;
    _generateData(mydata);
    return Padding(
        padding: EdgeInsets.all(8.0),
        child: Container(
          child: Center(
            child: Column(
              children: <Widget>[
                Text(
                  'IMC',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Expanded(
                  child: charts.TimeSeriesChart(
                    _seriesLineIMCData,
                    defaultRenderer: new charts.LineRendererConfig(
                        includeArea: true, stacked: true),
                    animationDuration: Duration(seconds: 2),
                    dateTimeFactory: charts.LocalDateTimeFactory(),
                    animate: true,
                    behaviors: [
                      new charts.ChartTitle("Data",
                          behaviorPosition: charts.BehaviorPosition.bottom,
                          titleOutsideJustification:
                              charts.OutsideJustification.middleDrawArea),
                      new charts.ChartTitle("IMC",
                          behaviorPosition: charts.BehaviorPosition.start,
                          titleOutsideJustification:
                              charts.OutsideJustification.middleDrawArea),
                    ],
                    selectionModels: [
                      charts.SelectionModelConfig(
                          type: charts.SelectionModelType.info,
                          changedListener: _onSelectionChanged)
                    ],
                  ),
                ),
//                Text(
//                  'Circunferência',
//                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
//                ),
//                SizedBox(
//                  height: 10.0,
//                ),
//                Expanded(
//                  child: charts.TimeSeriesChart(
//                    _seriesLineData1,
//                    animationDuration: Duration(seconds: 2),
//                    dateTimeFactory: charts.LocalDateTimeFactory(),
//                    animate: true,
////                  selectionModels: [
////                    charts.SelectionModelConfig(
////                        type: charts.SelectionModelType.info,
////                        changedListener: _onSelectionChanged)
////                  ],
//                  ),
//                ),
              ],
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    String id;
    double altura;
    double peso;
    double imc;
    String info;
    int data;

    if (UserModel.of(context).isLoggedIn()) {
      var uid = UserModel.of(context).firebaseUser.uid;
      return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blueAccent,
            elevation: 0,
            title: TabBar(
              indicatorColor: Colors.white,
              indicatorWeight: 2,
              tabs: <Widget>[
                Tab(text: "Gráfico"),
                Tab(text: "Lista"),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              //Gráficos
              Scaffold(
                  body: _buildBody(context, uid),
                  floatingActionButton: FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => RegistroImcScreen()));
                    },
                  )),
              //Lista
              Scaffold(
                body: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: FutureBuilder(
                            future: getImcs(uid),
                            builder: (_, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return new Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.data.length == 0) {
                                return Container(
                                  color: Color(0xFFF6F8FC),
                                  child: Center(
                                    child: Text(
                                      "Toque no + para adicionar um imc",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 24,
                                          color: Colors.blueAccent,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                );
                              } else {
                                return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (_, index) {
                                      id = snapshot.data[index].data["id"];
                                      peso = snapshot.data[index].data["peso"];
                                      altura =
                                          snapshot.data[index].data["altura"];
                                      imc = snapshot.data[index].data["imc"];
                                      info = snapshot.data[index].data["info"];
                                      data = snapshot.data[index].data["data"];
                                      return Container(
                                        height: 120,
                                        margin:
                                            EdgeInsets.fromLTRB(20, 0, 20, 15),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            stops: [0.015, 0.015],
                                            colors: [
                                              Colors.blueAccent,
                                              Colors.blueAccent
                                            ],
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5.0),
                                          ),
                                        ),
                                        child: Card(
                                          child: ListTileImc(id, peso, altura,
                                              imc, info, data),
                                        ),
                                      );
                                    });
                              }
                            }),
                      ),
                    ]),
                floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => RegistroImcScreen()));
                  },
                ),
              )
            ],
          ),
        ),
      );
    }
  }
}

String converterTimestampChart(int timestamp) {
  var date = DateTime.fromMillisecondsSinceEpoch(timestamp).toString();
  return date;
}

String converterTimestamp(int timestamp) {
  var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  var formattedDate = DateFormat("dd/MM/yyyy").format(date); // 16/07/2020
  var time = formattedDate;

  return time;
}

Future getImcs(uid) async {
  var firestore = Firestore.instance;

  QuerySnapshot qn = await firestore
      .collection("users")
      .document(uid)
      .collection("desenvolvimento_infantil")
      .document("imc")
      .collection("imcs")
      .orderBy("data")
      .getDocuments();

  return qn.documents;
}
