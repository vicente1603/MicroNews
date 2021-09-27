import 'package:micro_news/tiles/category_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:micro_news/widgets/custom_drawer_guitar.dart';

class DicasTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      centerTitle: true,
      title: Text(
        "Tips",
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
    Widget child = _DicasTab(appBar: appBar);

    child = CustomGuitarDrawer(child: child);

    return child;
  }
}

class _DicasTab extends StatelessWidget {
  final AppBar appBar;

  _DicasTab({Key key, @required this.appBar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: FutureBuilder<QuerySnapshot>(
        future: Firestore.instance.collection("dicas").getDocuments(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView(
              children: snapshot.data.documents.map((doc) {
                return CategoryTile(doc);
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
