import 'package:flutter/cupertino.dart';
import 'package:micro_news/models/usuario_model.dart';
import 'package:micro_news/screens/credenciais/login_screen.dart';
import 'package:micro_news/tiles/home_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:micro_news/widgets/custom_drawer_guitar.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      centerTitle: true,
      title: Text(
        "MicroNews®",
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
    Widget child = _HomeTab(appBar: appBar);
    child = CustomGuitarDrawer(child: child);

    return child;
  }
}

class _HomeTab extends StatelessWidget {
  final AppBar appBar;

  _HomeTab({Key key, @required this.appBar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<bool> _onBackPressed() {
      return showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              content: Text("Deseja sair do aplicativo?",
                  style: TextStyle(fontSize: 20)),
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
                    UserModel model = new UserModel();
                    model.signOut();
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  isDestructiveAction: true,
                ),
              ],
            );
          });
    }

    return new WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          appBar: appBar,
          body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Colors.blueAccent,
              Colors.white,
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            child: FutureBuilder<QuerySnapshot>(
              future: Firestore.instance
                  .collection("home")
                  .orderBy("id")
                  .getDocuments(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView(
                    children: snapshot.data.documents.map((doc) {
                      return HomeTile(doc);
                    }).toList(),
                  );
                }
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => launch("tel://192"),
            child: Icon(Icons.local_hospital),
            backgroundColor: Colors.red,
          ),
        ));
  }
}
