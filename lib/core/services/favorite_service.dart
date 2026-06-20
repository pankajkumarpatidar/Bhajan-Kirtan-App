import 'package:hive_flutter/hive_flutter.dart';

class FavoriteService {
  static const String boxName = "favorites";

  static Future<void> init() async {
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox<bool>(boxName);
    }
  }

  static Box<bool> get _box =>
      Hive.box<bool>(boxName);

  /// Check Favorite
  static bool isFavorite(String bhajanId) {
    return _box.get(
          bhajanId,
          defaultValue: false,
        ) ??
        false;
  }

  /// Add / Remove Favorite
  static Future<void> toggleFavorite(
    String bhajanId,
  ) async {
    if (isFavorite(bhajanId)) {
      await _box.delete(bhajanId);
    } else {
      await _box.put(bhajanId, true);
    }
  }

  /// All Favorite IDs
  static List<String> getAllFavorites() {
    return _box.keys
        .map((e) => e.toString())
        .toList();
  }

  /// Total Favorites
  static int getCount() {
    return _box.length;
  }

  /// Remove All Favorites
  static Future<void> clearFavorites() async {
    await _box.clear();
  }
}