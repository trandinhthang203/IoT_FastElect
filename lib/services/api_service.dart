import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/api_response.dart';
import '../models/auth_models.dart';
import '../models/consumption_models.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';

class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptor to include token in requests
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await AuthService.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) {
          return handler.next(error);
        },
      ),
    );
  }

  // Login
  Future<ApiResponse<LoginResponse>> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.loginEndpoint,
        data: {
          'username': username,
          'password': password,
        },
      );

      final apiResponse = ApiResponse<LoginResponse>.fromJson(
        response.data as Map<String, dynamic>,
        (json) => LoginResponse.fromJson(json),
      );

      // Save token and username
      if (apiResponse.data != null) {
        await AuthService.saveToken(apiResponse.data!.accessToken);
        await AuthService.saveUsername(username);
      }

      return apiResponse;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Logout
  Future<ApiResponse<LogoutResponse>> logout() async {
    try {
      final response = await _dio.post(ApiConstants.logoutEndpoint);

      final apiResponse = ApiResponse<LogoutResponse>.fromJson(
        response.data as Map<String, dynamic>,
        (json) => LogoutResponse.fromJson(json),
      );

      // Clear token
      await AuthService.clearToken();

      return apiResponse;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Get monthly consumptions
  Future<ApiResponse<MonthlyConsumptionResponse>> getMonthlyConsumptions({
    required int limit,
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.monthlyConsumptionEndpoint,
        queryParameters: {'limit': limit},
      );

      return ApiResponse<MonthlyConsumptionResponse>.fromJson(
        response.data as Map<String, dynamic>,
        (json) => MonthlyConsumptionResponse.fromJson(json),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Get latest consumption
  Future<ApiResponse<LatestConsumptionResponse>> getLatestConsumption() async {
    try {
      final response = await _dio.get(ApiConstants.latestConsumptionEndpoint);

      return ApiResponse<LatestConsumptionResponse>.fromJson(
        response.data as Map<String, dynamic>,
        (json) => LatestConsumptionResponse.fromJson(json),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Get daily consumptions
  Future<ApiResponse<DailyConsumptionResponse>> getDailyConsumptions({
    required int limit,
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.dailyConsumptionEndpoint,
        queryParameters: {'limit': limit},
      );

      return ApiResponse<DailyConsumptionResponse>.fromJson(
        response.data as Map<String, dynamic>,
        (json) => DailyConsumptionResponse.fromJson(json),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException error) {
    if (error.response != null) {
      // Server responded with error
      final data = error.response?.data;
      if (data is Map<String, dynamic> && data.containsKey('message')) {
        return data['message'] as String;
      }
      return 'Lỗi từ server: ${error.response?.statusCode}';
    } else if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return 'Kết nối timeout. Vui lòng thử lại.';
    } else if (error.type == DioExceptionType.connectionError) {
      return 'Không thể kết nối đến server. Vui lòng kiểm tra kết nối mạng.';
    } else {
      return 'Đã xảy ra lỗi: ${error.message}';
    }
  }
}

