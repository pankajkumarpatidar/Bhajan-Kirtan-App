import 'package:hive_flutter/hive_flutter.dart';

import '../../models/playlist_model.dart';

class PlaylistService {
  static const String boxName = "playlists";

  static Future<void> init() async {
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox(boxName);
    }
  }

  static Box get _box => Hive.box(boxName);

  /// Create Playlist
  static Future<void> createPlaylist(
    String name,
  ) async {
    final id =
        DateTime.now().millisecondsSinceEpoch.toString();

    final playlist = PlaylistModel(
      id: id,
      name: name,
      bhajans: [],
      createdAt: DateTime.now(),
    );

    await _box.put(
      id,
      playlist.toMap(),
    );
  }

  /// Get All Playlist
  static List<PlaylistModel> getAllPlaylists() {
    return _box.values.map((item) {
      return PlaylistModel.fromMap(
        Map<String, dynamic>.from(item),
      );
    }).toList();
  }

  /// Get Playlist
  static PlaylistModel? getPlaylist(
    String id,
  ) {
    try {
      final data = _box.get(id);

      return PlaylistModel.fromMap(
        Map<String, dynamic>.from(data),
      );
    } catch (_) {
      return null;
    }
  }
/// Rename Playlist
  static Future<void> renamePlaylist(
    String id,
    String newName,
  ) async {

    final playlist = getPlaylist(id);

    if (playlist == null) return;

    final updated = PlaylistModel(
      id: playlist.id,
      name: newName,
      bhajans: playlist.bhajans,
      createdAt: playlist.createdAt,
    );

    await _box.put(
      id,
      updated.toMap(),
    );
  }

  /// Add Bhajan
  static Future<void> addBhajan(
    String playlistId,
    String bhajanId,
  ) async {

    final playlist = getPlaylist(playlistId);

    if (playlist == null) return;

    if (!playlist.bhajans.contains(bhajanId)) {
      playlist.bhajans.add(bhajanId);
    }

    await _box.put(
      playlistId,
      playlist.toMap(),
    );
  }

  /// Remove Bhajan
  static Future<void> removeBhajan(
    String playlistId,
    String bhajanId,
  ) async {

    final playlist = getPlaylist(playlistId);

    if (playlist == null) return;

    playlist.bhajans.remove(bhajanId);

    await _box.put(
      playlistId,
      playlist.toMap(),
    );
  }

  /// Delete Playlist
  static Future<void> deletePlaylist(
    String id,
  ) async {
    await _box.delete(id);
  }

  /// Playlist Count
  static int count() {
    return _box.length;
  }

  /// Clear All
  static Future<void> clearAll() async {
    await _box.clear();
  }
}