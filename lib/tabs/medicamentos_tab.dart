import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:micro_news/blocs/app_bloc.dart';
import 'package:micro_news/models/medicamentos_data.dart';
import 'package:micro_news/models/usuario_model.dart';
import 'package:micro_news/screens/medicamentos/detalhes_medicamentos_screen.dart';
import 'package:micro_news/screens/medicamentos/novo_medicamento_screen.dart';
import 'package:micro_news/widgets/custom_drawer_guitar.dart';
import 'package:provider/provider.dart';

class MedicamentosTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      centerTitle: true,
      title: Text(
        "Medicines",
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
      elevation: 0,
    );
    Widget child = _MedicamentosTab(appBar: appBar);

    child = CustomGuitarDrawer(child: child);

    return child;
  }
}

class _MedicamentosTab extends StatefulWidget {
  final AppBar appBar;

  _MedicamentosTab({Key key, @required this.appBar}) : super(key: key);

  @override
  __MedicamentosTabState createState() => __MedicamentosTabState();
}

class __MedicamentosTabState extends State<_MedicamentosTab> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalBloc _globalBloc = Provider.of<GlobalBloc>(context);
    return Scaffold(
      appBar: widget.appBar,
      body: Container(
        color: Color(0xFFF6F8FC),
        child: Column(
          children: <Widget>[
            TopContainer(),
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
              builder: (context) => NovoMedicamentoScreen(),
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
                  "Number of medicines",
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
                  "Touch in + for add a new medicine",
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
                  return MedicamentoCard(
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

class MedicamentoCard extends StatelessWidget {
  final String type;
  final MedicamentosData medicamento;

  MedicamentoCard(this.type, this.medicamento);

  Hero makeIcon(double size) {
    if (medicamento.tipoMedicamento == "Frasco") {
      return Hero(
        tag: medicamento.nomeMedicamento + medicamento.tipoMedicamento,
        child: Icon(
          IconData(0xe900, fontFamily: "Ic"),
          color: Colors.blueAccent,
          size: size,
        ),
      );
    } else if (medicamento.tipoMedicamento == "Pilula") {
      return Hero(
        tag: medicamento.nomeMedicamento + medicamento.tipoMedicamento,
        child: Icon(
          IconData(0xe901, fontFamily: "Ic"),
          color: Colors.blueAccent,
          size: size,
        ),
      );
    } else if (medicamento.tipoMedicamento == "Seringa") {
      return Hero(
        tag: medicamento.nomeMedicamento + medicamento.tipoMedicamento,
        child: Icon(
          IconData(0xe902, fontFamily: "Ic"),
          color: Colors.blueAccent,
          size: size,
        ),
      );
    } else if (medicamento.tipoMedicamento == "Comprimido") {
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
                        child: DetalhesMedicamentoScreen(medicamento),
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
                  tag: medicamento.nomeMedicamento,
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      medicamento.nomeMedicamento,
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                Text(
                  medicamento.intervalo == 1
                      ? "every " + medicamento.intervalo.toString() + " hour"
                      : "every " + medicamento.intervalo.toString() + " hours",
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
