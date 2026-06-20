import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/bhajan_model.dart';

class BhajanRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Category Wise Bhajans
  Stream<List<BhajanModel>> getBhajans(String categoryId) {
    return _firestore
        .collection('bhajans')
        .where('categoryId', isEqualTo: categoryId)
        .where('status', isEqualTo: true)
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

  /// All Bhajans
  Future<List<BhajanModel>> getAllBhajans() async {
    try {
      final snapshot = await _firestore
          .collection('bhajans')
          .get();

      print("Total Bhajans: ${snapshot.docs.length}");

      return snapshot.docs
          .map(
            (doc) => BhajanModel.fromMap(
              doc.id,
              doc.data(),
            ),
          )
          .toList();
    } catch (e) {
      print("Search Error: $e");
      return [];
    }
  }
}