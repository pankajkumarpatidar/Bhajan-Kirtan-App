import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/notification_model.dart';

class NotificationRepository {

  NotificationRepository._();

  static final NotificationRepository instance =
      NotificationRepository._();

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>>
      get _collection =>
          _firestore.collection(
            "notifications",
          );

  CollectionReference<Map<String, dynamic>>
      get _readCollection =>
          _firestore.collection(
            "notification_reads",
          );

  /// ===========================
  /// USER APP
  /// ===========================

  Stream<List<NotificationModel>>
      getNotifications() {

    final sevenDaysAgo =
        DateTime.now().subtract(

      const Duration(days: 7),

    );

    return _collection

        .where(
          "status",
          isEqualTo: true,
        )

        .where(
          "createdAt",
          isGreaterThanOrEqualTo:
              Timestamp.fromDate(
            sevenDaysAgo,
          ),
        )

        .orderBy(
          "createdAt",
          descending: true,
        )

        .snapshots()

        .map(

      (snapshot) {

        return snapshot.docs

            .map(

              (doc) => NotificationModel.fromMap(

                doc.id,

                doc.data(),

              ),

            )

            .toList();

      },

    );

  }

  /// ===========================
  /// ADMIN
  /// ===========================

  Stream<List<NotificationModel>>
      getAllNotifications() {

    return _collection

        .orderBy(

          "createdAt",

          descending: true,

        )

        .snapshots()

        .map(

      (snapshot) {

        return snapshot.docs

            .map(

              (doc) => NotificationModel.fromMap(

                doc.id,

                doc.data(),

              ),

            )

            .toList();

      },

    );

  }

  Future<NotificationModel?> getById(

    String id,

  ) async {

    final doc =

        await _collection

            .doc(id)

            .get();

    if (!doc.exists) {

      return null;

    }

    return NotificationModel.fromMap(

      doc.id,

      doc.data()!,

    );

  }

  Future<void> addNotification({

    required NotificationModel notification,

  }) async {

    await _collection

        .doc(notification.id)

        .set(

          notification.toMap(),

        );

  }

  Future<void> updateNotification({

    required NotificationModel notification,

  }) async {

    await _collection

        .doc(notification.id)

        .update(

          notification.toMap(),

        );

  }

  Future<void> deleteNotification(

    String id,

  ) async {

    await _collection

        .doc(id)

        .delete();

  }
  Future<bool> exists(

    String id,

  ) async {

    final doc =
        await _collection
            .doc(id)
            .get();

    return doc.exists;

  }

  Future<String> getNextId()
      async {

    final snapshot =
        await _collection
            .orderBy(
              "createdAt",
              descending: true,
            )
            .limit(1)
            .get();

    if (snapshot.docs.isEmpty) {

      return "notification_1";

    }

    return DateTime.now()
        .millisecondsSinceEpoch
        .toString();

  }

  /// ===========================
  /// READ / UNREAD
  /// ===========================

  Future<Set<String>>
      getReadNotificationIds(

    String uid,

  ) async {

    final snapshot =
        await _readCollection

            .where(
              "uid",
              isEqualTo: uid,
            )

            .get();

    return snapshot.docs

        .map(

          (doc) => doc["notificationId"]
              as String,

        )

        .toSet();

  }

  Future<void> markAsRead({

    required String uid,

    required String notificationId,

  }) async {

    await _readCollection

        .doc("${uid}_$notificationId")

        .set({

      "uid": uid,

      "notificationId":
          notificationId,

      "readAt":
          FieldValue.serverTimestamp(),

    });

  }

}