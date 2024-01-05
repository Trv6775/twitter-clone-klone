import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_klone_clone/constants/constants.dart';
import 'package:twitter_klone_clone/core/core.dart';
import 'package:twitter_klone_clone/models/models.dart';

final tweetAPIProvider = Provider((ref) {
  final db = ref.watch(appwriteDatabaseProvider);
  final realtime = ref.watch(appwriteRealtimeProvider);
  return TweetAPI(
    db: db,
    realtime: realtime,
  );
});

abstract class ITweetAPI {
  FutureEither<model.Document> shareTweet(TweetModel tweet);

  Future<List<model.Document>> getTweets();

  Stream<RealtimeMessage> getLatestTweet();

  FutureEither<model.Document> likeTweet(TweetModel tweet);

  FutureEither<model.Document> updateReshareCount(TweetModel tweet);

  Future<List<model.Document>> getRepliesToTweet(TweetModel tweet);

  Future<model.Document> getTweetById(String id);

  Future<List<model.Document>>getUserTweets(String uid);
}

class TweetAPI extends ITweetAPI {
  final Databases _db;
  final Realtime _realtime;

  TweetAPI({required Databases db, required Realtime realtime})
      : _db = db,
        _realtime = realtime;

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
    final listDocuments = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.tweetCollectionId,
      queries: [
        Query.orderDesc('tweetedAt'),
      ],
    );
    return listDocuments.documents;
  }

  @override
  Stream<RealtimeMessage> getLatestTweet() {
    return _realtime.subscribe(
      [
        'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.tweetCollectionId}.documents'
      ],
    ).stream;
  }

  @override
  FutureEither<model.Document> likeTweet(TweetModel tweet) async {
    try {
      final document = await _db.updateDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.tweetCollectionId,
          documentId: tweet.id,
          data: {
            'likes': tweet.likes,
          });
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
  FutureEither<model.Document> updateReshareCount(TweetModel tweet) async {
    try {
      final document = await _db.updateDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.tweetCollectionId,
          documentId: tweet.uid,
          data: {
            'reshareCount': tweet.reshareCount,
          });
      return right(document);
    } on AppwriteException catch (e, stackTrace) {
      return left(
        Failure(
          e.message ?? 'Some unexpected error occurred',
          stackTrace,
        ),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(e.toString(), stackTrace),
      );
    }
  }

  @override
  Future<List<model.Document>> getRepliesToTweet(TweetModel tweet) async {
    final document = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.tweetCollectionId,
      queries: [
        Query.equal(
          'repliedTo',
          tweet.id,
        ),
      ],
    );
    return document.documents;
  }

  @override
  Future<model.Document> getTweetById(String id) async{
    return await _db.getDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.tweetCollectionId,
      documentId: id,
    );
  }

  @override
  Future<List<model.Document>> getUserTweets(String uid) async{
    final document=await _db.listDocuments(databaseId: AppwriteConstants.databaseId, collectionId: AppwriteConstants.tweetCollectionId,queries: [
      Query.equal('uid', uid),
    ]);
    return document.documents;
  }
}
