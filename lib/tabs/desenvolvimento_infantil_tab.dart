import 'package:bezier_chart/bezier_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:micro_news/models/usuario_model.dart';
import 'package:micro_news/screens/registro_imc_screen.dart';

class DesenvolvimentoInfantilTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String id;
    double altura;
    double peso;
    double imc;
    String info;
    Timestamp data;

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
                                        height: 150,
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

String readTimestamp(int timestamp) {
  var now = new DateTime.now();
  var format = new DateFormat('HH:mm a');
  var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  var diff = now.difference(date);
  var time = '';

  if (diff.inSeconds <= 0 ||
      diff.inSeconds > 0 && diff.inMinutes == 0 ||
      diff.inMinutes > 0 && diff.inHours == 0 ||
      diff.inHours > 0 && diff.inDays == 0) {
    time = format.format(date);
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

class ListTileImc extends StatefulWidget {
  String id;
  double altura;
  double peso;
  double imc;
  String info;
  Timestamp data;

  ListTileImc(this.id, this.altura, this.peso, this.imc, this.info, this.data);

  @override
  _ListTileImcState createState() => _ListTileImcState();
}

class _ListTileImcState extends State<ListTileImc> {
  String id;
  double altura;
  double peso;
  double imc;
  String info;
  Timestamp data;

  @override
  void initState() {
    id = widget.id;
    altura = widget.altura;
    peso = widget.peso;
    imc = widget.imc;
    info = widget.info;
    data = widget.data;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        contentPadding: EdgeInsets.only(top: 5, left: 10),
        title: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Peso: $peso"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Altura: $altura"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Imc: $imc"),
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
                  child: Text("Data: $data"),
                ),
              ],
            ),
          ],
        ));
  }
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
        Text(
          "Circunferência",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        _buildChart(
            BezierChartScale.YEARLY,
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
            ))
      ],
    ),
  );
}

_buildChart(
    BezierChartScale scale, BuildContext context, LinearGradient gradient) {
  final fromDate = DateTime(2012, 11, 22);
  final toDate = DateTime.now();

  final date1 = DateTime.now().subtract(Duration(days: 2));
  final date2 = DateTime.now().subtract(Duration(days: 3));

  final date3 = DateTime.now().subtract(Duration(days: 300));
  final date4 = DateTime.now().subtract(Duration(days: 320));

  final date5 = DateTime.now().subtract(Duration(days: 650));
  final date6 = DateTime.now().subtract(Duration(days: 652));

  return Center(
    child: Card(
      elevation: 10,
      margin: EdgeInsets.all(25.0),
      child: Container(
        color: Colors.red,
        height: MediaQuery.of(context).size.height / 3,
        width: MediaQuery.of(context).size.width,
        child: BezierChart(
          bezierChartScale: scale,
          fromDate: fromDate,
          toDate: toDate,
          selectedDate: toDate,
          series: [
            BezierLine(
              label: "Duty",
              onMissingValue: (dateTime) {
                if (dateTime.year.isEven) {
                  return 20.0;
                }
                return 5.0;
              },
              data: [
                DataPoint<DateTime>(value: 10, xAxis: date1),
                DataPoint<DateTime>(value: 50, xAxis: date2),
                DataPoint<DateTime>(value: 100, xAxis: date3),
                DataPoint<DateTime>(value: 100, xAxis: date4),
                DataPoint<DateTime>(value: 40, xAxis: date5),
                DataPoint<DateTime>(value: 47, xAxis: date6),
              ],
            ),
            BezierLine(
              label: "Flight",
              lineColor: Colors.black26,
              onMissingValue: (dateTime) {
                if (dateTime.month.isEven) {
                  return 10.0;
                }
                return 3.0;
              },
              data: [
                DataPoint<DateTime>(value: 20, xAxis: date1),
                DataPoint<DateTime>(value: 30, xAxis: date2),
                DataPoint<DateTime>(value: 150, xAxis: date3),
                DataPoint<DateTime>(value: 80, xAxis: date4),
                DataPoint<DateTime>(value: 45, xAxis: date5),
                DataPoint<DateTime>(value: 45, xAxis: date6),
              ],
            ),
          ],
          config: BezierChartConfig(
            verticalIndicatorStrokeWidth: 3.0,
            verticalIndicatorColor: Colors.black26,
            showVerticalIndicator: true,
            verticalIndicatorFixedPosition: false,
            backgroundGradient: gradient,
            footerHeight: 35.0,
          ),
        ),
      ),
    ),
  );
}
