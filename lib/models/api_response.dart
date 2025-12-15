class ApiResponse<T> {
  final int statusCode;
  final String message;
  final String path;
  final String timestamp;
  final T? data;

  ApiResponse({
    required this.statusCode,
    required this.message,
    required this.path,
    required this.timestamp,
    this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T? Function(Map<String, dynamic>)? fromJsonT,
  ) {
    T? data;
    if (json['data'] != null) {
      if (fromJsonT != null && json['data'] is Map<String, dynamic>) {
        try {
          data = fromJsonT(json['data'] as Map<String, dynamic>);
        } catch (e) {
          // Nếu parse lỗi, set data = null
          data = null;
        }
      } else {
        data = json['data'] as T?;
      }
    }
    
    return ApiResponse<T>(
      statusCode: json['statusCode'] as int,
      message: json['message'] as String,
      path: json['path'] as String,
      timestamp: json['timestamp'] as String,
      data: data,
    );
  }
}

