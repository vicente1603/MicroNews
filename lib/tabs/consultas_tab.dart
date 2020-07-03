import 'dart:convert';
import 'package:firebase_helpers/firebase_helpers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:micro_news/screens/consultas/novo_evento_calendario_screen.dart';
import 'package:micro_news/models/evento_calendario_model.dart';
import 'package:micro_news/services/firestore.dart';
import 'package:micro_news/models/usuario_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import '../screens/consultas/detalhes_evento_calendario_screen.dart';

class ConsultasTab extends StatefulWidget {
  @override
  _ConsultasTabState createState() => _ConsultasTabState();
}

class _ConsultasTabState extends State<ConsultasTab> {
  CalendarController _controller;
  SharedPreferences prefs;
  TextEditingController _eventController;
  Map<DateTime, List<dynamic>> _eventos;
  List<dynamic> _eventosSelecionados;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = CalendarController();
    _eventController = TextEditingController();
    _eventos = {};
    _eventosSelecionados = [];
  }

  Map<DateTime, List<dynamic>> _groupEvents(List<EventModel> events) {
    Map<DateTime, List<dynamic>> data = {};
    events.forEach((event) {
      DateTime date =
          DateTime(event.data.year, event.data.month, event.data.day, 12);
      if (data[date] == null) data[date] = [];
      data[date].add(event);
    });

    return data;
  }

  @override
  Widget build(BuildContext context) {
    if (UserModel.of(context).isLoggedIn()) {
      uid = UserModel.of(context).firebaseUser.uid;

      DatabaseService<EventModel> eventosCalendario =
          DatabaseService<EventModel>("$cUsers/$uid/eventos_calendario",
              fromDS: (id, data) => EventModel.fromDS(id, data),
              toMap: (event) => event.toMap());

      return Scaffold(
          body: StreamBuilder<List<EventModel>>(
            stream: eventosCalendario.streamList(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<EventModel> allEvents = snapshot.data;
                if (allEvents.isNotEmpty) {
                  _eventos = _groupEvents(allEvents);
                }
              }
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TableCalendar(
                      events: _eventos,
                      initialCalendarFormat: CalendarFormat.month,
                      calendarStyle: CalendarStyle(
                          todayColor: Colors.orangeAccent,
                          todayStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white),
                          selectedColor: Colors.blueAccent),
                      calendarController: _controller,
                      headerStyle: HeaderStyle(
                          centerHeaderTitle: true,
                          formatButtonDecoration: BoxDecoration(
                              color: Colors.orangeAccent,
                              borderRadius: BorderRadius.circular(20)),
                          formatButtonTextStyle: TextStyle(color: Colors.white),
                          formatButtonShowsNext: false),
                      startingDayOfWeek: StartingDayOfWeek.monday,
                      onDaySelected: (date, events) {
                        setState(() {
                          _eventosSelecionados = events;
                        });
                      },
                      builders: CalendarBuilders(
                          selectedDayBuilder: (context, date, events) =>
                              Container(
                                  margin: const EdgeInsets.all(4.0),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.blueAccent,
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  child: Text(
                                    date.day.toString(),
                                    style: TextStyle(color: Colors.white),
                                  )),
                          todayDayBuilder: (context, date, evets) => Container(
                              margin: const EdgeInsets.all(4.0),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.orangeAccent,
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Text(
                                date.day.toString(),
                                style: TextStyle(color: Colors.white),
                              ))),
                    ),
                    ..._eventosSelecionados.map((event) => Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Card(
                        child: ListTile(
                          leading: Icon(Icons.calendar_today),
                          title: Text(event.titulo),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => EventDetailsPage(
                                      event: event,
                                    )));
                          },
                        ),
                      ),
                    ),
                        )
                  ],
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AddEventPage()));
            },
          ));
    }
  }
}
