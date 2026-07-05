class BhajanModel {

  final String id;

  final String categoryId;

  final String title;

  final String lyrics;

  final String audioUrl;

  final String youtubeUrl;

  final String image;

  final int order;

  final int favoriteCount;

  final int views;

  final String duration;

  final bool status;

  final String createdBy;

  const BhajanModel({

    required this.id,

    required this.categoryId,

    required this.title,

    required this.lyrics,

    required this.audioUrl,

    required this.youtubeUrl,

    required this.image,

    required this.order,

    required this.favoriteCount,

    required this.views,

    required this.duration,

    required this.status,

    required this.createdBy,

  });

  factory BhajanModel.fromMap(

    String id,

    Map<String, dynamic> json,

  ) {

    return BhajanModel(

      id: id,

      categoryId:
          json['categoryId'] ?? '',

      title:
          json['title'] ?? '',

      lyrics:
          json['lyrics'] ?? '',

      audioUrl:
          json['audioUrl'] ?? '',

      youtubeUrl:
          json['youtubeUrl'] ?? '',

      image:
          json['image'] ?? '',

      order:
          json['order'] ?? 0,

      favoriteCount:
          json['favoriteCount'] ?? 0,

      views:
          json['views'] ?? 0,

      duration:
          json['duration'] ?? '',

      status:
          json['status'] ?? true,

      createdBy:
          json['createdBy'] ?? '',

    );

  }
  Map<String, dynamic> toMap() {

    return {

      'categoryId': categoryId,

      'title': title,

      'lyrics': lyrics,

      'audioUrl': audioUrl,

      'youtubeUrl': youtubeUrl,

      'image': image,

      'order': order,

      'favoriteCount': favoriteCount,

      'views': views,

      'duration': duration,

      'status': status,

      'createdBy': createdBy,

    };

  }

  BhajanModel copyWith({

    String? id,

    String? categoryId,

    String? title,

    String? lyrics,

    String? audioUrl,

    String? youtubeUrl,

    String? image,

    int? order,

    int? favoriteCount,

    int? views,

    String? duration,

    bool? status,

    String? createdBy,

  }) {

    return BhajanModel(

      id: id ?? this.id,

      categoryId:
          categoryId ?? this.categoryId,

      title: title ?? this.title,

      lyrics: lyrics ?? this.lyrics,

      audioUrl:
          audioUrl ?? this.audioUrl,

      youtubeUrl:
          youtubeUrl ?? this.youtubeUrl,

      image: image ?? this.image,

      order: order ?? this.order,

      favoriteCount:
          favoriteCount ?? this.favoriteCount,

      views: views ?? this.views,

      duration:
          duration ?? this.duration,

      status: status ?? this.status,

      createdBy:
          createdBy ?? this.createdBy,

    );

  }

}