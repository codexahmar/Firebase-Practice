import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore ref = FirebaseFirestore.instance;

  Future writePost(String title) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();

    await ref.collection("posts").doc(id).set({
      "title": title,
      "docId": id,
    });
  }

  Stream<QuerySnapshot> getPosts() {
    return ref.collection("posts").snapshots();
  }

  Future updatePost(String id, String title) async {
    await ref.collection("posts").doc(id).update({
      "title": title,
    });
  }

  Future deletePost(String id) async {
    await ref.collection("posts").doc(id).delete();
  }
}