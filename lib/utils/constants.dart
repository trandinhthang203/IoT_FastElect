class ApiConstants {
  static const String baseUrl = 'http://103.249.200.211:3000/api';
  static const String loginEndpoint = '/v1/auth/login/mobile-app';
  static const String logoutEndpoint = '/v1/auth/logout';
  static const String monthlyConsumptionEndpoint = '/v1/consumptions/monthly';
  static const String latestConsumptionEndpoint = '/v1/consumptions/monthly/latest';
  static const String dailyConsumptionEndpoint = '/v1/consumptions/daily';
  
  static const String tokenKey = 'access_token';
}

//a lại chỗ hiển thị dòng chữ 'Số điện hiện tại' và 'Tiêu thụ tháng này' nếu 2 dòng chữ đó quá dài thì có thể cho các thẻ 'Tháng trước'và 'Giá' dịch xuống dưới 1 chút để các dòng chữ đó koong bị ép theo chiều dọc như vậy.
// và khi bấm vào 'Chi tiết' thì chuyển sang tab Điện năng