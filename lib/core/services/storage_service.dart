import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {

  StorageService._();

  static final StorageService instance =
      StorageService._();

  final FirebaseStorage _storage =
      FirebaseStorage.instance;

  Reference get _categoryRef =>
      _storage.ref().child("categories");

  Reference get _notificationRef =>
      _storage.ref().child("notifications");

  Reference get _bhajanRef =>
      _storage.ref().child("bhajans");

  // ===========================
  // CATEGORY
  // ===========================

  Future<String> uploadCategoryImage({

    required File file,

    required String fileName,

  }) async {

    final ref =
        _categoryRef.child(fileName);

    final uploadTask =
        await ref.putFile(

      file,

      SettableMetadata(

        contentType: "image/jpeg",

      ),

    );

    return await uploadTask.ref
        .getDownloadURL();

  }

  Future<void> deleteCategoryImage(

    String imageUrl,

  ) async {

    try {

      if (imageUrl.isEmpty) return;

      await _storage
          .refFromURL(imageUrl)
          .delete();

    } catch (_) {}

  }

  Future<String> replaceCategoryImage({

    required File file,

    required String fileName,

    String? oldImageUrl,

  }) async {

    if (oldImageUrl != null &&
        oldImageUrl.isNotEmpty &&
        oldImageUrl.startsWith("http")) {

      await deleteCategoryImage(
        oldImageUrl,
      );

    }

    return await uploadCategoryImage(

      file: file,

      fileName: fileName,

    );

  }

  // ===========================
  // NOTIFICATION
  // ===========================

  Future<String> uploadNotificationImage({

    required File file,

    required String fileName,

  }) async {

    final ref =
        _notificationRef.child(fileName);

    final uploadTask =
        await ref.putFile(

      file,

      SettableMetadata(

        contentType: "image/jpeg",

      ),

    );

    return await uploadTask.ref
        .getDownloadURL();

  }

  Future<void> deleteNotificationImage(

    String imageUrl,

  ) async {

    try {

      if (imageUrl.isEmpty) return;

      await _storage
          .refFromURL(imageUrl)
          .delete();

    } catch (_) {}

  }

  Future<String> replaceNotificationImage({

    required File file,

    required String fileName,

    String? oldImageUrl,

  }) async {

    if (oldImageUrl != null &&
        oldImageUrl.isNotEmpty &&
        oldImageUrl.startsWith("http")) {

      await deleteNotificationImage(
        oldImageUrl,
      );

    }

    return await uploadNotificationImage(

      file: file,

      fileName: fileName,

    );

  }

  // ===========================
  // BHAJAN
  // ===========================

  Future<String> uploadBhajanImage({

    required File file,

    required String fileName,

  }) async {

    final ref =
        _bhajanRef.child(fileName);

    final uploadTask =
        await ref.putFile(

      file,

      SettableMetadata(

        contentType: "image/jpeg",

      ),

    );

    return await uploadTask.ref
        .getDownloadURL();

  }

  Future<void> deleteBhajanImage(

    String imageUrl,

  ) async {

    try {

      if (imageUrl.isEmpty) return;

      await _storage
          .refFromURL(imageUrl)
          .delete();

    } catch (_) {}

  }

  Future<String> replaceBhajanImage({

    required File file,

    required String fileName,

    String? oldImageUrl,

  }) async {

    if (oldImageUrl != null &&
        oldImageUrl.isNotEmpty &&
        oldImageUrl.startsWith("http")) {

      await deleteBhajanImage(
        oldImageUrl,
      );

    }

    return await uploadBhajanImage(

      file: file,

      fileName: fileName,

    );

  }

}