import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_service.dart';

class SessionService {

  SessionService._();

  static final SessionService instance =
      SessionService._();

  static const _loginTimeKey =
      "login_time";

  static const sessionHours = 24;

  Future<void> saveLoginTime() async {

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setInt(

      _loginTimeKey,

      DateTime.now()
          .millisecondsSinceEpoch,

    );

  }

  Future<bool> isSessionValid() async {

    final prefs =
        await SharedPreferences.getInstance();

    final loginTime =
        prefs.getInt(_loginTimeKey);

    if (loginTime == null) {

      return false;

    }

    final loginDate =
        DateTime.fromMillisecondsSinceEpoch(
      loginTime,
    );

    final difference =
        DateTime.now().difference(
      loginDate,
    );

    return difference.inHours <
        sessionHours;

  }
  Future<void> clearSession() async {

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove(_loginTimeKey);

  }

  Future<void> logout() async {

    await clearSession();

    await AuthService.instance.logout();

  }

  Future<bool> checkSession() async {

    final loggedIn =
        AuthService.instance.isLoggedIn;

    if (!loggedIn) {

      return false;

    }

    final valid =
        await isSessionValid();

    if (!valid) {

      await logout();

      debugPrint(
        "Session Expired",
      );

      return false;

    }

    return true;

  }

  Future<void> refreshSession() async {

    await saveLoginTime();

  }
  Future<bool> validateSession() async {

    try {

      if (!AuthService.instance.isLoggedIn) {
        return false;
      }

      await AuthService.instance.refreshUser();

      final user =
          AuthService.instance.currentUser;

      if (user == null) {

        await logout();

        return false;

      }

      final valid =
          await isSessionValid();

      if (!valid) {

        await logout();

        return false;

      }

      return true;

    } catch (e) {

      debugPrint(
        "Session Error : $e",
      );

      await logout();

      return false;

    }

  }

  Future<void> onLoginSuccess() async {

    await saveLoginTime();

  }

  Future<void> onLogout() async {

    await logout();

  }

}