import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'bill_info_screen.dart';
import 'energy_tracking_screen.dart';
import 'bill_history_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final _apiService = ApiService();
  int _notificationCount = 0;

  @override
  void initState() {
    super.initState();
    _loadNotificationCount();
  }

  Future<void> _loadNotificationCount() async {
    try {
      final response = await _apiService.getNotifications(limit: 10);
      if (response.statusCode == 200 && response.data != null) {
        setState(() {
          _notificationCount = response.data!.notifications.length;
        });
      }
    } catch (_) {
      // ignore error, keep count = 0
    }
  }

  void _updateNotificationCount(int count) {
    setState(() {
      _notificationCount = count;
    });
  }

  List<Widget> get _screens => [
    BillInfoScreen(
      notificationCount: _notificationCount,
      onNavigateToEnergyTab: () {
        setState(() {
          _currentIndex = 1; // Switch to Energy tab
        });
      },
      onNotificationCountChanged: _updateNotificationCount,
    ),
    const EnergyTrackingScreen(),
    const BillHistoryScreen(),
    NotificationsScreen(
      onNotificationRead: (unreadCount) {
        _updateNotificationCount(unreadCount);
      },
    ),
    const ProfileScreen(),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reload notification count when switching tabs
    if (_currentIndex == 3) { // Notifications tab
      _loadNotificationCount();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E3A5F),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: _buildNavItem(
                    icon: Icons.home_outlined,
                    selectedIcon: Icons.home,
                    label: 'Trang chủ',
                    index: 0,
                  ),
                ),
                Expanded(
                  child: _buildNavItem(
                    icon: Icons.electric_bolt_outlined,
                    selectedIcon: Icons.electric_bolt,
                    label: 'Điện năng',
                    index: 1,
                  ),
                ),
                Expanded(
                  child: _buildNavItem(
                    icon: Icons.history_outlined,
                    selectedIcon: Icons.history,
                    label: 'Lịch sử',
                    index: 2,
                  ),
                ),
                Expanded(
                  child: _buildNavItem(
                    icon: Icons.notifications_outlined,
                    selectedIcon: Icons.notifications,
                    label: 'Thông báo',
                    index: 3,
                  ),
                ),
                Expanded(
                  child: _buildNavItem(
                    icon: Icons.person_outline,
                    selectedIcon: Icons.person,
                    label: 'Tài khoản',
                    index: 4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required int index,
  }) {
    final isSelected = _currentIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
        // Reload notification count when switching to notifications tab or home tab
        if (index == 0 || index == 3) {
          _loadNotificationCount();
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? selectedIcon : icon,
              color: isSelected ? const Color(0xFF2196F3) : Colors.grey[400],
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? const Color(0xFF2196F3) : Colors.grey[400],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}