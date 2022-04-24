import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

class FirestoreProvider {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _user = FirebaseAuth.instance;

  int checkAuthState() {
    if (_user.currentUser == null) {
      return 0;
    } else {
      return 1;
    }
  }

  authenticateUserWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  addTask(json) async {
    return await _firestore
        .collection("users")
        .doc(_user.currentUser!.uid)
        .collection("tasks")
        .add(json);
  }

  updateTask(json, docId) async {
    return await _firestore
        .collection("users")
        .doc(_user.currentUser!.uid)
        .collection("tasks")
        .doc(docId)
        .update(json);
  }

  removeTask(docId) async {
    return await _firestore
        .collection("users")
        .doc(_user.currentUser!.uid)
        .collection("tasks")
        .doc(docId)
        .delete();
  }

  changeDoneOfTask(docId, done) async {
    return await _firestore
        .collection("users")
        .doc(_user.currentUser!.uid)
        .collection("tasks")
        .doc(docId)
        .update({"done": !done});
  }

  removeAllOneNoteTasks() async {
    return await _firestore
        .collection("users")
        .doc(_user.currentUser!.uid)
        .collection("tasks")
        .where("fromOneNote", isEqualTo: true)
        .get()
        .then((value) {
      for (DocumentSnapshot ds in value.docs) {
        ds.reference.delete();
      }
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> myTaskList(date) {
    return _firestore
        .collection("users")
        .doc(_user.currentUser!.uid)
        .collection("tasks")
        .where(
          "dateForSort",
          isEqualTo: DateFormat('yyyy-MM-dd')
              .format(DateTime(date.year, date.month, date.day)),
        )
        .snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> myTask(docId) {
    return _firestore
        .collection("users")
        .doc(_user.currentUser!.uid)
        .collection("tasks")
        .doc(docId)
        .get();
  }
}
