import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/bhajan_model.dart';

class BhajanRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<BhajanModel>> getBhajans(String categoryId) {
    print("Searching Category: $categoryId");

    return _firestore
        .collection('bhajans')
        .where('categoryId', isEqualTo: categoryId)
        .where('status', isEqualTo: true)
        .orderBy('order', descending: false)
        .snapshots()
        .map((snapshot) {
          print("Documents Found: ${snapshot.docs.length}");

          return snapshot.docs.map((doc) {
            print(doc.data());

            return BhajanModel.fromMap(
              doc.id,
              doc.data(),
            );
          }).toList();
        });
  }
}