import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:micro_news/models/imc_model.dart';
import 'package:micro_news/models/p_cefalico_model.dart';
import 'package:micro_news/models/usuario_model.dart';
import 'package:micro_news/screens/desenvolvimento_infantil/registro_imc_screen.dart';
import 'package:micro_news/screens/desenvolvimento_infantil/registro_p_cefalico.dart';
import 'package:micro_news/tiles/imc_tile.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:micro_news/tiles/p_cefalico_tile.dart';
import 'package:micro_news/widgets/custom_drawer_guitar.dart';

class DesenvolvimentoInfantilTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      bottom: TabBar(
        indicatorColor: Colors.white,
        indicatorWeight: 2,
        tabs: <Widget>[
          Tab(text: "IMC"),
          Tab(text: "Cephalic Perimeter"),
        ],
      ),
      centerTitle: true,
      title: Text(
        "Child Development",
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 25.0, color: Colors.white),
        textAlign: TextAlign.center,
      ),
      leading: Builder(
        builder: (context) {
          return IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => CustomGuitarDrawer.of(context).open(),
          );
        },
      ),
    );
    Widget child = _DesenvolvimentoInfantilTab(appBar: appBar);

    child = CustomGuitarDrawer(child: child);

    return child;
  }
}

class _DesenvolvimentoInfantilTab extends StatefulWidget {
  final AppBar appBar;

  _DesenvolvimentoInfantilTab({Key key, @required this.appBar})
      : super(key: key);
  @override
  __DesenvolvimentoInfantilTabState createState() =>
      __DesenvolvimentoInfantilTabState();
}

