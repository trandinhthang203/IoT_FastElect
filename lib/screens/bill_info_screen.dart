import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'bill_history_screen.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../models/consumption_models.dart';

class BillInfoScreen extends StatefulWidget {
  final VoidCallback? onNavigateToEnergyTab;
  
  const BillInfoScreen({super.key, this.onNavigateToEnergyTab});

  @override
  State<BillInfoScreen> createState() => _BillInfoScreenState();
}

class _BillInfoScreenState extends State<BillInfoScreen> {
  final _apiService = ApiService();
  LatestConsumptionResponse? _latestConsumption;
  DailyConsumptionResponse? _dailyData;
  bool _isLoading = true;
  String? _error;
  String _username = 'Thắng Trần';

  @override
  void initState() {
    super.initState();
    _loadUsername();
    _loadData();
  }

  Future<void> _loadUsername() async {
    final username = await AuthService.getUsername();
    if (username != null && mounted) {
      setState(() {
        _username = username;
      });
    }
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final latestResponse = await _apiService.getLatestConsumption();
      final dailyResponse = await _apiService.getDailyConsumptions(limit: 7);
      
      if (latestResponse.statusCode == 200 && latestResponse.data != null) {
        setState(() {
          _latestConsumption = latestResponse.data;
          if (dailyResponse.statusCode == 200 && dailyResponse.data != null) {
            _dailyData = dailyResponse.data;
          }
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = latestResponse.message;
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

  String _formatCurrency(double amount) {
    return NumberFormat('#,###').format(amount.toInt());
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      // Format: "Tháng 12/2025" (không có chữ "T" ở đầu)
      return 'Tháng ${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  String _calculatePreviousMonthReading() {
    if (_latestConsumption == null) return 'N/A';
    final previous = _latestConsumption!.currentMeter.value - 
                     _latestConsumption!.consumption.value;
    return '${_formatNumber(previous)} ${_latestConsumption!.currentMeter.unit}';
  }

  String _calculatePricePerKwh() {
    if (_latestConsumption == null || _latestConsumption!.consumption.value == 0) {
      return 'N/A';
    }
    final pricePerKwh = _latestConsumption!.bill.amount / 
                        _latestConsumption!.consumption.value;
    return '${_formatCurrency(pricePerKwh)}/${_latestConsumption!.consumption.unit}';
  }

  String _formatNumber(double value) {
    // Format số không có số thập phân nếu là số nguyên
    if (value == value.toInt()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(1);
  }

  String _getTimeAgo() {
    if (_latestConsumption == null) return 'N/A';
    try {
      final recordedAt = DateTime.parse(_latestConsumption!.recordedAt);
      final now = DateTime.now();
      final difference = now.difference(recordedAt);
      
      if (difference.inMinutes < 1) {
        return 'Vừa xong';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes} phút trước';
      } else if (difference.inHours < 24) {
        return '${difference.inHours} giờ trước';
      } else {
        return '${difference.inDays} ngày trước';
      }
    } catch (e) {
      return 'N/A';
    }
  }

  double _getProgressPercentage() {
    if (_latestConsumption == null) return 0.0;
    final previous = _latestConsumption!.currentMeter.value - 
                     _latestConsumption!.consumption.value;
    final current = _latestConsumption!.currentMeter.value;
    if (current == 0) return 0.0;
    return ((current - previous) / current * 100).clamp(0.0, 100.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2196F3)),
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
                          onPressed: _loadData,
                          child: const Text('Thử lại'),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Xin chào, $_username',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Phòng 101',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.grey[800],
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.notifications_outlined),
                                  color: Colors.white,
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // Current Reading Card
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E3A5F),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Badge ở hàng trên, góc phải
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[800],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'Tháng trước: ${_calculatePreviousMonthReading()}',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey[400],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                // Icon và text ở hàng dưới
                                Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF2196F3).withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.location_on,
                                        color: Color(0xFF2196F3),
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'Số điện hiện tại',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[400],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        _latestConsumption != null
                                            ? '${_formatNumber(_latestConsumption!.currentMeter.value)}'
                                            : 'N/A',
                                        style: const TextStyle(
                                          fontSize: 36,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFFFB800),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 4),
                                      child: Text(
                                        _latestConsumption != null
                                            ? _latestConsumption!.currentMeter.unit
                                            : '',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[300],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: _getProgressPercentage() / 100,
                                    minHeight: 6,
                                    backgroundColor: Colors.grey[800],
                                    valueColor: const AlwaysStoppedAnimation<Color>(
                                      Color(0xFFFFB800),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    'Cập nhật: ${_getTimeAgo()}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Monthly Consumption Card
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E3A5F),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Badge ở hàng trên, góc phải
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[800],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        'Giá: ${_calculatePricePerKwh()}',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey[400],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                // Icon và text ở hàng dưới
                                Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.green.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.electric_bolt,
                                        color: Colors.green,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'Tiêu thụ tháng này',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[400],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        _latestConsumption != null
                                            ? '${_formatNumber(_latestConsumption!.consumption.value)}'
                                            : 'N/A',
                                        style: const TextStyle(
                                          fontSize: 36,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFFFB800),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 4),
                                      child: Text(
                                        _latestConsumption != null
                                            ? _latestConsumption!.consumption.unit
                                            : '',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[300],
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Ước tính',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          _latestConsumption != null
                                              ? '~${_formatCurrency(_latestConsumption!.bill.amount)} VNĐ'
                                              : 'N/A',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                // Bar Chart
                                SizedBox(
                                  height: 60,
                                  child: _dailyData != null && _dailyData!.consumptions.isNotEmpty
                                      ? BarChart(
                                          BarChartData(
                                            alignment: BarChartAlignment.spaceAround,
                                            maxY: _dailyData!.consumptions
                                                    .map((c) => c.consumption.value)
                                                    .reduce((a, b) => a > b ? a : b) *
                                                1.2,
                                            barTouchData: BarTouchData(enabled: false),
                                            titlesData: FlTitlesData(
                                              show: false,
                                            ),
                                            gridData: FlGridData(show: false),
                                            borderData: FlBorderData(show: false),
                                            barGroups: _dailyData!.consumptions.asMap().entries.map((entry) {
                                              final isLast = entry.key == _dailyData!.consumptions.length - 1;
                                              return BarChartGroupData(
                                                x: entry.key,
                                                barRods: [
                                                  BarChartRodData(
                                                    toY: entry.value.consumption.value,
                                                    color: isLast 
                                                        ? const Color(0xFFFFB800)
                                                        : Colors.grey[700]!,
                                                    width: 8,
                                                    borderRadius: const BorderRadius.vertical(
                                                      top: Radius.circular(4),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }).toList(),
                                          ),
                                        )
                                      : Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Chưa có dữ liệu',
                                            style: TextStyle(
                                              color: Colors.grey[500],
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Action Buttons
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1E3A5F),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        // Navigate to Energy tab
                                        if (widget.onNavigateToEnergyTab != null) {
                                          widget.onNavigateToEnergyTab!();
                                        }
                                      },
                                      borderRadius: BorderRadius.circular(16),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.description_outlined,
                                            color: const Color(0xFF2196F3),
                                            size: 28,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Chi tiết',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Container(
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1E3A5F),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const BillHistoryScreen(),
                                          ),
                                        );
                                      },
                                      borderRadius: BorderRadius.circular(16),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.history,
                                            color: Colors.orange,
                                            size: 28,
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Lịch sử',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}


