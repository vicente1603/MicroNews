import 'package:chat_online/tabs/alimentacao_tab.dart';
import 'package:chat_online/tabs/chat_tab.dart';
import 'package:chat_online/tabs/consultas_tab.dart';
import 'package:chat_online/tabs/creditos_tab.dart';
import 'package:chat_online/tabs/dicas_tab.dart';
import 'package:chat_online/tabs/home_tab.dart';
import 'package:chat_online/tabs/medicacoes_tab.dart';
import 'package:chat_online/widgets/custom_drawer.dart';
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
          body: HomeTab(this._pageController),
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
          body: ConsultasTab(),
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
          appBar: AppBar(title: Text("Créditos"),
              centerTitle: true),
          body: CreditosTab(),
          drawer: CustomDrawer(_pageController),
        ),
      ],
    );
  }
}
