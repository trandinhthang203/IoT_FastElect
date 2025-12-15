# FastElec App - Ứng dụng Quản lý Tiền Điện

Ứng dụng di động quản lý và theo dõi tiền điện được xây dựng bằng Flutter.

## Tính năng

### 1. Đăng nhập
- Đăng nhập bằng email và mật khẩu
- Quên mật khẩu
- Đăng ký tài khoản mới

### 2. Thông tin Tiền điện
- Xem thông tin phòng và người thuê
- Hiển thị số điện hiện tại
- Theo dõi tiêu thụ điện tháng hiện tại
- Xem chi phí ước tính
- Trạng thái thanh toán
- Thanh toán trực tuyến
- Xem lịch sử hóa đơn

### 3. Theo dõi Điện năng
- Xem biểu đồ tiêu thụ điện theo tuần/tháng
- Thống kê mức tiêu thụ
- Lịch sử ghi nhận chỉ số điện hàng ngày
- So sánh mức tiêu thụ

### 4. Lịch sử Tiền điện
- Xem lịch sử hóa đơn các tháng
- Trạng thái thanh toán từng hóa đơn
- Chi tiết tiêu thụ và số tiền từng tháng

### 5. Thông báo
- Thông báo chỉ số điện mới
- Nhắc nhở thanh toán
- Xác nhận thanh toán thành công
- Cảnh báo thanh toán quá hạn
- Thông báo chung về dịch vụ

### 6. Tài khoản
- Xem và chỉnh sửa thông tin cá nhân
- Đổi mật khẩu
- Cài đặt thông báo
- Đăng xuất

## Cấu trúc Dự án

```
fastelec_app/
├── lib/
│   ├── main.dart                          # Entry point
│   └── screens/
│       ├── login_screen.dart              # Màn hình đăng nhập
│       ├── home_screen.dart               # Màn hình chính với bottom navigation
│       ├── bill_info_screen.dart          # Màn hình thông tin tiền điện
│       ├── energy_tracking_screen.dart    # Màn hình theo dõi điện năng
│       ├── bill_history_screen.dart       # Màn hình lịch sử hóa đơn
│       ├── notifications_screen.dart      # Màn hình thông báo
│       └── profile_screen.dart            # Màn hình tài khoản
├── pubspec.yaml                           # Dependencies
└── README.md                              # Tài liệu
```

## Yêu cầu Hệ thống

- Flutter SDK: >= 3.0.0
- Dart SDK: >= 3.0.0

## Cài đặt

1. Clone repository:
```bash
git clone https://github.com/IoT-2110/fastelec-app.git
cd fastelec-app
```

2. Cài đặt dependencies:
```bash
flutter pub get
```

3. Chạy ứng dụng:
```bash
flutter run
```

## Dependencies Chính

- **fl_chart**: ^0.66.0 - Thư viện biểu đồ
- **provider**: ^6.1.1 - State management
- **http**: ^1.1.2 - HTTP requests
- **dio**: ^5.4.0 - Advanced HTTP client
- **shared_preferences**: ^2.2.2 - Local storage
- **intl**: ^0.19.0 - Internationalization

## Màu sắc Ứng dụng

- **Background**: #0F1E2E (Dark blue)
- **Card/Surface**: #1E3A5F (Medium blue)
- **Primary**: #2196F3 (Blue)
- **Text Primary**: #FFFFFF (White)
- **Text Secondary**: Grey shades
- **Status Colors**:
  - Success/Paid: Green
  - Warning/Unpaid: Orange
  - Error/Overdue: Red

## Dữ liệu Mock

Hiện tại ứng dụng sử dụng dữ liệu mock để demo. Các dữ liệu thực sẽ được tích hợp thông qua API trong phiên bản tiếp theo.

## Tính năng Tương lai

- [ ] Tích hợp API backend
- [ ] Xác thực đa yếu tố (2FA)
- [ ] Thanh toán qua ví điện tử
- [ ] Xuất hóa đơn PDF
- [ ] Thống kê chi tiết hơn
- [ ] Dark/Light theme toggle
- [ ] Đa ngôn ngữ (Vietnamese/English)
- [ ] Push notifications

## Đóng góp

Mọi đóng góp đều được hoan nghênh. Vui lòng tạo Pull Request hoặc Issue để thảo luận về thay đổi.

## License

MIT License

## Liên hệ

- Repository: https://github.com/IoT-2110/fastelec-app
- Issues: https://github.com/IoT-2110/fastelec-app/issues

---

> Phát triển bởi IoT-2110 Team
