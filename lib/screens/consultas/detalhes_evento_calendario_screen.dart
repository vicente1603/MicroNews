import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:micro_news/blocs/app_bloc.dart';
import 'package:micro_news/services/firestore.dart';
import 'package:micro_news/tabs/consultas_tab.dart';
import 'package:provider/provider.dart';
import '../../models/evento_calendario_model.dart';
import '../medicamentos/detalhes_medicamentos_screen.dart';

class EventDetailsPage extends StatelessWidget {
  final EventModel event;

  const EventDetailsPage({Key key, this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    final GlobalBloc _globalBloc = Provider.of<GlobalBloc>(context);

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Details event"),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                MainSection(event: event),
                SizedBox(
                  height: 15,
                ),
                ExtendedSection(event: event),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: RaisedButton(
                      onPressed: () {
                        openAlertBox(context, _globalBloc, uid);
                      },
                      child: Center(
                        child: Text(
                          "Remove",
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                      ),
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  openAlertBox(BuildContext context, GlobalBloc _globalBloc, String uid) {
    return showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: new Text('Remove event'),
            content: new Text('Deseja remover o evento ' + event.titulo + "?"),
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
                  eventDBS.removeItem(event.id);
                  Future.delayed(Duration(seconds: 2)).then((_) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => ConsultasTab()));
                  });
                },
                isDestructiveAction: true,
              ),
            ],
          );
        });
  }
}

class MainSection extends StatelessWidget {
  final EventModel event;

  MainSection({
    Key key,
    @required this.event,
  }) : super(key: key);

  Hero makeIcon(double size) {
    return Hero(
      tag: event.titulo + event.titulo,
      child: Icon(
        Icons.calendar_today,
        color: Colors.blueAccent,
        size: size,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String dataFormatada = DateFormat("dd/MM/yyyy").format(event.data);
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          makeIcon(100),
          SizedBox(
            width: 15,
          ),
          Column(
            children: <Widget>[
              Hero(
                tag: event.titulo,
                child: Material(
                  color: Colors.transparent,
                  child: MainInfoTab(
                    fieldTitle: "Title",
                    fieldInfo: event.titulo,
                  ),
                ),
              ),
              MainInfoTab(
                fieldTitle: "Date",
                fieldInfo: dataFormatada,
              )
            ],
          )
        ],
      ),
    );
  }
}

class ExtendedSection extends StatelessWidget {
  final EventModel event;

  ExtendedSection({Key key, @required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          ExtendedInfoTab(
            fieldTitle: "Description",
            fieldInfo: event.descricao,
          ),
          ExtendedInfoTab(
            fieldTitle: "Local",
            fieldInfo: event.local,
          ),
          ExtendedInfoTab(fieldTitle: "Schedule", fieldInfo: event.horario),
        ],
      ),
    );
  }
}
