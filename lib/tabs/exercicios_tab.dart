import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:micro_news/models/dicas_data.dart';
import 'package:micro_news/models/exercicios_data.dart';
import 'package:micro_news/models/usuario_model.dart';
import 'package:micro_news/tiles/dicas_tile.dart';
import 'package:micro_news/tiles/exercicio_tile.dart';
import 'package:micro_news/widgets/custom_drawer_guitar.dart';
import 'package:micro_news/widgets/page_transformer.dart';
import 'package:scoped_model/scoped_model.dart';

class ExerciciosTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      elevation: 0,
      centerTitle: true,
      title: Text(
        "Exercícios",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
            color: Colors.white),
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
    Widget child = _ExerciciosTab(appBar: appBar);

    child = CustomGuitarDrawer(child: child);

    return child;
  }
}

class _ExerciciosTab extends StatelessWidget {
  final AppBar appBar;

  _ExerciciosTab({Key key, @required this.appBar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar,
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Colors.blueAccent,
            Colors.white,
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: FutureBuilder<QuerySnapshot>(
              future:
                  Firestore.instance.collection("exercicios").getDocuments(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());
                else
                  return PageTransformer(
                    pageViewBuilder: (context, visibilityResolver) {
                      return PageView.builder(
                          controller: PageController(viewportFraction: 0.85),
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            final pageVisibility =
                                visibilityResolver.resolvePageVisibility(index);

                            return ExercicioTile(
                                "list",
                                ExerciciosData.fromDocument(
                                    snapshot.data.documents[index]),
                                pageVisibility);
                          });
                    },
                  );
              }),
        ));
  }
}
