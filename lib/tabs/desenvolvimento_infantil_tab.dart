import 'package:bezier_chart/bezier_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
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
                body: SingleChildScrollView(
                  child: grafico(context),
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

Widget grafico(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.blueAccent,
          Colors.white,
        ],
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "IMC",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        _buildChart(
          BezierChartScale.MONTHLY,
          context,
          LinearGradient(
            colors: [
              Colors.lightBlue,
              Colors.lightBlue[600],
              Colors.lightBlue[700],
              Colors.lightBlue[700],
              Colors.lightBlue[800],
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ],
    ),
  );
}

_buildChart(
    BezierChartScale scale, BuildContext context, LinearGradient gradient) {
  final fromDate = DateTime(2020, 07, 15);
  final toDate = DateTime.now();

  return Center(
    child: Card(
      elevation: 10,
      margin: EdgeInsets.all(25.0),
      child: Container(
        color: Colors.lightBlue[900],
        height: MediaQuery.of(context).size.height / 2,
        width: MediaQuery.of(context).size.width,
        child: BezierChart(
          fromDate: fromDate,
          bezierChartScale: BezierChartScale.WEEKLY,
          toDate: toDate,
          onIndicatorVisible: (val) {
            print("Indicator Visible :$val");
          },
          onDateTimeSelected: (datetime) {
            print("selected datetime: $datetime");
          },
          selectedDate: toDate,
          //this is optional
          footerDateTimeBuilder: (DateTime value, BezierChartScale scaleType) {
            final newFormat = intl.DateFormat('dd/MMM');
            return newFormat.format(value);
          },
          bubbleLabelDateTimeBuilder:
              (DateTime value, BezierChartScale scaleType) {
            final newFormat = intl.DateFormat('EEE d');
            return "${newFormat.format(value)}\n";
          },
          series: [
            BezierLine(
              label: "Peso",
              lineColor: Colors.green,
              data: [
                DataPoint<DateTime>(value: 44.5, xAxis: DateTime(2020, 07, 15)),
                DataPoint<DateTime>(value: 45.5, xAxis: DateTime(2020, 07, 16)),
              ],
            ),
            BezierLine(
              label: "Altura",
              lineColor: Colors.red,
              data: [
                DataPoint<DateTime>(value: 180, xAxis: DateTime(2020, 07, 15)),
                DataPoint<DateTime>(value: 182, xAxis: DateTime(2020, 07, 16)),
              ],
            ),
            BezierLine(
              label: "IMC",
              lineColor: Colors.pink,
              data: [
                DataPoint<DateTime>(value: 22.5, xAxis: DateTime(2020, 07, 15)),
                DataPoint<DateTime>(value: 23.5, xAxis: DateTime(2020, 07, 16)),
              ],
            ),
          ],
          config: BezierChartConfig(
              updatePositionOnTap: true,
              verticalIndicatorStrokeWidth: 2.0,
              verticalIndicatorColor: Colors.white,
              showVerticalIndicator: true,
              verticalIndicatorFixedPosition: false,
              footerHeight: 40.0,
              pinchZoom: true),
        ),
      ),
    ),
  );
}
