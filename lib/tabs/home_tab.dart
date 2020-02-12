import 'package:chat_online/widgets/custom_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeTab extends StatelessWidget {

  final PageController pageController;

  HomeTab(this.pageController);

  @override
  Widget build(BuildContext context) {
    Widget _buildBodyBack() => Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Colors.blueAccent,
            Colors.white,
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        );

    return Scaffold(
      drawer: CustomDrawer(this.pageController),
        body: Stack(
          children: <Widget>[
            _buildBodyBack(),
            CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  floating: true,
                  snap: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                  flexibleSpace: FlexibleSpaceBar(
                    title: const Text("MicroNews"),
                    centerTitle: true,
                  ),
                ),
                SliverToBoxAdapter(
                    child: Container(
                  child: Text(
                    "Home",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 34.0, fontWeight: FontWeight.bold),
                  ),
                )),
              ],
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed:() => launch("tel://192"),
          child: Icon(Icons.local_hospital),
          backgroundColor: Colors.red,
        ));
  }
}
