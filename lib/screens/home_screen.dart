import 'package:micro_news/blocs/app_bloc.dart';
import 'package:micro_news/tabs/alimentacao_tab.dart';
import 'package:micro_news/tabs/chat_tab.dart';
import 'package:micro_news/tabs/consultas_tab.dart';
import 'package:micro_news/tabs/creditos_tab.dart';
import 'package:micro_news/tabs/dicas_tab.dart';
import 'package:micro_news/tabs/exercicios_tab.dart';
import 'package:micro_news/tabs/home_tab.dart';
import 'package:micro_news/tabs/jogos_tab.dart';
import 'package:micro_news/tabs/medicacoes_tab.dart';
import 'package:micro_news/widgets/custom_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            title: Text("MicroNews"),
            centerTitle: true,
//            actions: <Widget>[
//              FlatButton(
//                child: Text("SOS"),
//                color: Colors.red,
//                shape: RoundedRectangleBorder(
//                    borderRadius: new BorderRadius.circular(),
//                    side: BorderSide(color: Colors.red)),
//                onPressed: () => launch("tel://192"),
//              )
//            ],
          ),
          body: HomeTab(),
          drawer: CustomDrawer(_pageController),
        ),
        Scaffold(
          appBar: AppBar(title: Text("Chat"), centerTitle: true),
          body: ChatTab(),
          drawer: CustomDrawer(_pageController),
        ),
        Scaffold(
          appBar: AppBar(title: Text("Dicas"), centerTitle: true),
          body: DicasTab(),
          drawer: CustomDrawer(_pageController),
        ),
        Scaffold(
          appBar:
              AppBar(title: Text("Consultas e Terapias"), centerTitle: true),
          body: ConsultasTab(),
          drawer: CustomDrawer(_pageController),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Medicamentos"),
            centerTitle: true,
            elevation: 0,
          ),
          body: MedicamentosTab(),
          drawer: CustomDrawer(_pageController),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Alimentação"),
            centerTitle: true,
            elevation: 0,
          ),
          body: AlimentacaoTab(),
          drawer: CustomDrawer(_pageController),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Exercícios"),
            centerTitle: true,
            elevation: 0,
          ),
          body: ExerciciosTab(),
          drawer: CustomDrawer(_pageController),
        ),
        Scaffold(
          appBar: AppBar(title: Text("Jogos"), centerTitle: true),
          body: JogosTab(),
          drawer: CustomDrawer(_pageController),
        ),
        Scaffold(
          appBar: AppBar(title: Text("Créditos"), centerTitle: true),
          body: CreditosTab(),
          drawer: CustomDrawer(_pageController),
        ),
      ],
    );
  }

  Future _getThingsOnStartup() async {
    await Future.delayed(Duration(seconds: 2));
  }
}
