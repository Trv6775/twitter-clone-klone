import 'package:twitter_klone_clone/core/enums/enums.dart';

class NotificationModel {
  final String text;
  final String postId;
  final String id;
  final String uid;
  final NotificationType notificationType;

  const NotificationModel({
    required this.text,
    required this.postId,
    required this.id,
    required this.uid,
    required this.notificationType,
  });

  NotificationModel copyWith({
    String? text,
    String? postId,
    String? id,
    String? uid,
    NotificationType? notificationType,
  }) {
    return NotificationModel(
      text: text ?? this.text,
      postId: postId ?? this.postId,
      id: id ?? this.id,
      uid: uid ?? this.uid,
      notificationType: notificationType ?? this.notificationType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'postId': postId,
      'uid': uid,
      'notificationType': notificationType.type,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      text: map['text'] ?? '',
      postId: map['postId'] ?? '',
      id: map['\$id'] ?? '',
      uid: map['uid'] ?? '',
      notificationType:
          (map['notificationType'] as String).toNotificationTypeEnum(),
    );
  }

  @override
  String toString() {
    return 'NotificationModel{text: $text, postId: $postId, id: $id, uid: $uid, notificationType: $notificationType}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationModel &&
          runtimeType == other.runtimeType &&
          text == other.text &&
          postId == other.postId &&
          id == other.id &&
          uid == other.uid &&
          notificationType == other.notificationType;

  @override
  int get hashCode =>
      text.hashCode ^
      postId.hashCode ^
      id.hashCode ^
      uid.hashCode ^
      notificationType.hashCode;
}
