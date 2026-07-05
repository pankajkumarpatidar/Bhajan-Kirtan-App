import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/category_model.dart';

class CategoryRepository {
  CategoryRepository._();

  static final CategoryRepository instance =
      CategoryRepository._();

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>>
      get _collection =>
          _firestore.collection(
            'categories',
          );

  /// ===========================
  /// USER APP
  /// ===========================

  Stream<List<CategoryModel>>
      getCategories() {
    return _collection
        .where(
          'status',
          isEqualTo: true,
        )
        .orderBy('order')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) =>
                    CategoryModel.fromMap(
                  doc.id,
                  doc.data(),
                ),
              )
              .toList(),
        );
  }

  /// ===========================
  /// ADMIN PANEL
  /// ===========================

  Stream<List<CategoryModel>>
      getAllCategories() {
    return _collection
        .orderBy('order')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) =>
                    CategoryModel.fromMap(
                  doc.id,
                  doc.data(),
                ),
              )
              .toList(),
        );
  }

  Future<CategoryModel?> getById(
    String id,
  ) async {

    final doc =
        await _collection.doc(id).get();

    if (!doc.exists) {
      return null;
    }

    return CategoryModel.fromMap(
      doc.id,
      doc.data()!,
    );

  }
  Future<void> addCategory({
    required CategoryModel category,
  }) async {

    await _collection
        .doc(category.id)
        .set(category.toMap());

  }

  Future<void> updateCategory({
    required CategoryModel category,
  }) async {

    await _collection
        .doc(category.id)
        .update(category.toMap());

  }

  Future<void> deleteCategory(
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
        snapshot.docs.first.data()['order'] ?? 0;

    return lastOrder + 1;

  }

  Future<bool> categoryExists(
    String id,
  ) async {

    final doc =
        await _collection
            .doc(id)
            .get();

    return doc.exists;

  }

}