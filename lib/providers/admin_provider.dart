import 'dart:async';

import 'package:flutter/material.dart';

import '../models/admin_model.dart';
import '../repository/admin_repository.dart';

class AdminProvider extends ChangeNotifier {

  final AdminRepository _repository =
      AdminRepository.instance;

  List<AdminModel> _admins = [];

  bool _loading = true;

  String _error = '';

  StreamSubscription<List<AdminModel>>?
      _subscription;

  List<AdminModel> get admins =>
      _admins;

  bool get loading => _loading;

  String get error => _error;

  /// ==========================
  /// START LISTENING
  /// ==========================

  void startListening() {

    _subscription?.cancel();

    _loading = true;

    notifyListeners();

    _subscription =
        _repository.getAdmins().listen(

      (data) {

        _admins = data;

        _loading = false;

        _error = "";

        notifyListeners();

      },

      onError: (e) {

        _loading = false;

        _error = e.toString();

        notifyListeners();

      },

    );

  }

  /// ==========================
  /// REFRESH
  /// ==========================

  Future<void> refresh() async {

    startListening();

  }

  /// ==========================
  /// GET ADMIN
  /// ==========================

  Future<AdminModel?> getAdmin(

    String uid,

  ) async {

    return await _repository.getAdmin(
      uid,
    );

  }

  /// ==========================
  /// ADD ADMIN
  /// ==========================

  Future<void> addAdmin({

    required AdminModel admin,

  }) async {

    await _repository.addAdmin(
      admin: admin,
    );

  }

  /// ==========================
  /// UPDATE ADMIN
  /// ==========================

  Future<void> updateAdmin({

    required AdminModel admin,

  }) async {

    await _repository.updateAdmin(
      admin: admin,
    );

  }

  /// ==========================
  /// DELETE ADMIN
  /// ==========================

  Future<void> deleteAdmin(

    String uid,

  ) async {

    await _repository.deleteAdmin(
      uid,
    );

  }

  /// ==========================
  /// ENABLE / DISABLE
  /// ==========================

  Future<void> updateStatus({

    required String uid,

    required bool status,

  }) async {

    await _repository.updateStatus(

      uid: uid,

      status: status,

    );

  }

  /// ==========================
  /// UPDATE LAST LOGIN
  /// ==========================

  Future<void> updateLastLogin(

    String uid,

  ) async {

    await _repository.updateLastLogin(
      uid,
    );

  }

  /// ==========================
  /// CHECK EXISTS
  /// ==========================

  Future<bool> exists(

    String uid,

  ) async {

    return await _repository.exists(
      uid,
    );

  }

  /// ==========================
  /// TOTAL ADMINS
  /// ==========================

  int get totalAdmins =>
      _admins.length;

  int get activeAdmins =>
      _admins
          .where((e) => e.status)
          .length;

  int get inactiveAdmins =>
      _admins
          .where((e) => !e.status)
          .length;

  /// ==========================
  /// CLEAR
  /// ==========================

  void clear() {

    _admins.clear();

    _loading = false;

    _error = "";

    notifyListeners();

  }

  @override
  void dispose() {

    _subscription?.cancel();

    super.dispose();

  }

}