import 'dart:async';

import 'package:flutter/material.dart';

import '../models/category_model.dart';
import '../repository/category_repository.dart';

class CategoryProvider extends ChangeNotifier {

  final CategoryRepository _repository = CategoryRepository();

  List<CategoryModel> _categories = [];

  bool _loading = true;

  String _error = '';

  StreamSubscription? _subscription;

  List<CategoryModel> get categories => _categories;

  bool get loading => _loading;

  String get error => _error;

  void startListening() {

    _subscription?.cancel();

    _loading = true;

    notifyListeners();

    _subscription = _repository.getCategories().listen(

      (data) {

        _categories = data;

        _loading = false;

        notifyListeners();

      },

      onError: (e) {

        _error = e.toString();

        _loading = false;

        notifyListeners();

      },

    );
  }

  @override
  void dispose() {

    _subscription?.cancel();

    super.dispose();

  }
}