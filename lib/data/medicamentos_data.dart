import 'package:cloud_firestore/cloud_firestore.dart';

class MedicamentosData{

  String id;
  List<dynamic> notificationIDs;
  String medicineName;
  int dosage;
  String medicineType;
  int interval;
  String startTime;

  MedicamentosData.fromDocument(DocumentSnapshot snapshot){
    id = snapshot.documentID;
    notificationIDs = snapshot.data["notificationIDs"];
    medicineName = snapshot.data["medicineName"];
    dosage = snapshot.data["dosage"];
    medicineType = snapshot.data["medicineType"];
    interval = snapshot.data["interval"];
    startTime = snapshot.data["startTime"];
  }

}