import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_onenote/resources/firebase_provider.dart';

class Repository {
  final _firestoreProvider = FirestoreProvider();

  authenticateUser() => _firestoreProvider.authenticateUserWithGoogle();

  checkAuthState() => _firestoreProvider.checkAuthState();

  Future<void> addTask(Map<String, dynamic> json) =>
      _firestoreProvider.addTask(json);

  Future<void> removeAllOneNoteTasks() =>
      _firestoreProvider.removeAllOneNoteTasks();

  Future<void> updateTask(Map<String, dynamic> json, String docId) =>
      _firestoreProvider.updateTask(json, docId);

  Future<void> removeTask(String docId) => _firestoreProvider.removeTask(docId);

  Future<void> changeDoneOfTask(String docId, bool done) async {
    _firestoreProvider.changeDoneOfTask(docId, done);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> myTaskList(DateTime date) =>
      _firestoreProvider.myTaskList(date);

  Future<DocumentSnapshot<Map<String, dynamic>>> myTask(String docId) =>
      _firestoreProvider.myTask(docId);
}
