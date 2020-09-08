//import 'package:micro_news/tabs/alimentacao_tab.dart';
//import 'package:micro_news/tabs/chat_tab.dart';
//import 'package:micro_news/tabs/consultas_tab.dart';
//import 'package:micro_news/tabs/creditos_tab.dart';
//import 'package:micro_news/tabs/desenvolvimento_infantil_tab.dart';
//import 'package:micro_news/tabs/dicas_tab.dart';
//import 'package:micro_news/tabs/exercicios_tab.dart';
//import 'package:micro_news/tabs/home_tab.dart';
//import 'package:micro_news/tabs/jogos_tab.dart';
//import 'package:micro_news/tabs/medicamentos_tab.dart';
//import 'package:micro_news/widgets/custom_drawer.dart';
//import 'package:flutter/material.dart';
//
//class HomeScreen extends StatelessWidget {
//  final _pageController = PageController();
//
//  @override
//  Widget build(BuildContext context) {
//    return PageView(
//      controller: _pageController,
//      physics: NeverScrollableScrollPhysics(),
//      children: <Widget>[
//        Scaffold(
//          appBar: AppBar(
//            title: Text("MicroNews"),
//            centerTitle: true,
//          ),
//          body: HomeTab(),
//          drawer: CustomDrawer(_pageController),
//        ),
//        Scaffold(
//          appBar: AppBar(title: Text("Rede de apoio"), centerTitle: true),
//          body: ChatTab(),
//          drawer: CustomDrawer(_pageController),
//        ),
//        Scaffold(
//          appBar: AppBar(title: Text("Dicas"), centerTitle: true, elevation: 0,),
//          body: DicasTab(),
//          drawer: CustomDrawer(_pageController),
//        ),
//        Scaffold(
//          appBar:
//              AppBar(title: Text("Consultas e Terapias"), centerTitle: true, elevation: 0,),
//          body: ConsultasTab(),
//          drawer: CustomDrawer(_pageController),
//        ),
//        Scaffold(
//          appBar: AppBar(
//            title: Text("Medicamentos"),
//            centerTitle: true,
//            elevation: 0,
//          ),
//          body: MedicamentosTab(),
//          drawer: CustomDrawer(_pageController),
//        ),
//        Scaffold(
//          appBar: AppBar(
//            title: Text("Desenvolvimento infantil"),
//            centerTitle: true,
//            elevation: 0,
//          ),
//          body: DesenvolvimentoInfantilTab(),
//          drawer: CustomDrawer(_pageController),
//        ),
//        Scaffold(
//          appBar: AppBar(
//            title: Text("Alimentação"),
//            centerTitle: true,
//            elevation: 0,
//          ),
//          body: AlimentacaoTab(),
//          drawer: CustomDrawer(_pageController),
//        ),
//        Scaffold(
//          appBar: AppBar(
//            title: Text("Exercícios"),
//            centerTitle: true,
//            elevation: 0,
//          ),
//          body: ExerciciosTab(),
//          drawer: CustomDrawer(_pageController),
//        ),
//        Scaffold(
//          appBar: AppBar(title: Text("Jogos"), centerTitle: true),
//          body: JogosTab(),
//          drawer: CustomDrawer(_pageController),
//        ),
//        Scaffold(
//          appBar: AppBar(title: Text("Créditos"), centerTitle: true, elevation: 0,),
//          body: CreditosTab(),
//          drawer: CustomDrawer(_pageController),
//        ),
//      ],
//    );
//  }
//}