class __DesenvolvimentoInfantilTabState
    extends State<_DesenvolvimentoInfantilTab> {
  Function(DateTime) onItemClicked;

  List<charts.Series<Imc, DateTime>> _seriesLineIMCData;
  List<charts.Series<PCefalico, DateTime>> _seriesLinePCefalicoData;

  List<charts.Series> seriesList;
  List<Imc> imcData;
  List<PCefalico> pCefalicoData;
  bool IsList = false;

  _generateDataIMC(imcData) {
    _seriesLineIMCData = List<charts.Series<Imc, DateTime>>();
    _seriesLineIMCData.add(
      charts.Series<Imc, DateTime>(
        id: 'Imc',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (Imc sales, _) =>
            DateTime.parse(converterTimestampChart(sales.data)),
        measureFn: (Imc sales, _) => sales.imc,
        data: imcData,
      ),
    );
  }

  _generateDataPCefalico(pCefalicoData) {
    _seriesLinePCefalicoData = List<charts.Series<PCefalico, DateTime>>();
    _seriesLinePCefalicoData.add(
      charts.Series<PCefalico, DateTime>(
        id: 'P_Cefalico',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (PCefalico sales, _) =>
            DateTime.parse(converterTimestampChart(sales.data)),
        measureFn: (PCefalico sales, _) => sales.diametro,
        data: pCefalicoData,
      ),
    );
  }

  Widget _buildBodyIMC(BuildContext context, uid) {
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
          return _buildChartIMC(context, imcs);
        }
      },
    );
  }

  Widget _buildBodypCefalico(BuildContext context, uid) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection("users")
          .document(uid)
          .collection("desenvolvimento_infantil")
          .document("p_cefalico")
          .collection("ps_cefalicos")
          .orderBy("data")
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          List<PCefalico> p_cefalicos = snapshot.data.documents
              .map((documentSnapshot) =>
                  PCefalico.fromMap(documentSnapshot.data))
              .toList();
          return _buildChartPCefalico(context, p_cefalicos);
        }
      },
    );
  }

  showAlertDialogIMC(BuildContext context, data, peso, altura, imc, info) {
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
            children: <Widget>[Text("Altura: $altura")],
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

  _onSelectionChangedIMC(charts.SelectionModel<DateTime> model) {
    var data = converterTimestamp(model.selectedDatum.first.datum.data);
    var peso = model.selectedDatum.first.datum.peso;
    var altura = model.selectedDatum.first.datum.altura;
    var imc = model.selectedDatum.first.datum.imc;
    var info = model.selectedDatum.first.datum.info;

    showAlertDialogIMC(context, data, peso, altura, imc, info);
  }

  showAlertDialogPCefalico(BuildContext context, data, diametro) {
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
            children: <Widget>[Text("Diâmetro: $diametro")],
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

  _onSelectionChangedPCefalico(charts.SelectionModel<DateTime> model) {
    var data = converterTimestamp(model.selectedDatum.first.datum.data);
    var diametro = model.selectedDatum.first.datum.diametro;

    showAlertDialogPCefalico(context, data, diametro);
  }

  Widget _buildChartIMC(BuildContext context, List<Imc> data) {
    imcData = data;
    _generateDataIMC(imcData);
    return Padding(
        padding: EdgeInsets.all(8.0),
        child: Container(
          child: Center(
            child: Column(
              children: <Widget>[
                Text(
                  'BMI',
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
                      new charts.ChartTitle("Date",
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
                          changedListener: _onSelectionChangedIMC)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildChartPCefalico(BuildContext context, List<PCefalico> data) {
    pCefalicoData = data;
    _generateDataPCefalico(pCefalicoData);
    return Padding(
        padding: EdgeInsets.all(8.0),
        child: Container(
          child: Center(
            child: Column(
              children: <Widget>[
                Text(
                  'Cephalic Perimeter',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Expanded(
                  child: charts.TimeSeriesChart(
                    _seriesLinePCefalicoData,
                    defaultRenderer: new charts.LineRendererConfig(
                        includeArea: true, stacked: true),
                    animationDuration: Duration(seconds: 2),
                    dateTimeFactory: charts.LocalDateTimeFactory(),
                    animate: true,
                    behaviors: [
                      new charts.ChartTitle("Date",
                          behaviorPosition: charts.BehaviorPosition.bottom,
                          titleOutsideJustification:
                              charts.OutsideJustification.middleDrawArea),
                      new charts.ChartTitle("Diameter",
                          behaviorPosition: charts.BehaviorPosition.start,
                          titleOutsideJustification:
                              charts.OutsideJustification.middleDrawArea),
                    ],
                    selectionModels: [
                      charts.SelectionModelConfig(
                          type: charts.SelectionModelType.info,
                          changedListener: _onSelectionChangedPCefalico)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    String idImc;
    String idPCefalico;
    double altura;
    double peso;
    double imc;
    String info;
    int data;
    double diametro;

    if (UserModel.of(context).isLoggedIn()) {
      var uid = UserModel.of(context).firebaseUser.uid;
      return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: widget.appBar,
          body: TabBarView(
            children: <Widget>[
              //IMC
              IsList == true
                  ? Scaffold(
                      body: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    "Registered BMIs",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ],
                            ),
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
                                            idImc =
                                                snapshot.data[index].data["id"];
                                            peso = snapshot
                                                .data[index].data["peso"];
                                            altura = snapshot
                                                .data[index].data["altura"];
                                            imc = snapshot
                                                .data[index].data["imc"];
                                            info = snapshot
                                                .data[index].data["info"];
                                            data = snapshot
                                                .data[index].data["data"];
                                            return Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  20, 0, 20, 15),
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
                                                child: ListTileImc(idImc, peso,
                                                    altura, imc, info, data),
                                              ),
                                            );
                                          });
                                    }
                                  }),
                            ),
                          ]),
                      floatingActionButton: SpeedDial(
                        marginRight: 18,
                        marginBottom: 20,
                        animatedIcon: AnimatedIcons.menu_close,
                        animatedIconTheme: IconThemeData(size: 22.0),
                        closeManually: false,
                        curve: Curves.bounceIn,
                        overlayColor: Colors.black,
                        overlayOpacity: 0.5,
                        tooltip: 'Adicionar',
                        heroTag: 'add-tag',
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        elevation: 8.0,
                        shape: CircleBorder(),
                        children: [
                          SpeedDialChild(
                              child: Icon(Icons.add),
                              backgroundColor: Colors.blueAccent,
                              label: 'Adicionar IMC',
                              labelStyle: TextStyle(fontSize: 18.0),
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          RegistroImcScreen()))),
                          SpeedDialChild(
                              child: Icon(Icons.show_chart),
                              backgroundColor: Colors.blueAccent,
                              label: 'Ver em formato de gráfico',
                              labelStyle: TextStyle(fontSize: 18.0),
                              onTap: () {
                                setState(() {
                                  IsList = false;
                                });
                              }),
                        ],
                      ))
                  : Scaffold(
                      body: _buildBodyIMC(context, uid),
                      floatingActionButton: SpeedDial(
                        marginRight: 18,
                        marginBottom: 20,
                        animatedIcon: AnimatedIcons.menu_close,
                        animatedIconTheme: IconThemeData(size: 22.0),
                        closeManually: false,
                        curve: Curves.bounceIn,
                        overlayColor: Colors.black,
                        overlayOpacity: 0.5,
                        tooltip: 'Adicionar',
                        heroTag: 'add-tag',
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        elevation: 8.0,
                        shape: CircleBorder(),
                        children: [
                          SpeedDialChild(
                              child: Icon(Icons.add),
                              backgroundColor: Colors.blueAccent,
                              label: 'Adicionar IMC',
                              labelStyle: TextStyle(fontSize: 18.0),
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          RegistroImcScreen()))),
                          SpeedDialChild(
                              child: Icon(Icons.format_list_bulleted),
                              backgroundColor: Colors.blueAccent,
                              label: 'Ver em formato de lista',
                              labelStyle: TextStyle(fontSize: 18.0),
                              onTap: () {
                                setState(() {
                                  IsList = true;
                                });
                              }),
                        ],
                      )),

              //Perímetro cefálico
              IsList == true
                  ? Scaffold(
                      body: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    "Perímetros Cefálico Cadastrados",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Expanded(
                              child: FutureBuilder(
                                  future: getPerimetros(uid),
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
                                            "Toque no + para adicionar um perímetro cefálico",
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
                                            idPCefalico =
                                                snapshot.data[index].data["id"];
                                            diametro = snapshot
                                                .data[index].data["diametro"];
                                            data = snapshot
                                                .data[index].data["data"];
                                            return Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  20, 0, 20, 15),
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
                                                child: ListTilePCefalico(
                                                    idPCefalico,
                                                    diametro,
                                                    data),
                                              ),
                                            );
                                          });
                                    }
                                  }),
                            ),
                          ]),
                      floatingActionButton: SpeedDial(
                        marginRight: 18,
                        marginBottom: 20,
                        animatedIcon: AnimatedIcons.menu_close,
                        animatedIconTheme: IconThemeData(size: 22.0),
                        closeManually: false,
                        curve: Curves.bounceIn,
                        overlayColor: Colors.black,
                        overlayOpacity: 0.5,
                        tooltip: 'Adicionar',
                        heroTag: 'add-tag',
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        elevation: 8.0,
                        shape: CircleBorder(),
                        children: [
                          SpeedDialChild(
                              child: Icon(Icons.add),
                              backgroundColor: Colors.blueAccent,
                              label: 'Adicionar Perímetro Cefálico',
                              labelStyle: TextStyle(fontSize: 18.0),
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          RegistroPCefalicoScreen()))),
                          SpeedDialChild(
                              child: Icon(Icons.show_chart),
                              backgroundColor: Colors.blueAccent,
                              label: 'Ver em formato de gráfico',
                              labelStyle: TextStyle(fontSize: 18.0),
                              onTap: () {
                                setState(() {
                                  IsList = false;
                                });
                              }),
                        ],
                      ))
                  : Scaffold(
                      body: _buildBodypCefalico(context, uid),
                      floatingActionButton: SpeedDial(
                        marginRight: 18,
                        marginBottom: 20,
                        animatedIcon: AnimatedIcons.menu_close,
                        animatedIconTheme: IconThemeData(size: 22.0),
                        closeManually: false,
                        curve: Curves.bounceIn,
                        overlayColor: Colors.black,
                        overlayOpacity: 0.5,
                        tooltip: 'Adicionar',
                        heroTag: 'add-tag',
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        elevation: 8.0,
                        shape: CircleBorder(),
                        children: [
                          SpeedDialChild(
                              child: Icon(Icons.add),
                              backgroundColor: Colors.blueAccent,
                              label: 'Adicionar Perímetro Cefálico',
                              labelStyle: TextStyle(fontSize: 18.0),
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          RegistroPCefalicoScreen()))),
                          SpeedDialChild(
                              child: Icon(Icons.format_list_bulleted),
                              backgroundColor: Colors.blueAccent,
                              label: 'Ver em formato de lista',
                              labelStyle: TextStyle(fontSize: 18.0),
                              onTap: () {
                                setState(() {
                                  IsList = true;
                                });
                              }),
                        ],
                      )),
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

Future getPerimetros(uid) async {
  var firestore = Firestore.instance;

  QuerySnapshot qn = await firestore
      .collection("users")
      .document(uid)
      .collection("desenvolvimento_infantil")
      .document("p_cefalico")
      .collection("ps_cefalicos")
      .orderBy("data")
      .getDocuments();

  return qn.documents;
}
