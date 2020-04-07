import 'package:micro_news/tabs/alimentacao_tab.dart';
import 'package:micro_news/tabs/chat_tab.dart';
import 'package:micro_news/tabs/consultas_tab.dart';
import 'package:micro_news/tabs/creditos_tab.dart';
import 'package:micro_news/tabs/dicas_tab.dart';
import 'package:micro_news/tabs/home_tab.dart';
import 'package:micro_news/tabs/jogos_tab.dart';
import 'package:micro_news/tabs/medicacoes_tab.dart';
import 'package:micro_news/widgets/custom_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {

  final _pageController = PageController();
  final DocumentSnapshot snapshot = null;

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Scaffold(
          appBar: AppBar(title: Text("MicroNews"),
              centerTitle: true),
          body: HomeTab(),
          drawer: CustomDrawer(_pageController),
        ),
        Scaffold(
          appBar: AppBar(title: Text("Chat"),
              centerTitle: true),
          body: ChatTab(),
          drawer: CustomDrawer(_pageController),
        ),
        Scaffold(
          appBar: AppBar(title: Text("Dicas"),
              centerTitle: true),
          body: DicasTab(),
          drawer: CustomDrawer(_pageController),
        ),
        Scaffold(
          appBar: AppBar(title: Text("Consultas e Terapias"),
              centerTitle: true),
          body: ConsultasTab(snapshot),
          drawer: CustomDrawer(_pageController),
        ),
        Scaffold(
          appBar: AppBar(title: Text("Medicações"),
              centerTitle: true),
          body: MedicacoesTab(),
          drawer: CustomDrawer(_pageController),
        ),
        Scaffold(
          appBar: AppBar(title: Text("Alimentação"),
              centerTitle: true),
          body: AlimentacaoTab(),
          drawer: CustomDrawer(_pageController),
        ),
        Scaffold(
          appBar: AppBar(title: Text("Jogos"),
              centerTitle: true),
          body: JogosTab(),
          drawer: CustomDrawer(_pageController),
        ),
        Scaffold(
          appBar: AppBar(title: Text("Créditos"),
              centerTitle: true),
          body: CreditosTab(),
          drawer: CustomDrawer(_pageController),
        ),
      ],
    );
  }
}
