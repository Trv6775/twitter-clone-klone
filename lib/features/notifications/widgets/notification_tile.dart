import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twitter_klone_clone/constants/constants.dart';
import 'package:twitter_klone_clone/core/enums/enums.dart';
import 'package:twitter_klone_clone/models/models.dart';
import 'package:twitter_klone_clone/theme/theme.dart';

class NotificationTile extends StatelessWidget {
  final NotificationModel notification;

  const NotificationTile({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: notification.notificationType == NotificationType.follow
          ? const Icon(Icons.person)
          : notification.notificationType == NotificationType.like
              ? SvgPicture.asset(
                  AssetConstants.likeFilledIcon,
                  color: Pallete.redColor,
                  height: 20,
                )
              : notification.notificationType == NotificationType.retweet
                  ? SvgPicture.asset(
                      AssetConstants.retweetIcon,
                      color: Pallete.whiteColor,
                      height: 20,
                    )
                  : notification.notificationType == NotificationType.reply
                      ? SvgPicture.asset(
                          AssetConstants.commentIcon,
                          color: Pallete.whiteColor,
                          height: 20,
                        )
                      : null,
      title: Text(
        notification.text,
      ),
    );
  }
}
