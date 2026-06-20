import 'package:hive_flutter/hive_flutter.dart';

class FavoriteService {
  static const String boxName = "favorites";

  static Future<void> init() async {
    await Hive.openBox(boxName);
  }

  static Box get _box => Hive.box(boxName);

  static bool isFavorite(String bhajanId) {
    return _box.get(bhajanId, defaultValue: false);
  }

  static Future<void> toggleFavorite(String bhajanId) async {
    final fav = isFavorite(bhajanId);

    if (fav) {
      await _box.delete(bhajanId);
    } else {
      await _box.put(bhajanId, true);
    }
  }

  static List<String> getAllFavorites() {
    return _box.keys.cast<String>().toList();
  }
}