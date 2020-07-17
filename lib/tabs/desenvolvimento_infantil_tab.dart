import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart' as intl;
import 'dart:async';
import 'package:bezier_chart/bezier_chart.dart';
import 'package:flutter/material.dart';
import 'package:micro_news/models/usuario_model.dart';
import 'package:micro_news/screens/registro_imc_screen.dart';
import 'package:micro_news/tiles/imc_tile.dart';

class DesenvolvimentoInfantilTab extends StatefulWidget {
  @override
  _DesenvolvimentoInfantilTabState createState() =>
      _DesenvolvimentoInfantilTabState();
}

class _DesenvolvimentoInfantilTabState
    extends State<DesenvolvimentoInfantilTab> {
  String id;
  double altura;
  double peso;
  double imc;
  String info;
  int data;

  List<DataPoint> _items;
  List<double> _xAxis;

  void _loadData() async {
    await Future.delayed(Duration(seconds: 3));
    final String data =
        '[{"Day":1,"Value":"5"},{"Day":2,"Value":"2"},{"Day":3,"Value":"6"},{"Day":4,"Value":"8"}]';


    final List list = json.decode(data);

    setState(() {
      _items = list
          .map((item) =>
          DataPoint(
              value: double.parse(item["Value"].toString()),
              xAxis: double.parse(item["Day"].toString())))
          .toList();
      _xAxis =
          list.map((item) => double.parse(item["Day"].toString())).toList();
    });
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (UserModel.of(context).isLoggedIn()) {
      var uid = UserModel
          .of(context)
          .firebaseUser
          .uid;
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
                body: SingleChildScrollView(
                  child: _items != null
                      ? Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.blueAccent, Colors.white])),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 10),
                        Text(
                          "IMC",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Center(
                          child: Card(
                            elevation: 10,
                            margin: EdgeInsets.all(25.0),
                            child: Container(
                              color: Colors.lightBlue[900],
                              height:
                              MediaQuery
                                  .of(context)
                                  .size
                                  .height / 2,
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              child: BezierChart(
                                bezierChartScale: BezierChartScale.CUSTOM,
                                xAxisCustomValues: _xAxis,
                                footerValueBuilder: (double value) {
                                  return "${formatAsIntOrDouble(value)}\ndays";
                                },
                                series: [
                                  BezierLine(
                                    label: "Peso",
                                    lineColor: Colors.green,
                                    data: _items,
                                  ),
                                ],
                                config: BezierChartConfig(
                                  startYAxisFromNonZeroValue: false,
                                  bubbleIndicatorColor:
                                  Colors.white.withOpacity(0.9),
                                  footerHeight: 40,
                                  verticalIndicatorStrokeWidth: 3.0,
                                  verticalIndicatorColor: Colors.black26,
                                  showVerticalIndicator: true,
                                  verticalIndicatorFixedPosition: false,
                                  displayYAxis: true,
                                  stepsYAxis: 1,
                                  snap: false,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Circunferência",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
//                              Center(
//                                child: Card(
//                                  elevation: 10,
//                                  margin: EdgeInsets.all(25.0),
//                                  child: Container(
//                                    color: Colors.lightBlue[900],
//                                    height:
//                                        MediaQuery.of(context).size.height / 2,
//                                    width: MediaQuery.of(context).size.width,
//                                    child: BezierChart(
//                                      bezierChartScale: BezierChartScale.CUSTOM,
//                                      xAxisCustomValues: _xAxis,
//                                      footerValueBuilder: (double value) {
//                                        return "${formatAsIntOrDouble(value)}\ndays";
//                                      },
//                                      series: [
//                                        BezierLine(
//                                          label: "Peso",
//                                          lineColor: Colors.green,
//                                          data: _items,
//                                        ),
//                                      ],
//                                      config: BezierChartConfig(
//                                        updatePositionOnTap: true,
//                                  bubbleIndicatorValueFormat: intl.NumberFormat("###,##0.00", "en_US"),
//                                        verticalIndicatorStrokeWidth: 1.0,
//                                        verticalIndicatorColor: Colors.white30,
//                                        showVerticalIndicator: true,
//                                        verticalIndicatorFixedPosition: false,
//                                        backgroundColor: Colors.transparent,
//                                        footerHeight: 40.0,
//                                      ),
//                                    ),
//                                  ),
//                                ),
//                              ),
                      ],
                    ),
                  )
                      : Center(child: CircularProgressIndicator()),
                ),
                floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => RegistroImcScreen()));
                  },
                ),
              ),

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
                                      "Toque no + para adicionar um medicamento",
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
}
