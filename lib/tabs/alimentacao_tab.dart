import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:micro_news/models/usuario_model.dart';
import 'package:micro_news/widgets/custom_drawer_guitar.dart';

class AlimentacaoTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      centerTitle: true,
      title: Text(
        "Nutrition",
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
      backgroundColor: Colors.blueAccent,
      bottom: TabBar(
        indicatorColor: Colors.white,
        indicatorWeight: 2,
        tabs: [
          Tab(text: "Recommended"),
          Tab(text: "Not Recommended"),
        ],
      ),
    );
    Widget child = _AlimentacaoTab(appBar: appBar);

    child = CustomGuitarDrawer(child: child);

    return child;
  }
}

class _AlimentacaoTab extends StatefulWidget {
  final AppBar appBar;

  _AlimentacaoTab({Key key, @required this.appBar}) : super(key: key);

  @override
  __AlimentacaoTabState createState() => __AlimentacaoTabState();
}

class __AlimentacaoTabState extends State<_AlimentacaoTab> {
  @override
  Widget build(BuildContext context) {
    int likes;
    String id;
    String description;
    List<dynamic> usuarios_like;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: widget.appBar,
          body: TabBarView(
            children: [
              //recomendados
              Scaffold(
                body: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: FutureBuilder(
                            future: getAlimentosRecomendados(),
                            builder: (_, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return new Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (_, index) {
                                      likes =
                                          snapshot.data[index].data["likes"];
                                      id = snapshot.data[index].data["id"];
                                      description = snapshot
                                          .data[index].data["description"];
                                      usuarios_like = snapshot
                                          .data[index].data["usuarios_like"];
                                      return Container(
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
                                          child: ListTileRecomendados(
                                              description,
                                              id,
                                              likes,
                                              usuarios_like),
                                        ),
                                      );
                                    });
                              }
                            }),
                      ),
                    ]),
              ),

              //nao_recomendados
              Scaffold(
                body: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: FutureBuilder(
                            future: getAlimentosNaoRecomendados(),
                            builder: (_, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return new Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (_, index) {
                                      likes =
                                          snapshot.data[index].data["likes"];
                                      id = snapshot.data[index].data["id"];
                                      description = snapshot
                                          .data[index].data["description"];
                                      usuarios_like = snapshot
                                          .data[index].data["usuarios_like"];
                                      return Container(
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
                                          child: ListTileNaoRecomendados(
                                              description,
                                              id,
                                              likes,
                                              usuarios_like),
                                        ),
                                      );
                                    });
                              }
                            }),
                      ),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future getAlimentosRecomendados() async {
  var firestore = Firestore.instance;

  QuerySnapshot qn = await firestore
      .collection("alimentos")
      .document("KyI3uFMimX8qM73NTkOV")
      .collection("recomendados")
      .getDocuments();

  return qn.documents;
}

Future getAlimentosNaoRecomendados() async {
  var firestore = Firestore.instance;

  QuerySnapshot qn = await firestore
      .collection("alimentos")
      .document("KyI3uFMimX8qM73NTkOV")
      .collection("nao_recomendados")
      .getDocuments();

  return qn.documents;
}

class ListTileRecomendados extends StatefulWidget {
  int likes;
  String id;
  String description;
  List<dynamic> usuarios_like;

  ListTileRecomendados(
      this.description, this.id, this.likes, this.usuarios_like);

  @override
  _ListTileRecomendadosState createState() => _ListTileRecomendadosState();
}

class _ListTileRecomendadosState extends State<ListTileRecomendados> {
  int likes;
  String id;
  String description;
  List<dynamic> usuarios_like;

  @override
  void initState() {
    id = widget.id;
    description = widget.description;
    likes = widget.likes;
    usuarios_like = widget.usuarios_like;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.only(top: 5, left: 10),
      title: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              description,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            onPressed: () {
              if (!usuarios_like
                  .contains(UserModel.of(context).firebaseUser.uid)) {
                usuarios_like.add(UserModel.of(context).firebaseUser.uid);

                Firestore.instance
                    .collection("alimentos")
                    .document("KyI3uFMimX8qM73NTkOV")
                    .collection("recomendados")
                    .document(id)
                    .updateData({
                  "usuarios_like": usuarios_like,
                  "likes": likes + 1,
                });
                setState(() {
                  likes++;
                });
              } else {
                usuarios_like.remove(UserModel.of(context).firebaseUser.uid);

                Firestore.instance
                    .collection("alimentos")
                    .document("KyI3uFMimX8qM73NTkOV")
                    .collection("recomendados")
                    .document(id)
                    .updateData({
                  "usuarios_like": usuarios_like,
                  "likes": likes - 1,
                });
                setState(() {
                  likes--;
                });
              }
//              Navigator.pushReplacement(
//                  context, MaterialPageRoute(builder: (_) => AlimentacaoTab()));
            },
            icon: usuarios_like.contains(UserModel.of(context).firebaseUser.uid)
                ? Icon(Icons.star)
                : Icon(Icons.star_border),
            alignment: Alignment.centerRight,
          ),
          Text(likes.toString()),
        ],
      ),
      leading: CircleAvatar(
        backgroundColor: Colors.white,
        child: Image.network("https://img.icons8.com/color/2x/salad.png"),
      ),
    );
  }
}

class ListTileNaoRecomendados extends StatefulWidget {
  int likes;
  String id;
  String description;
  List<dynamic> usuarios_like;

  ListTileNaoRecomendados(
      this.description, this.id, this.likes, this.usuarios_like);

  @override
  _ListTileNaoRecomendadosState createState() =>
      _ListTileNaoRecomendadosState();
}

class _ListTileNaoRecomendadosState extends State<ListTileNaoRecomendados> {
  int likes;
  String id;
  String description;
  List<dynamic> usuarios_like;

  @override
  void initState() {
    id = widget.id;
    description = widget.description;
    likes = widget.likes;
    usuarios_like = widget.usuarios_like;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.only(top: 5, left: 10),
      title: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              description,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            onPressed: () {
              if (!usuarios_like
                  .contains(UserModel.of(context).firebaseUser.uid)) {
                usuarios_like.add(UserModel.of(context).firebaseUser.uid);

                Firestore.instance
                    .collection("alimentos")
                    .document("KyI3uFMimX8qM73NTkOV")
                    .collection("nao_recomendados")
                    .document(id)
                    .updateData({
                  "usuarios_like": usuarios_like,
                  "likes": likes + 1,
                });
                setState(() {
                  likes++;
                });
              } else {
                usuarios_like.remove(UserModel.of(context).firebaseUser.uid);

                Firestore.instance
                    .collection("alimentos")
                    .document("KyI3uFMimX8qM73NTkOV")
                    .collection("nao_recomendados")
                    .document(id)
                    .updateData({
                  "usuarios_like": usuarios_like,
                  "likes": likes - 1,
                });
                setState(() {
                  likes--;
                  getAlimentosNaoRecomendados();
                });
              }
//              Navigator.pushReplacement(
//                  context, MaterialPageRoute(builder: (_) => AlimentacaoTab()));
            },
            icon: usuarios_like.contains(UserModel.of(context).firebaseUser.uid)
                ? Icon(Icons.star)
                : Icon(Icons.star_border),
            alignment: Alignment.centerRight,
          ),
          Text(likes.toString()),
        ],
      ),
      leading: CircleAvatar(
        backgroundColor: Colors.white,
        child: Image.network("https://img.icons8.com/color/2x/brigadeiro.png"),
      ),
    );
  }
}
