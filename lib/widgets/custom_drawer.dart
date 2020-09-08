//import 'package:flutter/cupertino.dart';
//import 'package:micro_news/models/usuario_model.dart';
//import 'package:micro_news/screens/credenciais/login_screen.dart';
//import 'package:micro_news/tiles/drawer_tile.dart';
//import 'package:flutter/material.dart';
//import 'package:scoped_model/scoped_model.dart';
//
//class CustomDrawer extends StatelessWidget {
//  final PageController pageController;
//
//  CustomDrawer(this.pageController);
//
//  @override
//  Widget build(BuildContext context) {
//    Widget _buildDrawerBack() => Container(
//          decoration: BoxDecoration(
//              gradient: LinearGradient(colors: [
//            Colors.blueAccent,
//            Colors.white,
//          ], begin: Alignment.topLeft, end: Alignment.bottomLeft)),
//        );
//
//    openAlertBox(BuildContext context, UserModel model) {
//      return showCupertinoDialog(
//          context: context,
//          builder: (context) {
//            return CupertinoAlertDialog(
//              content: Text("Deseja sair do aplicativo?",
//                  style: TextStyle(fontSize: 20)),
//              actions: <Widget>[
//                CupertinoDialogAction(
//                  child: Text("NÃO"),
//                  onPressed: () {
//                    Navigator.of(context).pop(false);
//                  },
//                ),
//                CupertinoDialogAction(
//                  child: Text("SIM"),
//                  onPressed: () {
//                    model.signOut();
//                    Navigator.of(context).popUntil((route) => route.isFirst);
//                    Navigator.of(context).pushReplacement(
//                        MaterialPageRoute(
//                            builder: (context) => LoginScreen()));
//                  },
//                  isDestructiveAction: true,
//                ),
//              ],
//            );
//          });
//    }
//
//    return Drawer(
//      child: Stack(
//        children: <Widget>[
//          _buildDrawerBack(),
//          ListView(
//            padding: EdgeInsets.only(left: 32.0),
//            children: <Widget>[
//              Container(
//                margin: EdgeInsets.only(bottom: 8.0),
//                padding: EdgeInsets.only(top: 40.0),
//                child: ScopedModelDescendant<UserModel>(
//                  builder: (context, child, model) {
//                    return Column(
//                      children: <Widget>[
//                        CircleAvatar(
//                          backgroundImage: NetworkImage(!model.isLoggedIn()
//                              ? "https://ipc.digital/wp-content/uploads/2016/07/icon-user-default.png"
//                              : model.userData["foto"]),
//                          radius: 40,
//                        ),
//                        SizedBox(height: 10.0),
//                        Row(
//                          children: <Widget>[
//                            Expanded(
//                              child: Text(
//                                "Olá, ${!model.isLoggedIn() ? "" : model.userData["nome"]}",
//                                style: TextStyle(
//                                    fontSize: 30.0,
//                                    fontWeight: FontWeight.bold,
//                                    color: Colors.black54),
//                                textAlign: TextAlign.center,
//                              ),
//                            ),
//                          ],
//                        ),
//                        SizedBox(height: 10.0),
//                        GestureDetector(
//                          child: Text(
//                            "Sair",
//                            style: TextStyle(
//                                color: Colors.redAccent,
//                                fontSize: 25.0,
//                                fontWeight: FontWeight.bold),
//                          ),
//                          onTap: () {
//                            openAlertBox(context, model);
//                          },
//                        ),
//                      ],
//                    );
//                  },
//                ),
//              ),
//              Divider(
//                color: Colors.blueGrey,
//              ),
//              DrawerTile(Icons.home, "Ínicio", pageController, 0),
//              DrawerTile(Icons.chat, "Rede de apoio", pageController, 1),
//              DrawerTile(Icons.help, "Dicas", pageController, 2),
//              DrawerTile(Icons.calendar_today, "Consultas e Terapias",
//                  pageController, 3),
//              DrawerTile(Icons.alarm_add, "Medicamentos", pageController, 4),
//              DrawerTile(
//                  Icons.child_care, "Desenvolvimento", pageController, 5),
//              DrawerTile(Icons.restaurant, "Alimentação", pageController, 6),
//              DrawerTile(Icons.accessibility, "Exercícios", pageController, 7),
//              DrawerTile(
//                  Icons.videogame_asset, "Jogos Infantis", pageController, 8),
//              Divider(color: Colors.blueGrey),
//              DrawerTile(Icons.star, "Créditos", pageController, 9),
//            ],
//          )
//        ],
//      ),
//    );
//  }
//}
