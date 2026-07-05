import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/bhajan_model.dart';

class BhajanRepository {

  BhajanRepository._();

  static final BhajanRepository instance =
      BhajanRepository._();

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>>
      get _collection =>
          _firestore.collection(
            'bhajans',
          );

  /// ==========================
  /// USER APP
  /// ==========================

  Stream<List<BhajanModel>> getBhajans(

    String categoryId,

  ) {

    return _collection

        .where(
          'categoryId',
          isEqualTo: categoryId,
        )

        .where(
          'status',
          isEqualTo: true,
        )

        .orderBy('order')

        .snapshots()

        .map(

          (snapshot) => snapshot.docs

              .map(

                (doc) => BhajanModel.fromMap(

                  doc.id,

                  doc.data(),

                ),

              )

              .toList(),

        );

  }

  /// ==========================
  /// ADMIN PANEL
  /// ==========================

  Stream<List<BhajanModel>>
      getAllBhajansStream() {

    return _collection

        .orderBy('order')

        .snapshots()

        .map(

          (snapshot) => snapshot.docs

              .map(

                (doc) => BhajanModel.fromMap(

                  doc.id,

                  doc.data(),

                ),

              )

              .toList(),

        );

  }

  Future<List<BhajanModel>>
      getAllBhajans() async {

    final snapshot =
        await _collection
            .orderBy('order')
            .get();

    return snapshot.docs

        .map(

          (doc) => BhajanModel.fromMap(

            doc.id,

            doc.data(),

          ),

        )

        .toList();

  }

  Future<BhajanModel?> getById(

    String id,

  ) async {

    final doc =
        await _collection.doc(id).get();

    if (!doc.exists) {

      return null;

    }

    return BhajanModel.fromMap(

      doc.id,

      doc.data()!,

    );

  }
  Future<void> addBhajan({
    required BhajanModel bhajan,
  }) async {

    await _collection
        .doc(bhajan.id)
        .set(bhajan.toMap());

  }

  Future<void> updateBhajan({
    required BhajanModel bhajan,
  }) async {

    await _collection
        .doc(bhajan.id)
        .update(bhajan.toMap());

  }

  Future<void> deleteBhajan(
    String id,
  ) async {

    await _collection
        .doc(id)
        .delete();

  }

  Future<int> getNextOrder() async {

    final snapshot =
        await _collection
            .orderBy(
              'order',
              descending: true,
            )
            .limit(1)
            .get();

    if (snapshot.docs.isEmpty) {
      return 1;
    }

    final lastOrder =
        (snapshot.docs.first.data()['order'] ?? 0)
            as int;

    return lastOrder + 1;

  }

  Future<bool> bhajanExists(
    String id,
  ) async {

    final doc =
        await _collection
            .doc(id)
            .get();

    return doc.exists;

  }
  Future<String> getNextId() async {

    final snapshot =
        await _collection.get();

    int max = 0;

    for (final doc in snapshot.docs) {

      final id = doc.id;

      if (!id.startsWith("KIRTAN-")) {
        continue;
      }

      final number = int.tryParse(
        id.substring(8),
      );

      if (number != null && number > max) {
        max = number;
      }

    }

    final next = max + 1;

    return "KIRTAN-${next.toString().padLeft(4, '0')}";

  }

  Future<List<BhajanModel>> searchBhajans(
    String keyword,
  ) async {

    final allBhajans =
        await getAllBhajans();

    final text =
        keyword.trim().toLowerCase();

    if (text.isEmpty) {
      return allBhajans;
    }

    return allBhajans.where((bhajan) {

      return bhajan.title
              .toLowerCase()
              .contains(text) ||

          bhajan.lyrics
              .toLowerCase()
              .contains(text) ||

          bhajan.categoryId
              .toLowerCase()
              .contains(text);

    }).toList();

  }

  Future<int> getTotalBhajans() async {

    final snapshot =
        await _collection.get();

    return snapshot.size;

  }

}