import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {

  AuthRepository._();

  static final AuthRepository instance =
      AuthRepository._();

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  User? get currentUser =>
      _auth.currentUser;

  Future<UserCredential> login({

    required String email,

    required String password,

  }) async {

    return await _auth
        .signInWithEmailAndPassword(

      email: email.trim(),

      password: password.trim(),

    );

  }

  Future<void> logout() async {

    await _auth.signOut();

  }
  Future<bool> isAdmin() async {

    if (currentUser == null) {
      return false;
    }

    final doc = await _firestore
        .collection("admins")
        .doc(currentUser!.uid)
        .get();

    if (!doc.exists) {
      return false;
    }

    final data = doc.data();

    if (data == null) {
      return false;
    }

    return data["status"] == true;

  }

  Future<Map<String, dynamic>?>
      getAdminData() async {

    if (currentUser == null) {
      return null;
    }

    final doc = await _firestore
        .collection("admins")
        .doc(currentUser!.uid)
        .get();

    if (!doc.exists) {
      return null;
    }

    return doc.data();

  }

  Future<bool> checkStatus() async {

    final data =
        await getAdminData();

    if (data == null) {
      return false;
    }

    return data["status"] == true;

  }

  Future<String?> getAdminName() async {

    final data =
        await getAdminData();

    if (data == null) {
      return null;
    }

    return data["name"];

  }

  Future<String?> getAdminEmail() async {

    final data =
        await getAdminData();

    if (data == null) {
      return null;
    }

    return data["email"];

  }
  Future<void> sendPasswordResetEmail({
    required String email,
  }) async {

    await _auth.sendPasswordResetEmail(
      email: email.trim(),
    );

  }

  Future<void> reloadUser() async {

    await currentUser?.reload();

  }

  String? get currentUid {

    return currentUser?.uid;

  }

  String? get currentEmail {

    return currentUser?.email;

  }

  bool get isLoggedIn {

    return currentUser != null;

  }

  Future<void> refreshToken() async {

    await currentUser?.getIdToken(true);

  }

  Future<void> deleteAccount() async {

    if (currentUser != null) {

      await currentUser!.delete();

    }

  }

}