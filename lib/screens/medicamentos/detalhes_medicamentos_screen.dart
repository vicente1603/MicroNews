import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:micro_news/blocs/app_bloc.dart';
import 'package:micro_news/models/medicamentos_data.dart';
import 'package:micro_news/models/medicamento.dart';
import 'package:micro_news/models/usuario_model.dart';
import 'package:micro_news/tabs/medicamentos_tab.dart';
import 'package:micro_news/tiles/drawer_tile.dart';
import 'package:provider/provider.dart';

class DetalhesMedicamentoScreen extends StatelessWidget {
  final MedicamentosData medicamento;

  DetalhesMedicamentoScreen(this.medicamento);

  @override
  Widget build(BuildContext context) {
    if (UserModel.of(context).isLoggedIn()) {
      String uid = UserModel.of(context).firebaseUser.uid;

      final GlobalBloc _globalBloc = Provider.of<GlobalBloc>(context);
      return Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text("Medicine Details"),
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MainSection(medicamento: medicamento),
                  SizedBox(
                    height: 15,
                  ),
                  ExtendedSection(medicamento: medicamento),
                  SizedBox(
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: RaisedButton(
                        child: Center(
                          child: Text(
                            "Remove",
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                        ),
                        color: Colors.redAccent,
                        onPressed: () {
                          openAlertBox(context, _globalBloc, uid);
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  openAlertBox(BuildContext context, GlobalBloc _globalBloc, String uid) {
    return showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: new Text('Remove medicine'),
            content: new Text('Deseja remover o medicamento ' +
                medicamento.nomeMedicamento.toString() +
                "?"),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text("NÃO"),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              CupertinoDialogAction(
                child: Text("SIM"),
                onPressed: () {
                  Firestore.instance
                      .collection("users")
                      .document(uid)
                      .collection("medicamentos")
                      .document(medicamento.id)
                      .delete();

                  Medicine tobeRemoved = Medicine(
                    id: medicamento.id,
                    notificationIDs: medicamento.idsNotificacoes,
                    medicineName: medicamento.nomeMedicamento,
                    dosage: medicamento.dosagem,
                    medicineType: medicamento.tipoMedicamento,
                    interval: medicamento.intervalo,
                    startTime: medicamento.horaInicio,
                  );

                  _globalBloc.removeMedicine(tobeRemoved);

//                  Navigator.of(context).popUntil((route) => route.isFirst);

                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => MedicamentosTab()));
                },
                isDestructiveAction: true,
              ),
            ],
          );
        });
  }
}

class MainSection extends StatelessWidget {
  final MedicamentosData medicamento;

  MainSection({
    Key key,
    @required this.medicamento,
  }) : super(key: key);

  Hero makeIcon(double size) {
    if (medicamento.tipoMedicamento == "Bottle") {
      return Hero(
        tag: medicamento.nomeMedicamento + medicamento.tipoMedicamento,
        child: Icon(
          IconData(0xe900, fontFamily: "Ic"),
          color: Colors.blueAccent,
          size: size,
        ),
      );
    } else if (medicamento.tipoMedicamento == "Pill") {
      return Hero(
        tag: medicamento.nomeMedicamento + medicamento.tipoMedicamento,
        child: Icon(
          IconData(0xe901, fontFamily: "Ic"),
          color: Colors.blueAccent,
          size: size,
        ),
      );
    } else if (medicamento.tipoMedicamento == "Syringe") {
      return Hero(
        tag: medicamento.nomeMedicamento + medicamento.tipoMedicamento,
        child: Icon(
          IconData(0xe902, fontFamily: "Ic"),
          color: Colors.blueAccent,
          size: size,
        ),
      );
    } else if (medicamento.tipoMedicamento == "tablet") {
      return Hero(
        tag: medicamento.nomeMedicamento + medicamento.tipoMedicamento,
        child: Icon(
          IconData(0xe903, fontFamily: "Ic"),
          color: Colors.blueAccent,
          size: size,
        ),
      );
    }
    return Hero(
      tag: medicamento.nomeMedicamento + medicamento.tipoMedicamento,
      child: Icon(
        Icons.local_hospital,
        color: Colors.blueAccent,
        size: size,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          makeIcon(175),
          SizedBox(
            width: 15,
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Hero(
                  tag: medicamento.nomeMedicamento,
                  child: Material(
                    color: Colors.transparent,
                    child: MainInfoTab(
                      fieldTitle: "Name",
                      fieldInfo: medicamento.nomeMedicamento,
                    ),
                  ),
                ),
                MainInfoTab(
                  fieldTitle: "Dosage",
                  fieldInfo: medicamento.dosagem == 0
                      ? "Não especificado"
                      : medicamento.dosagem.toString() + " mg",
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class MainInfoTab extends StatelessWidget {
  final String fieldTitle;
  final String fieldInfo;

  MainInfoTab({Key key, @required this.fieldTitle, @required this.fieldInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.35,
      height: 100,
      child: ListView(
        padding: EdgeInsets.only(top: 15),
        shrinkWrap: true,
        children: <Widget>[
          Text(
            fieldTitle,
            style: TextStyle(
                fontSize: 17,
                color: Color(0xFFC9C9C9),
                fontWeight: FontWeight.bold),
          ),
          Text(
            fieldInfo,
            style: TextStyle(
                fontSize: 24,
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class ExtendedSection extends StatelessWidget {
  final MedicamentosData medicamento;

  ExtendedSection({Key key, @required this.medicamento}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          ExtendedInfoTab(
            fieldTitle: "Medicine type",
            fieldInfo: medicamento.tipoMedicamento == "Nenhum"
                ? "Não especificado"
                : medicamento.tipoMedicamento,
          ),
          ExtendedInfoTab(
            fieldTitle: "Dose range",
            fieldInfo: "Even " +
                medicamento.intervalo.toString() +
                " hours  | " +
                " ${medicamento.intervalo == 24 ? "One time of day" : (24 / medicamento.intervalo).floor().toString() + " times of day"}",
          ),
          ExtendedInfoTab(
              fieldTitle: "Start time",
              fieldInfo: medicamento.horaInicio[0] +
                  medicamento.horaInicio[1] +
                  ":" +
                  medicamento.horaInicio[2] +
                  medicamento.horaInicio[3]),
        ],
      ),
    );
  }
}

class ExtendedInfoTab extends StatelessWidget {
  final String fieldTitle;
  final String fieldInfo;

  ExtendedInfoTab(
      {Key key, @required this.fieldTitle, @required this.fieldInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 18.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: Text(
                fieldTitle,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              fieldInfo,
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFFC9C9C9),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
