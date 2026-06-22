import 'package:hive_flutter/hive_flutter.dart';

import '../../models/bhajan_model.dart';

class BhajanCacheService {
  static const String boxName = "bhajans";

  static Future<void> init() async {
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox(boxName);
    }
  }

  static Box get _box => Hive.box(boxName);

  /// Save All Bhajans
  static Future<void> saveBhajans(
    List<BhajanModel> bhajans,
  ) async {
    await _box.clear();

    for (final bhajan in bhajans) {
      await _box.put(
        bhajan.id,
        {
          "id": bhajan.id,
          "categoryId": bhajan.categoryId,
          "title": bhajan.title,
          "lyrics": bhajan.lyrics,
          "audioUrl": bhajan.audioUrl,
          "youtubeUrl": bhajan.youtubeUrl,
          "image": bhajan.image,
          "order": bhajan.order,
          "favoriteCount": bhajan.favoriteCount,
          "views": bhajan.views,
          "duration": bhajan.duration,
          "status": bhajan.status,
        },
      );
    }
  }

  /// Get All Cached Bhajans
  static List<BhajanModel> getAllBhajans() {
    return _box.values
        .map((item) {
          final data =
              Map<String, dynamic>.from(item);

          return BhajanModel(
            id: data["id"] ?? "",
            categoryId:
                data["categoryId"] ?? "",
            title: data["title"] ?? "",
            lyrics: data["lyrics"] ?? "",
            audioUrl:
                data["audioUrl"] ?? "",
            youtubeUrl:
                data["youtubeUrl"] ?? "",
            image: data["image"] ?? "",
            order: data["order"] ?? 0,
            favoriteCount:
                data["favoriteCount"] ?? 0,
            views: data["views"] ?? 0,
            duration:
                data["duration"] ?? "",
            status: data["status"] ?? true,
          );
        })
        .toList();
  }

  /// Category Wise
  static List<BhajanModel>
      getCategoryBhajans(
    String categoryId,
  ) {
    return getAllBhajans()
        .where(
          (bhajan) =>
              bhajan.categoryId ==
              categoryId,
        )
        .toList();
  }

  /// Single Bhajan
  static BhajanModel? getBhajan(
    String id,
  ) {
    try {
      return getAllBhajans()
          .firstWhere(
        (bhajan) => bhajan.id == id,
      );
    } catch (_) {
      return null;
    }
  }

  /// Search
  static List<BhajanModel> search(
    String query,
  ) {
    if (query.trim().isEmpty) {
      return getAllBhajans();
    }

    final searchText = query
        .toLowerCase()
        .trim();

    return getAllBhajans()
        .where((bhajan) {
      return bhajan.title
              .toLowerCase()
              .contains(searchText) ||
          bhajan.lyrics
              .toLowerCase()
              .contains(searchText) ||
          bhajan.categoryId
              .toLowerCase()
              .contains(searchText);
    }).toList();
  }

  /// Count
  static int getCount() {
    return _box.length;
  }

  /// Has Data
  static bool hasData() {
    return _box.isNotEmpty;
  }

  /// Clear Cache
  static Future<void> clearCache() async {
    await _box.clear();
  }
}