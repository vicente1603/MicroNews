import 'package:cloud_firestore/cloud_firestore.dart';

class Medicine {
  String id;
  List<dynamic> notificationIDs;
  String medicineName;
  int dosage;
  final String medicineType;
  int interval;
  String startTime;

  Medicine({
    this.id,
    this.notificationIDs,
    this.medicineName,
    this.dosage,
    this.medicineType,
    this.startTime,
    this.interval,
  });

  String get getId => id;

  String get getName => medicineName;

  int get getDosage => dosage;

  String get getType => medicineType;

  int get getInterval => interval;

  String get getStartTime => startTime;

  List<dynamic> get getIDs => notificationIDs;

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "ids": this.notificationIDs,
      "name": this.medicineName,
      "dosage": this.dosage,
      "type": this.medicineType,
      "interval": this.interval,
      "start": this.startTime,
    };
  }

  factory Medicine.fromJson(Map<String, dynamic> parsedJson) {
    return Medicine(
      id: parsedJson['id'],
      notificationIDs: parsedJson['ids'],
      medicineName: parsedJson['name'],
      dosage: parsedJson['dosage'],
      medicineType: parsedJson['type'],
      interval: parsedJson['interval'],
      startTime: parsedJson['start'],
    );
  }
}
