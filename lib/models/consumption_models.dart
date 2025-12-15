class Room {
  final String id;
  final String name;

  Room({required this.id, required this.name});

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}

class ConsumptionValue {
  final double value;
  final String unit;

  ConsumptionValue({required this.value, required this.unit});

  factory ConsumptionValue.fromJson(Map<String, dynamic> json) {
    return ConsumptionValue(
      value: json['value'] != null ? (json['value'] as num).toDouble() : 0.0,
      unit: json['unit']?.toString() ?? 'kWh',
    );
  }
}

class Bill {
  final double amount;
  final String currency;

  Bill({required this.amount, required this.currency});

  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      amount: json['amount'] != null ? (json['amount'] as num).toDouble() : 0.0,
      currency: json['currency']?.toString() ?? 'VND',
    );
  }
}

class MonthlyConsumption {
  final String consumptionId;
  final ConsumptionValue consumption;
  final Bill bill;
  final String recordedAt;

  MonthlyConsumption({
    required this.consumptionId,
    required this.consumption,
    required this.bill,
    required this.recordedAt,
  });

  factory MonthlyConsumption.fromJson(Map<String, dynamic> json) {
    return MonthlyConsumption(
      consumptionId: json['consumptionId']?.toString() ?? '',
      consumption: json['consumption'] != null && json['consumption'] is Map<String, dynamic>
          ? ConsumptionValue.fromJson(json['consumption'] as Map<String, dynamic>)
          : ConsumptionValue(value: 0.0, unit: 'kWh'),
      bill: json['bill'] != null && json['bill'] is Map<String, dynamic>
          ? Bill.fromJson(json['bill'] as Map<String, dynamic>)
          : Bill(amount: 0.0, currency: 'VND'),
      recordedAt: json['recordedAt']?.toString() ?? '',
    );
  }
}

class MonthlyConsumptionResponse {
  final Room room;
  final List<MonthlyConsumption> consumptions;

  MonthlyConsumptionResponse({
    required this.room,
    required this.consumptions,
  });

  factory MonthlyConsumptionResponse.fromJson(Map<String, dynamic> json) {
    return MonthlyConsumptionResponse(
      room: json['room'] != null && json['room'] is Map<String, dynamic>
          ? Room.fromJson(json['room'] as Map<String, dynamic>)
          : Room(id: '', name: ''),
      consumptions: json['consumptions'] != null && json['consumptions'] is List
          ? (json['consumptions'] as List<dynamic>)
              .where((item) => item is Map<String, dynamic>)
              .map((item) => MonthlyConsumption.fromJson(item as Map<String, dynamic>))
              .toList()
          : <MonthlyConsumption>[],
    );
  }
}

class LatestConsumptionResponse {
  final ConsumptionValue currentMeter;
  final ConsumptionValue consumption;
  final Bill bill;
  final String recordedAt;

  LatestConsumptionResponse({
    required this.currentMeter,
    required this.consumption,
    required this.bill,
    required this.recordedAt,
  });

  factory LatestConsumptionResponse.fromJson(Map<String, dynamic> json) {
    return LatestConsumptionResponse(
      currentMeter: json['currentMeter'] != null && json['currentMeter'] is Map<String, dynamic>
          ? ConsumptionValue.fromJson(json['currentMeter'] as Map<String, dynamic>)
          : ConsumptionValue(value: 0.0, unit: 'kWh'),
      consumption: json['consumption'] != null && json['consumption'] is Map<String, dynamic>
          ? ConsumptionValue.fromJson(json['consumption'] as Map<String, dynamic>)
          : ConsumptionValue(value: 0.0, unit: 'kWh'),
      bill: json['bill'] != null && json['bill'] is Map<String, dynamic>
          ? Bill.fromJson(json['bill'] as Map<String, dynamic>)
          : Bill(amount: 0.0, currency: 'VND'),
      recordedAt: json['recordedAt']?.toString() ?? '',
    );
  }
}

class DailyConsumption {
  final String consumptionId;
  final ConsumptionValue currentMeter;
  final ConsumptionValue lastMeter;
  final ConsumptionValue consumption;
  final String recordedAt;

  DailyConsumption({
    required this.consumptionId,
    required this.currentMeter,
    required this.lastMeter,
    required this.consumption,
    required this.recordedAt,
  });

  factory DailyConsumption.fromJson(Map<String, dynamic> json) {
    return DailyConsumption(
      consumptionId: json['consumptionId']?.toString() ?? '',
      currentMeter: json['currentMeter'] != null && json['currentMeter'] is Map<String, dynamic>
          ? ConsumptionValue.fromJson(json['currentMeter'] as Map<String, dynamic>)
          : ConsumptionValue(value: 0.0, unit: 'kWh'),
      lastMeter: json['lastMeter'] != null && json['lastMeter'] is Map<String, dynamic>
          ? ConsumptionValue.fromJson(json['lastMeter'] as Map<String, dynamic>)
          : ConsumptionValue(value: 0.0, unit: 'kWh'),
      consumption: json['consumption'] != null && json['consumption'] is Map<String, dynamic>
          ? ConsumptionValue.fromJson(json['consumption'] as Map<String, dynamic>)
          : ConsumptionValue(value: 0.0, unit: 'kWh'),
      recordedAt: json['recordedAt']?.toString() ?? '',
    );
  }
}

class DailyConsumptionResponse {
  final Room room;
  final List<DailyConsumption> consumptions;

  DailyConsumptionResponse({
    required this.room,
    required this.consumptions,
  });

  factory DailyConsumptionResponse.fromJson(Map<String, dynamic> json) {
    return DailyConsumptionResponse(
      room: json['room'] != null && json['room'] is Map<String, dynamic>
          ? Room.fromJson(json['room'] as Map<String, dynamic>)
          : Room(id: '', name: ''),
      consumptions: json['consumptions'] != null && json['consumptions'] is List
          ? (json['consumptions'] as List<dynamic>)
              .where((item) => item is Map<String, dynamic>)
              .map((item) => DailyConsumption.fromJson(item as Map<String, dynamic>))
              .toList()
          : <DailyConsumption>[],
    );
  }
}

