import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:twitter_klone_clone/constants/constants.dart';
import 'package:twitter_klone_clone/core/core.dart';
import 'package:twitter_klone_clone/models/models.dart';
import 'package:appwrite/models.dart' as model;

final notificationsAPIProvider = Provider((ref) {
  final db = ref.watch(appwriteDatabaseProvider);
  final realtime=ref.watch(appwriteRealtimeProvider);
  return NotificationsAPI(db: db,realtime: realtime);
});

abstract class INotificationsAPI {
  FutureEitherVoid createNotification(NotificationModel notification);

  Future<List<model.Document>> getNotifications(String uid);

  Stream<RealtimeMessage> getLatestNotification();
}

class NotificationsAPI extends INotificationsAPI {
  final Databases _db;
  final Realtime _realtime;

  NotificationsAPI({required Databases db, required Realtime realtime})
      : _db = db,
        _realtime = realtime;

  @override
  FutureEitherVoid createNotification(NotificationModel notification) async {
    try {
      await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.notificationsCollectionId,
        documentId: ID.unique(),
        data: notification.toMap(),
      );
      return right(null);
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
  Future<List<model.Document>> getNotifications(String uid) async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.notificationsCollectionId,
      queries: [
        Query.equal('uid', uid),
      ],
    );
    return documents.documents;
  }

  @override
  Stream<RealtimeMessage> getLatestNotification() {
    return _realtime.subscribe([
      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.notificationsCollectionId}.documents'
    ]).stream;
  }
}
