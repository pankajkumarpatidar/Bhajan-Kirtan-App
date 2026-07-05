import 'dart:async';

import 'package:flutter/material.dart';

import '../models/category_model.dart';
import '../repository/category_repository.dart';

class CategoryProvider extends ChangeNotifier {

  final CategoryRepository _repository =
      CategoryRepository.instance;

  List<CategoryModel> _categories = [];

  bool _loading = true;

  String _error = '';

  StreamSubscription<List<CategoryModel>>?
      _subscription;

  List<CategoryModel> get categories =>
      _categories;

  bool get loading => _loading;

  String get error => _error;

  void startListening() {

    _subscription?.cancel();

    _loading = true;

    notifyListeners();

    _subscription =
        _repository.getAllCategories().listen(

      (data) {

        _categories = data;

        _loading = false;

        _error = '';

        notifyListeners();

      },

      onError: (e) {

        _error = e.toString();

        _loading = false;

        notifyListeners();

      },

    );

  }
  Future<void> refresh() async {

    startListening();

  }

  Future<void> addCategory({

    required CategoryModel category,

  }) async {

    await _repository.addCategory(
      category: category,
    );

  }

  Future<void> updateCategory({

    required CategoryModel category,

  }) async {

    await _repository.updateCategory(
      category: category,
    );

  }

  Future<void> deleteCategory(

    String id,

  ) async {

    await _repository.deleteCategory(
      id,
    );

  }

  Future<CategoryModel?> getCategory(

    String id,

  ) async {

    return await _repository.getById(
      id,
    );

  }

  Future<int> getNextOrder() async {

    return await _repository.getNextOrder();

  }

  Future<bool> categoryExists(

    String id,

  ) async {

    return await _repository.categoryExists(
      id,
    );

  }
  void clear() {

    _categories.clear();

    _error = '';

    _loading = false;

    notifyListeners();

  }

  @override
  void dispose() {

    _subscription?.cancel();

    super.dispose();

  }

}