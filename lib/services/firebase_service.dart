import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign in user
  Future<User?> signIn(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Error signing in: $e");
      throw e;
    }
  }

  // Sign up user
  Future<User?> signUp(String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Error signing up: $e");
      throw e;
    }
  }

  // Add stock to Firestore
  Future<void> addStockToWatchlist(String userId, String stockSymbol) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('watchlist')
          .doc(stockSymbol)
          .set({'symbol': stockSymbol});
    } catch (e) {
      print("Error adding stock: $e");
      throw e;
    }
  }

  // Get user's watchlist
  Future<List<String>> getWatchlist(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('watchlist')
          .get();
      return snapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      print("Error fetching watchlist: $e");
      throw e;
    }
  }
}
