import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:micro_news/models/usuario_model.dart';
import 'package:micro_news/screens/credenciais/login_screen.dart';
import 'package:micro_news/tabs/alimentacao_tab.dart';
import 'package:micro_news/tabs/chat_tab.dart';
import 'package:micro_news/tabs/consultas_tab.dart';
import 'package:micro_news/tabs/creditos_tab.dart';
import 'package:micro_news/tabs/desenvolvimento_infantil_tab.dart';
import 'package:micro_news/tabs/dicas_tab.dart';
import 'package:micro_news/tabs/exercicios_tab.dart';
import 'package:micro_news/tabs/home_tab.dart';
import 'package:micro_news/tabs/jogos_tab.dart';
import 'package:micro_news/tabs/medicamentos_tab.dart';
import 'package:scoped_model/scoped_model.dart';

class CustomGuitarDrawer extends StatefulWidget {
  final Widget child;

  const CustomGuitarDrawer({Key key, this.child}) : super(key: key);

  static CustomGuitarDrawerState of(BuildContext context) =>
      context.findAncestorStateOfType<CustomGuitarDrawerState>();

  @override
  CustomGuitarDrawerState createState() => new CustomGuitarDrawerState();
}

class CustomGuitarDrawerState extends State<CustomGuitarDrawer>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  bool _canBeDragged = false;
  final double maxSlide = 300.0;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void close() => animationController.reverse();

  void open() => animationController.forward();

  void toggle() => animationController.isDismissed
      ? animationController.forward()
      : animationController.reverse();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: _onDragStart,
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      behavior: HitTestBehavior.translucent,
      onTap: toggle,
      child: AnimatedBuilder(
        animation: animationController,
        builder: (context, _) {
          return Material(
            color: Colors.blueAccent[100],
            child: Stack(
              children: <Widget>[
                Transform.translate(
                  offset: Offset(maxSlide * (animationController.value - 1), 0),
                  child: Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(math.pi / 2 * (1 - animationController.value)),
                    alignment: Alignment.centerRight,
                    child: MyDrawer(),
                  ),
                ),
                Transform.translate(
                  offset: Offset(maxSlide * animationController.value, 0),
                  child: Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(-math.pi * animationController.value / 2),
                    alignment: Alignment.centerLeft,
                    child: widget.child,
                  ),
                ),
                Positioned(
                  top: 4.0 + MediaQuery.of(context).padding.top,
                  left: 4.0 + animationController.value * maxSlide,
                  child: IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: toggle,
                    color: Colors.white,
                  ),
                ),
                Positioned(
                  top: 16.0 + MediaQuery.of(context).padding.top,
                  left: animationController.value *
                      MediaQuery.of(context).size.width,
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "MicroNews®",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _onDragStart(DragStartDetails details) {
    bool isDragOpenFromLeft = animationController.isDismissed;
    bool isDragCloseFromRight = animationController.isCompleted;
    _canBeDragged = isDragOpenFromLeft || isDragCloseFromRight;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_canBeDragged) {
      double delta = details.primaryDelta / maxSlide;
      animationController.value += delta;
    }
  }

  void _onDragEnd(DragEndDetails details) {
    double _kMinFlingVelocity = 365.0;

    if (animationController.isDismissed || animationController.isCompleted) {
      return;
    }
    if (details.velocity.pixelsPerSecond.dx.abs() >= _kMinFlingVelocity) {
      double visualVelocity = details.velocity.pixelsPerSecond.dx /
          MediaQuery.of(context).size.width;

      animationController.fling(velocity: visualVelocity);
    } else if (animationController.value < 0.5) {
      animationController.reverse();
    } else {
      animationController.forward();
    }
  }
}

openAlertBox(BuildContext context, UserModel model) {
  return showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          content: Text("Deseja sair do aplicativo?",
              style: TextStyle(fontSize: 20)),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text("NÃO"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            CupertinoDialogAction(
              child: Text("SIM"),
              onPressed: () {
                model.signOut();
                Navigator.of(context).popUntil((route) => route.isFirst);
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              isDestructiveAction: true,
            ),
          ],
        );
      });
}

class MyDrawer extends StatelessWidget {
  bool paginaSelecionada = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        Colors.blueAccent,
        Colors.white,
      ], begin: Alignment.topLeft, end: Alignment.bottomLeft)),
      width: 300,
      height: double.infinity,
      child: SafeArea(
        child: ListView(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 8.0),
                  padding: EdgeInsets.only(top: 40.0),
                  child: ScopedModelDescendant<UserModel>(
                    builder: (context, child, model) {
                      return Column(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundImage: NetworkImage(!model.isLoggedIn()
                                ? "https://ipc.digital/wp-content/uploads/2016/07/icon-user-default.png"
                                : model.userData["foto"]),
                            radius: 40,
                          ),
                          SizedBox(height: 10.0),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  "Olá, ${!model.isLoggedIn() ? "" : model.userData["nome"]}",
                                  style: TextStyle(
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0),
                          GestureDetector(
                            child: Text(
                              "Sair",
                              style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            onTap: () {
                              openAlertBox(context, model);
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Divider(
                  thickness: 1,
                  color: Colors.blueGrey,
                ),
                ListTile(
                  leading: Icon(Icons.home, size: 32.0),
                  title: Text("Ínicio",
                      style: TextStyle(fontSize: 16.0, color: Colors.black)),
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => HomeTab()));
                    paginaSelecionada = true;
                  },
                ),
                ListTile(
                    leading: Icon(Icons.chat, size: 32.0),
                    title: Text("Rede de apoio",
                        style: TextStyle(fontSize: 16.0, color: Colors.black)),
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => ChatTab()));
                    }),
                ListTile(
                  leading: Icon(Icons.help, size: 32.0),
                  title: Text("Dicas",
                      style: TextStyle(fontSize: 16.0, color: Colors.black)),
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => DicasTab()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.calendar_today, size: 32.0),
                  title: Text("Consultas e Terapias",
                      style: TextStyle(fontSize: 16.0, color: Colors.black)),
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => ConsultasTab()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.alarm_add, size: 32.0),
                  title: Text("Medicamentos",
                      style: TextStyle(fontSize: 16.0, color: Colors.black)),
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => MedicamentosTab()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.child_care, size: 32.0),
                  title: Text("Desenvolvimento",
                      style: TextStyle(fontSize: 16.0, color: Colors.black)),
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => DesenvolvimentoInfantilTab()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.restaurant, size: 32.0),
                  title: Text("Alimentação",
                      style: TextStyle(fontSize: 16.0, color: Colors.black)),
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => AlimentacaoTab()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.accessibility, size: 32.0),
                  title: Text("Exercícios",
                      style: TextStyle(fontSize: 16.0, color: Colors.black)),
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => ExerciciosTab()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.videogame_asset, size: 32.0),
                  title: Text("Jogos Infantis",
                      style: TextStyle(fontSize: 16.0, color: Colors.black)),
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => JogosTab()));
                  },
                ),
                Divider(
                  thickness: 1,
                  color: Colors.blueGrey,
                ),
                ListTile(
                  leading: Icon(Icons.star, size: 32.0),
                  title: Text("Créditos",
                      style: TextStyle(fontSize: 16.0, color: Colors.black)),
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => CreditosTab()));
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
