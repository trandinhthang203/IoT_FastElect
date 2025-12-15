import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

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
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildNotificationSection(
                    'Hôm nay',
                    [
                      {
                        'icon': Icons.lightbulb_outline,
                        'iconColor': const Color(0xFFFFA726),
                        'title': 'Có chỉ số điện mới',
                        'subtitle': 'Đã có chỉ số điện tháng 12',
                        'time': '5 phút',
                      },
                      {
                        'icon': Icons.calendar_today,
                        'iconColor': const Color(0xFFFFA726),
                        'title': 'Sắp đến hạn thanh toán',
                        'subtitle': 'Hóa đơn tiền điện sẽ đến hạn trong 3 ngày nữa',
                        'time': '1 giờ',
                      },
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildNotificationSection(
                    'Hôm qua',
                    [
                      {
                        'icon': Icons.check_circle_outline,
                        'iconColor': Colors.green,
                        'title': 'Bạn đã thanh toán thành công',
                        'subtitle': 'Thanh toán hóa đơn tiền điện tháng 11 thành công.',
                        'time': '10:30',
                      },
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildNotificationSection(
                    'Cũ hơn',
                    [
                      {
                        'icon': Icons.error_outline,
                        'iconColor': Colors.red,
                        'title': 'Thanh toán quá hạn',
                        'subtitle': 'Hóa đơn tiền điện tháng 10 đã quá hạn.',
                        'time': '3 ngày',
                      },
                      {
                        'icon': Icons.notifications_outlined,
                        'iconColor': Colors.grey,
                        'title': 'Thông báo chung',
                        'subtitle': 'Lịch cắt điện khu vực từ 8h-12h ngày 25/12.',
                        'time': '5 ngày',
                      },
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSection(
    String title,
    List<Map<String, dynamic>> notifications,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        ...notifications.map((notification) {
          return _buildNotificationCard(notification);
        }).toList(),
      ],
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E3A5F),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: (notification['iconColor'] as Color).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              notification['icon'] as IconData,
              color: notification['iconColor'] as Color,
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
                        notification['title'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      notification['time'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  notification['subtitle'],
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[400],
                    height: 1.4,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
