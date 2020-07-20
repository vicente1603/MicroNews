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
  List<charts.Series<Imc, String>> _seriesBarData;
  List<Imc> mydata;

  _generateData(mydata) {
    _seriesBarData = List<charts.Series<Imc, String>>();

    _seriesBarData.add(
      charts.Series(
        domainFn: (Imc sales, _) => converterTimestamp(sales.data),
        measureFn: (Imc sales, _) => sales.imc,
        colorFn: (Imc sales, _) => sales.imc < 18.6
            ? charts.ColorUtil.fromDartColor(Colors.red[400])
            : sales.imc >= 18.6 && sales.imc < 24.9
                ? charts.ColorUtil.fromDartColor(Colors.green[600])
                : sales.imc >= 24.9 && sales.imc < 29.9
                    ? charts.ColorUtil.fromDartColor(Colors.yellow[600])
                    : sales.imc >= 29.9 && sales.imc < 34.9
                        ? charts.ColorUtil.fromDartColor(Colors.red[600])
                        : sales.imc >= 34.9 && sales.imc < 39.9
                            ? charts.ColorUtil.fromDartColor(Colors.red[700])
                            : sales.imc > 40
                                ? charts.ColorUtil.fromDartColor(
                                    Colors.red[800])
                                : charts.ColorUtil.fromDartColor(
                                    Colors.blueAccent),
        id: 'Imcs',
        data: mydata,
        labelAccessorFn: (Imc row, _) => "${row.info}",
      ),
    );
  }

  Widget _buildBody(BuildContext context, uid) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection("users")
          .document(uid)
          .collection("desenvolvimento_infantil")
          .document("imc")
          .collection("imcs")
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          List<Imc> sales = snapshot.data.documents
              .map((documentSnapshot) => Imc.fromMap(documentSnapshot.data))
              .toList();
          return _buildChart(context, sales);
        }
      },
    );
  }

  Widget _buildChart(BuildContext context, List<Imc> saledata) {
    mydata = saledata;
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
                child: charts.BarChart(
                  _seriesBarData,
                  animate: true,
                  animationDuration: Duration(seconds: 5),
                  behaviors: [
                    new charts.DatumLegend(
                      entryTextStyle: charts.TextStyleSpec(
                          color: charts.MaterialPalette.purple.shadeDefault,
                          fontFamily: 'Georgia',
                          fontSize: 18),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

String converterTimestamp(int timestamp) {
  var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  var formattedDate = DateFormat("dd/MM/yyyy").format(date); // 16/07/2020
  var time = '';

  time = formattedDate;
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
      .getDocuments();

  return qn.documents;
}
