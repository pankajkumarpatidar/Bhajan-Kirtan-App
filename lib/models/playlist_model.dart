class PlaylistModel {

  final String id;
  final String name;
  final List<String> bhajans;
  final DateTime createdAt;

  PlaylistModel({
    required this.id,
    required this.name,
    required this.bhajans,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "bhajans": bhajans,
      "createdAt":
          createdAt.toIso8601String(),
    };
  }

  factory PlaylistModel.fromMap(
      Map map) {
    return PlaylistModel(
      id: map["id"],
      name: map["name"],
      bhajans:
          List<String>.from(
              map["bhajans"] ?? []),
      createdAt: DateTime.parse(
        map["createdAt"],
      ),
    );
  }

}