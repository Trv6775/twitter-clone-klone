import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_klone_clone/common/common.dart';
import 'package:twitter_klone_clone/constants/constants.dart';
import 'package:twitter_klone_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_klone_clone/features/notifications/controller/notifications_controller.dart';
import 'package:twitter_klone_clone/features/notifications/widgets/notification_tile.dart';
import 'package:twitter_klone_clone/features/notifications/widgets/notification_tile.dart';
import 'package:twitter_klone_clone/models/models.dart';

class NotificationsView extends ConsumerWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: currentUser == null
          ? const Loader()
          : ref.watch(getNotificationsByIdProvider(currentUser.uid)).when(
                data: (notifications) {
                  return ref.watch(getLatestNotificationsProvider).when(
                      data: (data) {
                        if (data.events.contains(
                            'databases.*.collections.${AppwriteConstants.notificationsCollectionId}.documents.create')) {
                          final latestNotification =
                              NotificationModel.fromMap(data.payload);
                          if (latestNotification.uid == currentUser.uid) {
                            notifications.insert(
                              0,
                              latestNotification,
                            );
                          }
                        }
                        return ListView.builder(
                          itemCount: notifications.length,
                          itemBuilder: (context, index) {
                            final notification = notifications[index];
                            return NotificationTile(notification: notification);
                          },
                        );
                      },
                      error: (error, stacktrace) => ErrorText(
                            error: error.toString(),
                          ),
                      loading: () {
                        return ListView.builder(
                          itemCount: notifications.length,
                          itemBuilder: (context, index) {
                            final notification = notifications[index];
                            return NotificationTile(notification: notification);
                          },
                        );
                      });
                },
                error: (error, stacktrace) => ErrorText(
                  error: error.toString(),
                ),
                loading: () => const Loader(),
              ),
    );
  }
}
