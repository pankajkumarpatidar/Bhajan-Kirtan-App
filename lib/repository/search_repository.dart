import '../models/bhajan_model.dart';

class SearchRepository {
  static List<BhajanModel> search(
    List<BhajanModel> bhajans,
    String query,
  ) {
    if (query.trim().isEmpty) {
      return bhajans;
    }

    final searchText = query.toLowerCase().trim();

    return bhajans.where((bhajan) {
      return bhajan.title.toLowerCase().contains(searchText) ||
          bhajan.lyrics.toLowerCase().contains(searchText) ||
          bhajan.categoryId.toLowerCase().contains(searchText);
    }).toList();
  }
}