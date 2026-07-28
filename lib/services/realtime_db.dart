import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class RealtimeDb {
  final _dbRef = FirebaseDatabase.instance.ref();

  String _handleDbException(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return 'You do not have permission to perform this action.';
      case 'network-error':
        return 'A network error occurred. Please check your connection.';
      case 'disconnected':
        return 'The database connection was lost. Please try again.';
      default:
        return e.message ?? 'Database operation failed. Please try again.';
    }
  }

  Future writePost(String title) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      await _dbRef.child("posts").child(id).set({"id": id, "title": title});
    } on FirebaseException catch (e) {
      throw _handleDbException(e);
    } catch (e) {
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  Future updatePost(String id, String title) async {
    try {
      await _dbRef.child("posts").child(id).update({"title": title});
    } on FirebaseException catch (e) {
      throw _handleDbException(e);
    } catch (e) {
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  Future deletePost(String id) async {
    try {
      await _dbRef.child("posts").child(id).remove();
    } on FirebaseException catch (e) {
      throw _handleDbException(e);
    } catch (e) {
      throw 'An unexpected error occurred. Please try again.';
    }
  }
}
