import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:micro_news/blocs/app_bloc.dart';
import 'package:micro_news/data/medicamentos_data.dart';
import 'package:micro_news/models/usuario_model.dart';
import 'package:micro_news/screens/detalhes_medicamentos_screen.dart';
import 'package:micro_news/screens/novo_medicamento_screen.dart';
import 'package:provider/provider.dart';

class MedicamentosTab extends StatefulWidget {
  @override
  _MedicamentosTabState createState() => _MedicamentosTabState();
}

class _MedicamentosTabState extends State<MedicamentosTab> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalBloc _globalBloc = Provider.of<GlobalBloc>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0.0,
      ),
      body: Container(
        color: Color(0xFFF6F8FC),
        child: Column(
          children: <Widget>[
            Flexible(
              flex: 3,
              child: TopContainer(),
            ),
            SizedBox(
              height: 10,
            ),
            Flexible(
              flex: 7,
              child: Provider<GlobalBloc>.value(
                child: BottomContainer(),
                value: _globalBloc,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 4,
        backgroundColor: Colors.blueAccent,
        child: Icon(
          Icons.add,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewEntry(),
            ),
          );
        },
      ),
    );
  }
}

class TopContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (UserModel.of(context).isLoggedIn()) {
      String uid = UserModel.of(context).firebaseUser.uid;
      final GlobalBloc globalBloc = Provider.of<GlobalBloc>(context);
      return Container(
        height: 90.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.elliptical(50, 27),
            bottomRight: Radius.elliptical(50, 27),
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              color: Colors.blueAccent,
              offset: Offset(0, 3.5),
            )
          ],
          color: Colors.blueAccent,
        ),
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 2.0),
              child: Center(
                child: Text(
                  "Número de medicamentos",
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            FutureBuilder<QuerySnapshot>(
              future: Firestore.instance
                  .collection("users")
                  .document(uid)
                  .collection("medicamentos")
                  .getDocuments(),
              builder: (context, snapshot) {
                return Padding(
                  padding: EdgeInsets.only(top: 16.0, bottom: 5),
                  child: Center(
                    child: Text(
                      !snapshot.hasData
                          ? '0'
                          : snapshot.data.documents.length.toString(),
                      style: TextStyle(
                        fontFamily: "Neu",
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
    }
  }
}

class BottomContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (UserModel.of(context).isLoggedIn()) {
      String uid = UserModel.of(context).firebaseUser.uid;
      final GlobalBloc _globalBloc = Provider.of<GlobalBloc>(context);
      return FutureBuilder<QuerySnapshot>(
        future: Firestore.instance
            .collection("users")
            .document(uid)
            .collection("medicamentos")
            .getDocuments(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          } else if (snapshot.data.documents.length == 0) {
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
            return Container(
              color: Color(0xFFF6F8FC),
              child: GridView.builder(
                padding: EdgeInsets.only(top: 12),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return MedicineCard(
                      "list",
                      MedicamentosData.fromDocument(
                          snapshot.data.documents[index]));
                },
              ),
            );
          }
        },
      );
    }
  }
}

class MedicineCard extends StatelessWidget {
  final String type;
  final MedicamentosData medicamentos;

  MedicineCard(this.type, this.medicamentos);

  Hero makeIcon(double size) {
    if (medicamentos.medicineType == "Frasco") {
      return Hero(
        tag: medicamentos.medicineName + medicamentos.medicineType,
        child: Icon(
          IconData(0xe900, fontFamily: "Ic"),
          color: Colors.blueAccent,
          size: size,
        ),
      );
    } else if (medicamentos.medicineType == "Pilula") {
      return Hero(
        tag: medicamentos.medicineName + medicamentos.medicineType,
        child: Icon(
          IconData(0xe901, fontFamily: "Ic"),
          color: Colors.blueAccent,
          size: size,
        ),
      );
    } else if (medicamentos.medicineType == "Seringa") {
      return Hero(
        tag: medicamentos.medicineName + medicamentos.medicineType,
        child: Icon(
          IconData(0xe902, fontFamily: "Ic"),
          color: Colors.blueAccent,
          size: size,
        ),
      );
    } else if (medicamentos.medicineType == "Comprimido") {
      return Hero(
        tag: medicamentos.medicineName + medicamentos.medicineType,
        child: Icon(
          IconData(0xe903, fontFamily: "Ic"),
          color: Colors.blueAccent,
          size: size,
        ),
      );
    }
    return Hero(
      tag: medicamentos.medicineName + medicamentos.medicineType,
      child: Icon(
        Icons.error,
        color: Colors.blueAccent,
        size: size,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: InkWell(
        highlightColor: Colors.white,
        splashColor: Colors.grey,
        onTap: () {
          Navigator.of(context).push(
            PageRouteBuilder<Null>(
              pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return AnimatedBuilder(
                    animation: animation,
                    builder: (BuildContext context, Widget child) {
                      return Opacity(
                        opacity: animation.value,
                        child: MedicineDetails(medicamentos),
                      );
                    });
              },
              transitionDuration: Duration(milliseconds: 500),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                makeIcon(50.0),
                Hero(
                  tag: medicamentos.medicineName,
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      medicamentos.medicineName,
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                Text(
                  medicamentos.interval == 1
                      ? "A cada " + medicamentos.interval.toString() + " hora"
                      : "A cada " + medicamentos.interval.toString() + " horas",
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFC9C9C9),
                      fontWeight: FontWeight.w400),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
