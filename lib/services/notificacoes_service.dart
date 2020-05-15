//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:micro_news/data/notificacoes_data.dart';
//
//class FirestoreNotificationService {
//  static Future<Stream<QuerySnapshot>> getAllNotifications() async {
//    final firebaseUser = await FirebaseAuth.instance.currentUser();
//
//    final notificationCollectionStream = Firestore.instance
//        .collection("users")
//        .document(firebaseUser.uid)
//        .collection("medicamentos")
//        .snapshots();
//    return notificationCollectionStream;
//  }
//
//  static Future<void> addNotification(NotificationData notification) async {
//    final firebaseUser = await FirebaseAuth.instance.currentUser();
//
//    Firestore.instance
//        .collection("users")
//        .document(firebaseUser.uid)
//        .collection("medicamentos")
//        .add(notification.toJson());
//  }
//
//  static Future<void> removeNotification(NotificationData notification) async {
//    final firebaseUser = await FirebaseAuth.instance.currentUser();
//
//    Firestore.instance
//        .collection("users")
//        .document(firebaseUser.uid)
//        .collection("medicamentos")
//        .document(notification.id)
//        .delete();
//  }
//}
