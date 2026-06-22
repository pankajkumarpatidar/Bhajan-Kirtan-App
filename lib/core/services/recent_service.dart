import 'package:hive_flutter/hive_flutter.dart';

class RecentService {
  static const String boxName = "recent";
  static const String recentKey = "recent";

  static Future<void> init() async {
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox(boxName);
    }
  }

  static Box get _box => Hive.box(boxName);

  /// Add Recently Played
  static Future<void> addRecent(
    String bhajanId,
  ) async {
    List<String> list = List<String>.from(
      _box.get(
        recentKey,
        defaultValue: <String>[],
      ),
    );

    list.remove(bhajanId);

    list.insert(0, bhajanId);

    if (list.length > 50) {
      list = list.sublist(0, 50);
    }

    await _box.put(
      recentKey,
      list,
    );
  }

  /// Get All Recent IDs
  static List<String> getRecentIds() {
    return List<String>.from(
      _box.get(
        recentKey,
        defaultValue: <String>[],
      ),
    );
  }

  /// Remove One Bhajan
  static Future<void> removeRecent(
    String bhajanId,
  ) async {
    List<String> list = getRecentIds();

    list.remove(bhajanId);

    await _box.put(
      recentKey,
      list,
    );
  }

  /// Clear History
  static Future<void> clear() async {
    await _box.delete(recentKey);
  }

  /// Total Recent Count
  static int count() {
    return getRecentIds().length;
  }

  /// Has Recent
  static bool hasRecent() {
    return getRecentIds().isNotEmpty;
  }
}