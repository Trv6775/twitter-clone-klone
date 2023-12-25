import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_klone_clone/constants/constants.dart';
import 'package:twitter_klone_clone/core/core.dart';

final storageAPIProvider = Provider((ref) {
  final storage = ref.watch(appwriteStorageProvider);
  return StorageAPI(storage: storage);
});

abstract class IStorageAPI {
  Future<List<String>> uploadImage(List<File> files);
}

class StorageAPI extends IStorageAPI {
  final Storage _storage;

  StorageAPI({required Storage storage}) : _storage = storage;

  @override
  Future<List<String>> uploadImage(List<File> files) async {
    List<String> imageLinks = [];
    for (final file in files) {
      final uploadedImage = await _storage.createFile(
        bucketId: AppwriteConstants.imagesBucketId,
        fileId: ID.unique(),
        file: InputFile(path: file.path),
      );
      imageLinks.add(
        AppwriteConstants.imageUrl(uploadedImage.$id),
      );
    }
    return imageLinks;
  }
}
