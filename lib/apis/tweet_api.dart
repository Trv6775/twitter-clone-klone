import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_klone_clone/constants/constants.dart';
import 'package:twitter_klone_clone/core/core.dart';
import 'package:twitter_klone_clone/models/models.dart';

final tweetAPIProvider = Provider((ref) {
  final db = ref.watch(appwriteDatabaseProvider);
  return TweetAPI(db: db);
});

abstract class ITweetAPI {
  FutureEither<model.Document> shareTweet(TweetModel tweet);

  Future<List<model.Document>> getTweets();
}

class TweetAPI extends ITweetAPI {
  final Databases _db;

  TweetAPI({required Databases db}) : _db = db;

  @override
  FutureEither<model.Document> shareTweet(TweetModel tweet) async {
    try {
      final document = await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.tweetCollectionId,
        documentId: ID.unique(),
        data: tweet.toMap(),
      );
      return right(document);
    } on AppwriteException catch (e, stackTrace) {
      return left(
        Failure(e.message ?? 'Some unexpected error occurred', stackTrace),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(e.toString(), stackTrace),
      );
    }
  }

  @override
  Future<List<model.Document>> getTweets() async {
    final listDocuments=await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.tweetCollectionId,
    );
    return listDocuments.documents;
  }
}
