import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../models/notification_models.dart';

class NotificationsScreen extends StatefulWidget {
  final Function(int)? onNotificationRead;
  
  const NotificationsScreen({super.key, this.onNotificationRead});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _apiService = ApiService();
  bool _isLoading = true;
  String? _error;
  List<NotificationItem> _notifications = [];
  Set<String> _readNotificationIds = {}; // Track read notifications

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await _apiService.getNotifications(limit: 20);
      if (response.statusCode == 200 && response.data != null) {
        setState(() {
          _notifications = response.data!.notifications;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = response.message;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  String _timeAgo(String createdAt) {
    try {
      final date = DateTime.parse(createdAt);
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inMinutes < 1) return 'Vừa xong';
      if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
      if (diff.inHours < 24) return '${diff.inHours} giờ trước';
      if (diff.inDays == 1) return 'Hôm qua';
      if (diff.inDays < 7) return '${diff.inDays} ngày trước';

      return DateFormat('dd/MM/yyyy', 'vi').format(date);
    } catch (_) {
      return createdAt;
    }
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'NEW_BILL':
        return Icons.receipt_long_outlined;
      case 'GENERAL':
      default:
        return Icons.notifications_outlined;
    }
  }

  Color _iconColorForType(String type) {
    switch (type) {
      case 'NEW_BILL':
        return const Color(0xFFFFA726);
      case 'GENERAL':
      default:
        return Colors.blueAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  if (Navigator.canPop(context))
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  Expanded(
                    child: Text(
                      'Thông báo',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            // Notifications List
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFF2196F3)),
                      ),
                    )
                  : _error != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _error!,
                                style: const TextStyle(color: Colors.red),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _loadNotifications,
                                child: const Text('Thử lại'),
                              ),
                            ],
                          ),
                        )
                      : _notifications.isEmpty
                          ? RefreshIndicator(
                              onRefresh: _loadNotifications,
                              color: const Color(0xFF2196F3),
                              child: SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.5,
                                  child: const Center(
                                    child: Text(
                                      'Chưa có thông báo',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: _loadNotifications,
                              color: const Color(0xFF2196F3),
                              child: ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                itemCount: _notifications.length,
                                itemBuilder: (context, index) {
                                  final item = _notifications[index];
                                  return _buildNotificationCard(item);
                                },
                              ),
                            ),
            ),
          ],
        ),
      ),
    );
  }

  void _markAsRead(String notificationId) {
    if (!_readNotificationIds.contains(notificationId)) {
      setState(() {
        _readNotificationIds.add(notificationId);
      });
      // Update notification count in parent (HomeScreen)
      if (widget.onNotificationRead != null) {
        widget.onNotificationRead!(unreadCount);
      }
    }
  }

  int get unreadCount => _notifications.length - _readNotificationIds.length;

  Widget _buildNotificationCard(NotificationItem item) {
    final icon = _iconForType(item.type);
    final iconColor = _iconColorForType(item.type);
    final isRead = _readNotificationIds.contains(item.id);

    return InkWell(
      onTap: () {
        _markAsRead(item.id);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E3A5F),
          borderRadius: BorderRadius.circular(12),
          border: isRead ? null : Border.all(
            color: const Color(0xFF2196F3).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isRead ? FontWeight.normal : FontWeight.w600,
                          color: isRead ? Colors.grey[400] : Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      _timeAgo(item.createdAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  item.message,
                  style: TextStyle(
                    fontSize: 13,
                    color: isRead ? Colors.grey[500] : Colors.grey[400],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }
}
