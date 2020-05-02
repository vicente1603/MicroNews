import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:micro_news/models/alimentos_model.dart';
import 'package:micro_news/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class ExerciciosTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 6,
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.blueAccent,
              elevation: 0,
              title: TabBar(
                isScrollable: true,
                indicatorColor: Colors.white,
                tabs: [
                  Tab(text: "Evitar a Postura Viciosa"),
                  Tab(text: "Os benefícios da Fisioterapia"),
                  Tab(text: "Shantala"),
                  Tab(text: "Hipoterapia"),
                  Tab(text: "Hidroterapia"),
                  Tab(text: "Exercícios para casa"),
                ],
              )),
          body: TabBarView(
            children: [
              //1
              Scaffold(
                body: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Colors.blueAccent,
                    Colors.white,
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                  child: SingleChildScrollView(
                    child: Stack(
                      children: <Widget>[
                        StreamBuilder(
                          stream: Firestore.instance
                              .collection("exercicios")
                              .document("EejGIx7xkkA05prQLHzB")
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Column(children: <Widget>[
                                    Text(
                                      snapshot.data["title"],
                                      style: TextStyle(
                                          fontSize: 30.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 20.0),
                                    Text(
                                      snapshot.data["description"],
                                      style: TextStyle(
                                          fontSize: 20.0, color: Colors.black),
                                      textAlign: TextAlign.center,
                                    )
                                  ]));
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),

              //2
              Scaffold(
                body: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Colors.blueAccent,
                    Colors.white,
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                  child: SingleChildScrollView(
                    child: Stack(
                      children: <Widget>[
                        StreamBuilder(
                          stream: Firestore.instance
                              .collection("exercicios")
                              .document("dAnWHjEIDWUlhtnB0UGo")
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Column(children: <Widget>[
                                    Text(
                                      snapshot.data["title"],
                                      style: TextStyle(
                                          fontSize: 30.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 20.0),
                                    Text(
                                      snapshot.data["description"],
                                      style: TextStyle(
                                          fontSize: 20.0, color: Colors.black),
                                      textAlign: TextAlign.center,
                                    )
                                  ]));
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),

              //3
              Scaffold(
                body: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Colors.blueAccent,
                    Colors.white,
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                  child: SingleChildScrollView(
                    child: Stack(
                      children: <Widget>[
                        StreamBuilder(
                          stream: Firestore.instance
                              .collection("exercicios")
                              .document("yP2f2Ad4ltZ3tZmvchEv")
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Column(children: <Widget>[
                                    Text(
                                      snapshot.data["title"],
                                      style: TextStyle(
                                          fontSize: 30.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 20.0),
                                    Text(
                                      snapshot.data["description"],
                                      style: TextStyle(
                                          fontSize: 20.0, color: Colors.black),
                                      textAlign: TextAlign.center,
                                    )
                                  ]));
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),

              //4
              Scaffold(
                body: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Colors.blueAccent,
                    Colors.white,
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                  child: SingleChildScrollView(
                    child: Stack(
                      children: <Widget>[
                        StreamBuilder(
                          stream: Firestore.instance
                              .collection("exercicios")
                              .document("yP2f2Ad4ltZ3tZmvchEv")
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Column(children: <Widget>[
                                    Text(
                                      snapshot.data["title"],
                                      style: TextStyle(
                                          fontSize: 30.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 20.0),
                                    Text(
                                      snapshot.data["description"],
                                      style: TextStyle(
                                          fontSize: 20.0, color: Colors.black),
                                      textAlign: TextAlign.center,
                                    )
                                  ]));
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),

              //5
              Scaffold(
                body: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Colors.blueAccent,
                    Colors.white,
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                  child: SingleChildScrollView(
                    child: Stack(
                      children: <Widget>[
                        StreamBuilder(
                          stream: Firestore.instance
                              .collection("exercicios")
                              .document("4piMAcl8lgYrbeCCGq2O")
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Column(children: <Widget>[
                                    Text(
                                      snapshot.data["title"],
                                      style: TextStyle(
                                          fontSize: 30.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 20.0),
                                    Text(
                                      snapshot.data["description"],
                                      style: TextStyle(
                                          fontSize: 20.0, color: Colors.black),
                                      textAlign: TextAlign.center,
                                    )
                                  ]));
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),

              //6
              Scaffold(
                body: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Colors.blueAccent,
                    Colors.white,
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                  child: SingleChildScrollView(
                    child: Stack(
                      children: <Widget>[
                        StreamBuilder(
                          stream: Firestore.instance
                              .collection("exercicios")
                              .document("VsHZnwTuzoYUozwQpfqQ")
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Column(children: <Widget>[
                                    Text(
                                      snapshot.data["title"],
                                      style: TextStyle(
                                          fontSize: 30.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 20.0),
                                    Text(
                                      snapshot.data["description"],
                                      style: TextStyle(
                                          fontSize: 20.0, color: Colors.black),
                                      textAlign: TextAlign.center,
                                    )
                                  ]));
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
