import 'package:flutter/material.dart';

import '../core/services/auth_service.dart';
import '../core/services/session_service.dart';

class AuthProvider extends ChangeNotifier {

  bool _loading = false;

  bool get loading => _loading;

  bool get isLoggedIn =>
      AuthService.instance.isLoggedIn;

  bool _isAdmin = false;

  bool get isAdmin => _isAdmin;

  Future<void> initialize() async {

    final valid =
        await SessionService.instance
            .validateSession();

    if (!valid) {

      _isAdmin = false;

      notifyListeners();

      return;

    }

    _isAdmin =
        await AuthService.instance
            .isAdmin();

    notifyListeners();

  }
  Future<bool> login({

    required String email,

    required String password,

  }) async {

    try {

      _loading = true;

      notifyListeners();

      await AuthService.instance.login(

        email: email,

        password: password,

      );

      final admin =
          await AuthService.instance
              .isAdmin();

      if (!admin) {

        await AuthService.instance.logout();

        _loading = false;

        notifyListeners();

        return false;

      }

      await SessionService.instance
          .onLoginSuccess();

      _isAdmin = true;

      _loading = false;

      notifyListeners();

      return true;

    } catch (e) {

      _loading = false;

      notifyListeners();

      rethrow;

    }

  }

  Future<void> logout() async {

    _loading = true;

    notifyListeners();

    await SessionService.instance
        .onLogout();

    _isAdmin = false;

    _loading = false;

    notifyListeners();

  }
  Future<void> refresh() async {

    await initialize();

  }

  Future<bool> checkAdminStatus() async {

    final admin =
        await AuthService.instance
            .isAdmin();

    _isAdmin = admin;

    notifyListeners();

    return admin;

  }

  void setLoading(bool value) {

    _loading = value;

    notifyListeners();

  }

  

}