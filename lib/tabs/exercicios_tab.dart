import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:micro_news/models/alimentos_model.dart';

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
              //recomendados
              Scaffold(
                body: Column(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text("Shh, bebezinho, não chore",textAlign: TextAlign.center,)
                      ],
                    )
                  ],
                ),
              ),

              //nao_recomendados
              Scaffold(
                body: Column(),
              ),
              //recomendados
              Scaffold(
                body: Column(),
              ),
              //recomendados
              Scaffold(
                body: Column(),
              ),
              //recomendados
              Scaffold(
                body: Column(),
              ),
              //recomendados
              Scaffold(
                body: Column(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
