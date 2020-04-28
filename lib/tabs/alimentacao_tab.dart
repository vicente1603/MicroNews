import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:micro_news/models/alimentos_model.dart';

class AlimentacaoTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int likes;
    String id;
    String description;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.blueAccent,
              elevation: 0,
              title: TabBar(
                tabs: [
                  Tab(text: "Recomendados"),
                  Tab(text: "Não Recomendados"),
                ],
              )),
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
                                      return Container(
                                        height: 60,
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
                                              description, id, likes),
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
                                      return Container(
                                        height: 60,
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
                                              description, id, likes),
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
}

class ListTileRecomendados extends StatefulWidget {
  int likes;
  String id;
  String description;

  ListTileRecomendados(this.description, this.id, this.likes);

  @override
  _ListTileRecomendadosState createState() => _ListTileRecomendadosState();
}

class _ListTileRecomendadosState extends State<ListTileRecomendados> {
  int likes;
  String id;
  String description;

  @override
  void initState() {
    id = widget.id;
    description = widget.description;
    likes = widget.likes;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(description),
          IconButton(
            onPressed: () {
              Firestore.instance
                  .collection("alimentos")
                  .document("KyI3uFMimX8qM73NTkOV")
                  .collection("recomendados")
                  .document(id)
                  .updateData({
                "likes": likes + 1,
              });

              setState(() {
                likes++;
              });
            },
            icon: Icon(Icons.star_border),
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

  ListTileNaoRecomendados(this.description, this.id, this.likes);

  @override
  _ListTileNaoRecomendadosState createState() =>
      _ListTileNaoRecomendadosState();
}

class _ListTileNaoRecomendadosState extends State<ListTileNaoRecomendados> {
  int likes;
  String id;
  String description;

  @override
  void initState() {
    id = widget.id;
    description = widget.description;
    likes = widget.likes;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(description),
          IconButton(
            onPressed: () {
              Firestore.instance
                  .collection("alimentos")
                  .document("KyI3uFMimX8qM73NTkOV")
                  .collection("nao_recomendados")
                  .document(id)
                  .updateData({
                "likes": likes + 1,
              });

              setState(() {
                likes++;
              });
            },
            icon: Icon(Icons.star_border),
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
