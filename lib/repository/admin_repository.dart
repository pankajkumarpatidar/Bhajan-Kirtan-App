import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/admin_model.dart';

class AdminRepository {

  AdminRepository._();

  static final AdminRepository instance =
      AdminRepository._();

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>>
      get _collection =>
          _firestore.collection("admins");

  /// ==========================
  /// GET ALL ADMINS
  /// ==========================

  Stream<List<AdminModel>> getAdmins() {

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

              (doc) => AdminModel.fromMap(

                doc.id,

                doc.data(),

              ),

            )

            .toList();

      },

    );

  }

  /// ==========================
  /// GET ADMIN
  /// ==========================

  Future<AdminModel?> getAdmin(
    String uid,
  ) async {

    final doc =
        await _collection.doc(uid).get();

    if (!doc.exists) {

      return null;

    }

    return AdminModel.fromMap(

      doc.id,

      doc.data()!,

    );

  }

  /// ==========================
  /// ADD ADMIN
  /// ==========================

  Future<void> addAdmin({

    required AdminModel admin,

  }) async {

    await _collection

        .doc(admin.uid)

        .set(admin.toMap());

  }

  /// ==========================
  /// UPDATE ADMIN
  /// ==========================

  Future<void> updateAdmin({

    required AdminModel admin,

  }) async {

    await _collection

        .doc(admin.uid)

        .update(admin.toMap());

  }

  /// ==========================
  /// DELETE ADMIN
  /// ==========================

  Future<void> deleteAdmin(

    String uid,

  ) async {

    await _collection

        .doc(uid)

        .delete();

  }

  /// ==========================
  /// ENABLE / DISABLE
  /// ==========================

  Future<void> updateStatus({

    required String uid,

    required bool status,

  }) async {

    await _collection

        .doc(uid)

        .update({

      "status": status,

    });

  }

  /// ==========================
  /// UPDATE LAST LOGIN
  /// ==========================

  Future<void> updateLastLogin(

    String uid,

  ) async {

    await _collection

        .doc(uid)

        .update({

      "lastLogin":

          FieldValue.serverTimestamp(),

    });

  }

  /// ==========================
  /// CHECK EXISTS
  /// ==========================

  Future<bool> exists(

    String uid,

  ) async {

    final doc =
        await _collection.doc(uid).get();

    return doc.exists;

  }

}