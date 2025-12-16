class NotificationItem {
  final String id;
  final String type;
  final String title;
  final String message;
  final String createdAt;

  NotificationItem({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.createdAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? 'GENERAL',
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }
}

class NotificationListResponse {
  final List<NotificationItem> notifications;

  NotificationListResponse({required this.notifications});

  factory NotificationListResponse.fromJson(Map<String, dynamic> json) {
    final list = json['notifications'];
    return NotificationListResponse(
      notifications: list is List
          ? list
              .where((e) => e is Map<String, dynamic>)
              .map((e) => NotificationItem.fromJson(e as Map<String, dynamic>))
              .toList()
          : <NotificationItem>[],
    );
  }
}


