import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  AuthService._();

  static final AuthService instance =
      AuthService._();

  /// CHANGE THIS
  static const String superAdminEmail =
      "kumarpankajpatidar@gmail.com";

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  User? get currentUser =>
      _auth.currentUser;

  bool get isLoggedIn =>
      _auth.currentUser != null;

  Stream<User?> get authStateChanges =>
      _auth.authStateChanges();

  Stream<User?> get userChanges =>
      _auth.userChanges();

  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    final credential =
        await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    notifyListeners();

    return credential;
  }

  Future<void> logout() async {
    await _auth.signOut();

    notifyListeners();
  }

  Future<void> reloadUser() async {
    await currentUser?.reload();

    notifyListeners();
  }

  Future<void> refreshUser() async {
    if (_auth.currentUser != null) {
      await _auth.currentUser!.reload();

      notifyListeners();
    }
  }

  Future<void> deleteSession() async {
    await logout();
  }

  Future<void> sendPasswordResetEmail(
    String email,
  ) async {
    await _auth.sendPasswordResetEmail(
      email: email.trim(),
    );
  }

  Future<bool> isEmailVerified() async {
    await refreshUser();

    return _auth.currentUser?.emailVerified ??
        false;
  }

  /// ===========================
  /// SUPER ADMIN
  /// ===========================

  bool get isSuperAdmin {
    return currentUser?.email
            ?.toLowerCase() ==
        superAdminEmail.toLowerCase();
  }

  /// ===========================
  /// ADMIN CHECK
  /// ===========================

  Future<bool> isAdmin() async {
    if (currentUser == null) {
      return false;
    }

    if (isSuperAdmin) {
      return true;
    }

    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection("admins")
              .where(
                "email",
                isEqualTo:
                    currentUser!.email,
              )
              .limit(1)
              .get();

      if (snapshot.docs.isEmpty) {
        return false;
      }

      final data =
          snapshot.docs.first.data();

      return data["status"] == true;
    } catch (e) {
      debugPrint(
        "Admin Check Error : $e",
      );

      return false;
    }
  }

  /// ===========================
  /// EDIT / DELETE PERMISSION
  /// ===========================

  Future<bool> canEditDelete() async {
    return isSuperAdmin;
  }

  /// ===========================
  /// MANAGE ADMINS PERMISSION
  /// ===========================

  Future<bool> canManageAdmins() async {
    return isSuperAdmin;
  }
}