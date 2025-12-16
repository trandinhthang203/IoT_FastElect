import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../models/consumption_models.dart';

class BillHistoryScreen extends StatefulWidget {
  const BillHistoryScreen({super.key});

  @override
  State<BillHistoryScreen> createState() => _BillHistoryScreenState();
}

class _BillHistoryScreenState extends State<BillHistoryScreen> {
  final _apiService = ApiService();
  MonthlyConsumptionResponse? _monthlyData;
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
      final response = await _apiService.getMonthlyConsumptions(limit: 12);
      if (response.statusCode == 200 && response.data != null) {
        setState(() {
          _monthlyData = response.data;
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

  String _formatCurrency(double amount) {
    return NumberFormat('#,###').format(amount.toInt());
  }

  String _formatMonth(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      // Format: "Tháng M năm yyyy" (ví dụ: "Tháng 12 năm 2025")
      return 'Tháng ${date.month} năm ${date.year}';
    } catch (e) {
      return dateString;
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
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
                    child: Text(
                      'Lịch sử Tiền điện',
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
            // Bill List
            Expanded(
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
                      : _monthlyData == null || _monthlyData!.consumptions.isEmpty
                          ? RefreshIndicator(
                              onRefresh: _loadData,
                              color: const Color(0xFF2196F3),
                              child: SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.5,
                                  child: const Center(
                                    child: Text(
                                      'Chưa có dữ liệu',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: _loadData,
                              color: const Color(0xFF2196F3),
                              child: ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                itemCount: _monthlyData!.consumptions.length,
                                itemBuilder: (context, index) {
                                  final consumption = _monthlyData!.consumptions[index];
                                  return _buildBillCard(context, consumption);
                                },
                              ),
                            ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillCard(BuildContext context, MonthlyConsumption consumption) {
    // Trạng thái:
    // - Nếu là tháng hiện tại và CHƯA hết tháng => luôn hiển thị "Chưa thanh toán"
    // - Ngược lại, dựa vào amount: > 0 là đã thanh toán, = 0 là chưa thanh toán
    bool isPaid;
    try {
      final recordedDate = DateTime.parse(consumption.recordedAt);
      final now = DateTime.now();
      final isCurrentMonth =
          recordedDate.year == now.year && recordedDate.month == now.month;
      final lastDayOfMonth =
          DateTime(recordedDate.year, recordedDate.month + 1, 0).day;
      final isBeforeEndOfMonth = now.year == recordedDate.year &&
          now.month == recordedDate.month &&
          now.day < lastDayOfMonth;

      if (isCurrentMonth && isBeforeEndOfMonth) {
        // Chưa hết tháng hiện tại -> xem như chưa đến kỳ thanh toán
        isPaid = false;
      } else {
        isPaid = consumption.bill.amount > 0;
      }
    } catch (_) {
      // Nếu parse lỗi thì fallback về logic cũ
      isPaid = consumption.bill.amount > 0;
    }
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E3A5F),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Wrap text tháng với Expanded để tránh overflow
              Expanded(
                child: Text(
                  _formatMonth(consumption.recordedAt),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8), // Thêm spacing
              // Wrap status badge với Flexible
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isPaid
                        ? Colors.green.withOpacity(0.2)
                        : Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    isPaid ? 'Đã thanh toán' : 'Chưa thanh toán',
                    style: TextStyle(
                      fontSize: 12,
                      color: isPaid ? Colors.green : Colors.orange,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(
                Icons.electric_bolt,
                color: Color(0xFF2196F3),
                size: 20,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Điện tiêu thụ: ',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[400],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Flexible(
                child: Text(
                  '${consumption.consumption.value.toStringAsFixed(1)} ${consumption.consumption.unit}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.payments_outlined,
                color: Color(0xFF2196F3),
                size: 20,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Tổng tiền: ',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[400],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Flexible(
                child: Text(
                  '${_formatCurrency(consumption.bill.amount)} ${consumption.bill.currency}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}