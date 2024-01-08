import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_klone_clone/apis/apis..dart';
import 'package:twitter_klone_clone/core/enums/enums.dart';

import 'package:twitter_klone_clone/models/models.dart';

final notificationsControllerProvider =
    StateNotifierProvider<NotificationsController, bool>((ref) {
  final notificationsAPI = ref.watch(notificationsAPIProvider);
  return NotificationsController(notificationsAPI: notificationsAPI);
});
final getNotificationsByIdProvider = FutureProvider.family((ref, String uid) {
  final notificationsController =
      ref.watch(notificationsControllerProvider.notifier);
  return notificationsController.getNotificationsById(uid);
});

final getLatestNotificationsProvider=StreamProvider((ref) {
  final notificationsAPI=ref.watch(notificationsAPIProvider);
  return notificationsAPI.getLatestNotification();
});


class NotificationsController extends StateNotifier<bool> {
  final NotificationsAPI _notificationsAPI;

  NotificationsController({required NotificationsAPI notificationsAPI})
      : _notificationsAPI = notificationsAPI,
        super(false);

  void createNotification({
    required String text,
    required String postId,
    required NotificationType notificationType,
    required String uid,
  }) async {
    final notification = NotificationModel(
      text: text,
      postId: postId,
      id: '',
      uid: uid,
      notificationType: notificationType,
    );
    await _notificationsAPI.createNotification(notification);
  }

  Future<List<NotificationModel>> getNotificationsById(String uid) async {
    final notification = await _notificationsAPI.getNotifications(uid);
    return notification.map((e) => NotificationModel.fromMap(e.data)).toList();
  }
}
