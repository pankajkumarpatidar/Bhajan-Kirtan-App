import 'dart:async';

import 'package:flutter/material.dart';

import '../models/bhajan_model.dart';
import '../repository/bhajan_repository.dart';

class BhajanProvider extends ChangeNotifier {

  final BhajanRepository _repository =
      BhajanRepository.instance;

  List<BhajanModel> _bhajans = [];

  bool _loading = true;

  String _error = '';

  StreamSubscription<List<BhajanModel>>?
      _subscription;

  List<BhajanModel> get bhajans =>
      _bhajans;

  bool get loading =>
      _loading;

  String get error =>
      _error;

  void startListening() {

    _subscription?.cancel();

    _loading = true;

    notifyListeners();

    _subscription =
        _repository
            .getAllBhajansStream()
            .listen(

      (data) {

        _bhajans = data;

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

  Future<void> addBhajan({

    required BhajanModel bhajan,

  }) async {

    await _repository.addBhajan(
      bhajan: bhajan,
    );

  }

  Future<void> updateBhajan({

    required BhajanModel bhajan,

  }) async {

    await _repository.updateBhajan(
      bhajan: bhajan,
    );

  }

  Future<void> deleteBhajan(

    String id,

  ) async {

    await _repository.deleteBhajan(
      id,
    );

  }

  Future<BhajanModel?> getBhajan(

    String id,

  ) async {

    return await _repository.getById(
      id,
    );

  }

  Future<int> getNextOrder() async {

    return await _repository.getNextOrder();

  }

  Future<String> getNextId() async {

    return await _repository.getNextId();

  }

  Future<List<BhajanModel>> searchBhajans(

    String keyword,

  ) async {

    return await _repository.searchBhajans(
      keyword,
    );

  }

  Future<int> getTotalBhajans() async {

    return await _repository.getTotalBhajans();

  }

  Future<bool> bhajanExists(

    String id,

  ) async {

    return await _repository.bhajanExists(
      id,
    );

  }
  void clear() {

    _bhajans.clear();

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