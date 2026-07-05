import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {

  final String id;

  final String title;

  final String description;

  final String image;

  final String type;

  final String targetId;

  final String targetName;

  final String priority;

  final bool status;

  final String createdBy;

  final DateTime? createdAt;

  const NotificationModel({

    required this.id,

    required this.title,

    required this.description,

    required this.image,

    required this.type,

    required this.targetId,

    required this.targetName,

    required this.priority,

    required this.status,

    required this.createdBy,

    required this.createdAt,

  });

  factory NotificationModel.fromMap(

    String id,

    Map<String, dynamic> data,

  ) {

    return NotificationModel(

      id: id,

      title: data["title"] ?? "",

      description: data["description"] ?? "",

      image: data["image"] ?? "",

      type: data["type"] ?? "general",

      targetId: data["targetId"] ?? "",

      targetName: data["targetName"] ?? "",

      priority: data["priority"] ?? "normal",

      status: data["status"] ?? true,

      createdBy: data["createdBy"] ?? "",

      createdAt:
          (data["createdAt"] as Timestamp?)
              ?.toDate(),

    );

  }

  Map<String, dynamic> toMap() {

    return {

      "title": title,

      "description": description,

      "image": image,

      "type": type,

      "targetId": targetId,

      "targetName": targetName,

      "priority": priority,

      "status": status,

      "createdBy": createdBy,

      "createdAt":
          createdAt == null
              ? FieldValue.serverTimestamp()
              : Timestamp.fromDate(
                  createdAt!,
                ),

    };

  }

  NotificationModel copyWith({

    String? id,

    String? title,

    String? description,

    String? image,

    String? type,

    String? targetId,

    String? targetName,

    String? priority,

    bool? status,

    String? createdBy,

    DateTime? createdAt,

  }) {

    return NotificationModel(

      id: id ?? this.id,

      title: title ?? this.title,

      description:
          description ?? this.description,

      image: image ?? this.image,

      type: type ?? this.type,

      targetId: targetId ?? this.targetId,

      targetName:
          targetName ?? this.targetName,

      priority: priority ?? this.priority,

      status: status ?? this.status,

      createdBy:
          createdBy ?? this.createdBy,

      createdAt:
          createdAt ?? this.createdAt,

    );

  }

}