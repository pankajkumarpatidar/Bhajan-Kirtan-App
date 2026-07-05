import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/notification_model.dart';
import '../repository/notification_repository.dart';

class NotificationProvider extends ChangeNotifier {

  NotificationProvider();

  final NotificationRepository _repository =
      NotificationRepository.instance;

  List<NotificationModel> _notifications = [];

  final Set<String> _readIds = {};

  bool _loading = true;

  String _error = "";

  StreamSubscription<List<NotificationModel>>?
      _subscription;

  List<NotificationModel> get notifications =>
      _notifications;

  Set<String> get readIds =>
      _readIds;

  bool get loading =>
      _loading;

  String get error =>
      _error;

  int get unreadCount =>
      _notifications
          .where(
            (e) => !_readIds.contains(e.id),
          )
          .length;

  String? get _uid =>
      FirebaseAuth.instance.currentUser?.uid;

  bool isRead(
    String notificationId,
  ) {

    return _readIds.contains(
      notificationId,
    );

  }

  /// ===========================
  /// USER
  /// ===========================

  void startListening() {

    _subscription?.cancel();

    _loading = true;

    notifyListeners();

    _subscription =
        _repository
            .getNotifications()
            .listen(

      (data) async {

        _notifications = data;

        await _loadReadIds();

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

  /// ===========================
  /// ADMIN
  /// ===========================

  void startAdminListening() {

    _subscription?.cancel();

    _loading = true;

    notifyListeners();

    _subscription =
        _repository
            .getAllNotifications()
            .listen(

      (data) {

        _notifications = data;

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
  Future<void> _loadReadIds() async {

    _readIds.clear();

    if (_uid == null) {

      return;

    }

    final ids =
        await _repository.getReadNotificationIds(
      _uid!,
    );

    _readIds.addAll(ids);

  }

  Future<void> refresh({

    bool admin = false,

  }) async {

    if (admin) {

      startAdminListening();

    } else {

      startListening();

    }

  }

  Future<void> markAsRead(

    String notificationId,

  ) async {

    if (_uid == null) return;

    if (_readIds.contains(notificationId)) {

      return;

    }

    await _repository.markAsRead(

      uid: _uid!,

      notificationId: notificationId,

    );

    _readIds.add(notificationId);

    notifyListeners();

  }

  Future<void> addNotification({

    required NotificationModel notification,

  }) async {

    await _repository.addNotification(

      notification: notification,

    );

  }

  Future<void> updateNotification({

    required NotificationModel notification,

  }) async {

    await _repository.updateNotification(

      notification: notification,

    );

  }

  Future<void> deleteNotification(

    String id,

  ) async {

    await _repository.deleteNotification(
      id,
    );

  }

  Future<NotificationModel?> getNotification(

    String id,

  ) async {

    return await _repository.getById(
      id,
    );

  }

  Future<String> getNextId() async {

    return await _repository.getNextId();

  }

  Future<bool> exists(

    String id,

  ) async {

    return await _repository.exists(
      id,
    );

  }

  int get totalNotifications =>

      _notifications.length;

  int get importantNotifications =>

      _notifications
          .where(
            (e) =>
                e.priority ==
                "important",
          )
          .length;

  int get normalNotifications =>

      _notifications
          .where(
            (e) =>
                e.priority ==
                "normal",
          )
          .length;

  void clear() {

    _notifications.clear();

    _readIds.clear();

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