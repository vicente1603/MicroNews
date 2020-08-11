import 'package:micro_news/models/usuario_model.dart';
import 'package:micro_news/screens/credenciais/login_screen.dart';
import 'package:micro_news/tiles/drawer_tile.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../services/firestore.dart';

class CustomDrawer extends StatelessWidget {
  final PageController pageController;

  CustomDrawer(this.pageController);

  @override
  Widget build(BuildContext context) {
    Widget _buildDrawerBack() => Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Colors.blueAccent,
            Colors.white,
          ], begin: Alignment.topLeft, end: Alignment.bottomLeft)),
        );

    return Drawer(
      child: Stack(
        children: <Widget>[
          _buildDrawerBack(),
          ListView(
            padding: EdgeInsets.only(left: 32.0, top: 16.0),
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 8.0),
                padding: EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 8.0),
                height: 200.0,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 0.0,
                      left: 0.0,
                      child: Text(
                        "MicroNews",
                        style: TextStyle(
                            fontSize: 40.0, fontWeight: FontWeight.bold, color: Colors.black54),
                      ),
                    ),
                    Positioned(
                      top: 50.0,
                      left: 0.0,
                      child: ScopedModelDescendant<UserModel>(
                        builder: (context, child, model) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Olá, \n${!model.isLoggedIn() ? "" : model.userData["nome"]}!",
                                style: TextStyle(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold, color: Colors.black54),
                              ),
                              Divider(height: 16.0),
                              GestureDetector(
                                child: Text(
                                  "Sair",
                                  style: TextStyle(
                                      color: Colors.redAccent,
                                      fontSize: 25.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                onTap: () {
                                  model.signOut();
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen()));
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.blueGrey,),
              DrawerTile(Icons.home, "Ínicio", pageController, 0),
              DrawerTile(Icons.chat, "Chat", pageController, 1),
              DrawerTile(Icons.help, "Dicas", pageController, 2),
              DrawerTile(Icons.calendar_today, "Consultas e Terapias", pageController, 3),
              DrawerTile(Icons.alarm_add, "Medicamentos", pageController, 4),
              DrawerTile(Icons.child_care, "Desenvolvimento infantil", pageController, 5),
              DrawerTile(Icons.restaurant, "Alimentação", pageController, 6),
              DrawerTile(Icons.accessibility, "Exercícios", pageController, 7),
              DrawerTile(Icons.videogame_asset, "Jogos Infantis", pageController, 8),
              Divider(color: Colors.blueGrey),
              DrawerTile(Icons.star, "Créditos", pageController, 9),
            ],
          )
        ],
      ),
    );
  }
}
