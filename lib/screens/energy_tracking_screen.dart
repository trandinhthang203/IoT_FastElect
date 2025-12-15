import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../models/consumption_models.dart';

class EnergyTrackingScreen extends StatefulWidget {
  const EnergyTrackingScreen({super.key});

  @override
  State<EnergyTrackingScreen> createState() => _EnergyTrackingScreenState();
}

class _EnergyTrackingScreenState extends State<EnergyTrackingScreen> {
  final _apiService = ApiService();
  bool _isWeekly = true;
  DailyConsumptionResponse? _dailyData;
  LatestConsumptionResponse? _latestData;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final dailyResponse = await _apiService.getDailyConsumptions(limit: _isWeekly ? 7 : 30);
      final latestResponse = await _apiService.getLatestConsumption();

      if (dailyResponse.statusCode == 200 && dailyResponse.data != null &&
          latestResponse.statusCode == 200 && latestResponse.data != null) {
        setState(() {
          _dailyData = dailyResponse.data;
          _latestData = latestResponse.data;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Không thể tải dữ liệu';
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
      return DateFormat('Ngày d tháng M', 'vi').format(date);
    } catch (e) {
      return dateString;
    }
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
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Expanded(
                      child: Text(
                        'Theo dõi Điện năng',
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
                const SizedBox(height: 24),
                // Current Period Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E3A5F),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                          Text(
                            _latestData != null
                                ? 'Kỳ thanh toán ${DateFormat('tháng M', 'vi').format(DateTime.parse(_latestData!.recordedAt))}'
                                : 'Kỳ thanh toán',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[400],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _latestData != null
                                ? '${_latestData!.consumption.value.toStringAsFixed(1)} ${_latestData!.consumption.unit}'
                                : 'N/A',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  'Tổng tiền điện tạm tính: ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[400],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                _latestData != null
                                    ? '${_formatCurrency(_latestData!.bill.amount)} ${_latestData!.bill.currency}'
                                    : 'N/A',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              'Trạng thái: ',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[400],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'Chưa thanh toán',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Consumption Chart Title
                const Text(
                  'Biểu đồ tiêu thụ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                // Time Period Toggle
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E3A5F),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildToggleButton(
                          'Tuần này',
                          _isWeekly,
                          () {
                            setState(() {
                              _isWeekly = true;
                            });
                            _loadData();
                          },
                        ),
                      ),
                      Expanded(
                        child: _buildToggleButton(
                          'Tháng này',
                          !_isWeekly,
                          () {
                            setState(() {
                              _isWeekly = false;
                            });
                            _loadData();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Consumption Stats
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Mức tiêu thụ điện',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        '+5.2%',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                          const SizedBox(height: 8),
                          Text(
                            _dailyData != null && _dailyData!.consumptions.isNotEmpty
                                ? '${_dailyData!.consumptions.map((c) => c.consumption.value).reduce((a, b) => a + b).toStringAsFixed(1)} ${_dailyData!.consumptions.first.consumption.unit}'
                                : 'N/A',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Chart
                          Container(
                            height: 200,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E3A5F),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: _dailyData != null && _dailyData!.consumptions.isNotEmpty
                                ? LineChart(
                                    LineChartData(
                                      gridData: FlGridData(show: false),
                                      titlesData: FlTitlesData(
                                        leftTitles: AxisTitles(
                                          sideTitles: SideTitles(showTitles: false),
                                        ),
                                        rightTitles: AxisTitles(
                                          sideTitles: SideTitles(showTitles: false),
                                        ),
                                        topTitles: AxisTitles(
                                          sideTitles: SideTitles(showTitles: false),
                                        ),
                                        bottomTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            getTitlesWidget: (value, meta) {
                                              if (_dailyData!.consumptions.length > value.toInt() &&
                                                  value.toInt() >= 0) {
                                                final date = DateTime.parse(
                                                  _dailyData!.consumptions[value.toInt()].recordedAt,
                                                );
                                                return Text(
                                                  DateFormat('d/M', 'vi').format(date),
                                                  style: TextStyle(
                                                    color: Colors.grey[400],
                                                    fontSize: 12,
                                                  ),
                                                );
                                              }
                                              return const Text('');
                                            },
                                          ),
                                        ),
                                      ),
                                      borderData: FlBorderData(show: false),
                                      lineBarsData: [
                                        LineChartBarData(
                                          spots: _dailyData!.consumptions.asMap().entries.map((entry) {
                                            return FlSpot(
                                              entry.key.toDouble(),
                                              entry.value.consumption.value,
                                            );
                                          }).toList(),
                                          isCurved: true,
                                          color: const Color(0xFF2196F3),
                                          barWidth: 3,
                                          isStrokeCapRound: true,
                                          dotData: FlDotData(show: false),
                                          belowBarData: BarAreaData(
                                            show: true,
                                            color: const Color(0xFF2196F3).withOpacity(0.2),
                                          ),
                                        ),
                                      ],
                                      minY: 0,
                                      maxY: _dailyData!.consumptions
                                              .map((c) => c.consumption.value)
                                              .reduce((a, b) => a > b ? a : b) *
                                          1.2,
                                    ),
                                  )
                                : const Center(
                                    child: Text(
                                      'Không có dữ liệu',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 24),
                          // Daily Records
                          const Text(
                            'Lịch sử ghi nhận',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _dailyData != null && _dailyData!.consumptions.isNotEmpty
                              ? Column(
                                  children: _dailyData!.consumptions
                                      .map((record) => _buildDailyRecord(record))
                                      .toList(),
                                )
                              : const Text(
                                  'Chưa có dữ liệu',
                                  style: TextStyle(color: Colors.grey),
                                ),
                          const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2196F3) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? Colors.white : Colors.grey[400],
          ),
        ),
      ),
    );
  }

  Widget _buildDailyRecord(DailyConsumption record) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E3A5F),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF2196F3).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.electric_bolt,
              color: Color(0xFF2196F3),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatDate(record.recordedAt),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 4),
                Text(
                  'Chỉ số cũ: ${record.lastMeter.value.toStringAsFixed(1)} ${record.lastMeter.unit}, Chỉ số mới: ${record.currentMeter.value.toStringAsFixed(1)} ${record.currentMeter.unit}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[400],
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${record.consumption.value.toStringAsFixed(1)} ${record.consumption.unit}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
