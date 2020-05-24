import 'package:firebase_helpers/firebase_helpers.dart';
import 'event_model.dart';

String cUsers = "users";
String uid;

DatabaseService<EventModel> eventDBS = DatabaseService<EventModel>(
    "$cUsers/$uid/eventos",
    fromDS: (id, data) => EventModel.fromDS(id, data),
    toMap: (event) => event.toMap());

