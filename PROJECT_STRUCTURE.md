# Cấu trúc Dự án FastElec

## Tổng quan

Dự án FastElec là ứng dụng mobile quản lý tiền điện được xây dựng bằng Flutter. Ứng dụng bao gồm 6 màn hình chính với giao diện dark mode hiện đại.

## Cấu trúc Thư mục

```
fastelec_app/
│
├── lib/                                    # Mã nguồn chính
│   ├── main.dart                          # Entry point, cấu hình theme và routing
│   │
│   └── screens/                           # Các màn hình của ứng dụng
│       ├── login_screen.dart              # Màn hình đăng nhập
│       ├── home_screen.dart               # Màn hình chính với bottom navigation
│       ├── bill_info_screen.dart          # Màn hình thông tin tiền điện
│       ├── energy_tracking_screen.dart    # Màn hình theo dõi điện năng
│       ├── bill_history_screen.dart       # Màn hình lịch sử hóa đơn
│       ├── notifications_screen.dart      # Màn hình thông báo
│       └── profile_screen.dart            # Màn hình tài khoản người dùng
│
├── pubspec.yaml                           # Dependencies và cấu hình project
├── analysis_options.yaml                  # Cấu hình linting rules
├── .gitignore                            # Files/folders bị ignore bởi Git
├── README.md                             # Tài liệu chính của dự án
├── SETUP.md                              # Hướng dẫn cài đặt và chạy
└── PROJECT_STRUCTURE.md                  # File này - Giải thích cấu trúc dự án

```

## Chi tiết từng file

### 1. main.dart
- **Chức năng**: Entry point của ứng dụng
- **Nội dung**:
  - Cấu hình MaterialApp với dark theme
  - Định nghĩa color scheme (background: #0F1E2E, surface: #1E3A5F, primary: #2196F3)
  - Cấu hình InputDecoration theme, Button theme
  - Set màn hình khởi đầu là LoginScreen

### 2. screens/login_screen.dart
- **Chức năng**: Màn hình đăng nhập
- **Features**:
  - Email input field
  - Password input field với show/hide password
  - Forgot password link
  - Login button → chuyển đến HomeScreen
  - Sign up link
  - Mock login (không cần authenticate thật)

### 3. screens/home_screen.dart
- **Chức năng**: Container chính với bottom navigation
- **Features**:
  - Bottom navigation bar với 5 tabs:
    1. Trang chủ (BillInfoScreen)
    2. Điện năng (EnergyTrackingScreen)
    3. Lịch sử (BillHistoryScreen)
    4. Thông báo (NotificationsScreen)
    5. Tài khoản (ProfileScreen)
  - State management cho tab switching

### 4. screens/bill_info_screen.dart
- **Chức năng**: Hiển thị thông tin hóa đơn tiền điện hiện tại
- **Features**:
  - Thông tin phòng (Phòng P.101)
  - Thông tin người thuê
  - Địa chỉ
  - Số điện hiện tại (1520 kWh)
  - Tiêu thụ tháng này (125 kWh)
  - Chi phí ước tính (312,500 VND)
  - Trạng thái thanh toán (badge)
  - Button "Thanh toán ngay"
  - Button "Xem lịch sử" → navigate to BillHistoryScreen

### 5. screens/energy_tracking_screen.dart
- **Chức năng**: Theo dõi và thống kê điện năng tiêu thụ
- **Features**:
  - Kỳ thanh toán hiện tại (150.5 kWh)
  - Tổng tiền tạm tính
  - Trạng thái thanh toán
  - Toggle giữa "Tuần này" và "Tháng này"
  - Biểu đồ line chart (fl_chart) hiển thị mức tiêu thụ
  - Phần trăm thay đổi (+5.2%)
  - Lịch sử ghi nhận hàng ngày (chỉ số cũ, chỉ số mới, tiêu thụ)

### 6. screens/bill_history_screen.dart
- **Chức năng**: Hiển thị lịch sử hóa đơn các tháng
- **Features**:
  - Danh sách các hóa đơn theo tháng
  - Mỗi card hiển thị:
    - Tháng/năm
    - Tổng điện tiêu thụ
    - Tổng tiền
    - Trạng thái (Đã thanh toán/Chưa thanh toán)
  - Format số tiền với dấu phẩy

### 7. screens/notifications_screen.dart
- **Chức năng**: Hiển thị các thông báo
- **Features**:
  - Chia thành 3 sections: Hôm nay, Hôm qua, Cũ hơn
  - Mỗi notification có:
    - Icon với màu sắc theo loại
    - Tiêu đề
    - Nội dung chi tiết
    - Thời gian
  - Các loại thông báo:
    - Chỉ số điện mới (orange)
    - Sắp đến hạn thanh toán (orange)
    - Thanh toán thành công (green)
    - Thanh toán quá hạn (red)
    - Thông báo chung (grey)

### 8. screens/profile_screen.dart
- **Chức năng**: Quản lý thông tin cá nhân và cài đặt
- **Features**:
  - Avatar với edit button
  - Thông tin cá nhân:
    - Họ tên (Trần Văn A)
    - Email (example@email.com)
    - Số điện thoại (090 xxx 1234)
  - Button "Chỉnh sửa thông tin"
  - Phần Bảo mật:
    - Đổi mật khẩu
  - Phần Cài đặt:
    - Toggle thông báo
  - Button Đăng xuất (red) → về LoginScreen
  - Confirmation dialog khi đăng xuất

## Dependencies Chính

```yaml
dependencies:
  flutter: sdk
  fl_chart: ^0.66.0          # Biểu đồ cho energy tracking
  provider: ^6.1.1           # State management (future use)
  http: ^1.1.2               # HTTP requests (future API)
  dio: ^5.4.0                # Advanced HTTP client (future API)
  shared_preferences: ^2.2.2 # Local storage (future use)
  intl: ^0.19.0              # Format số, ngày tháng
```

## Color Scheme

```dart
- Background: #0F1E2E (Dark blue)
- Card/Surface: #1E3A5F (Medium blue)
- Primary: #2196F3 (Blue)
- Text Primary: #FFFFFF (White)
- Text Secondary: Grey[400], Grey[300]
- Success: Green
- Warning: Orange (#FFA726)
- Error: Red (#E53935)
```

## Navigation Flow

```
LoginScreen
    ↓ (login)
HomeScreen
    ├── Tab 0: BillInfoScreen
    │           ├── Button: Thanh toán ngay → Snackbar (mock)
    │           └── Button: Xem lịch sử → BillHistoryScreen
    │
    ├── Tab 1: EnergyTrackingScreen
    │           └── Back button → HomeScreen
    │
    ├── Tab 2: BillHistoryScreen
    │           └── Back button → HomeScreen
    │
    ├── Tab 3: NotificationsScreen
    │           └── Back button → HomeScreen
    │
    └── Tab 4: ProfileScreen
                ├── Chỉnh sửa thông tin → Snackbar (mock)
                ├── Đổi mật khẩu → Snackbar (mock)
                └── Đăng xuất → LoginScreen (clear stack)
```

## Mock Data

Tất cả các màn hình hiện sử dụng mock data:
- User: Trần Văn A, example@email.com
- Room: Phòng P.101
- Current reading: 1520 kWh
- Monthly consumption: 125-150 kWh
- Bill amounts: 384,000 - 451,500 VND
- Chart data: Random consumption patterns

## Future Improvements

1. **State Management**:
   - Implement Provider/Riverpod cho global state
   - Separate business logic từ UI

2. **API Integration**:
   - Connect với backend API
   - Authentication với JWT tokens
   - Real-time data updates

3. **Models**:
   - Tạo data models (User, Bill, Notification, etc.)
   - JSON serialization

4. **Services**:
   - API service layer
   - Authentication service
   - Local storage service

5. **Utils**:
   - Date formatters
   - Number formatters
   - Constants file

6. **Additional Features**:
   - Payment gateway integration
   - PDF export
   - Push notifications
   - Multi-language support

## Cách Mở Rộng

### Thêm màn hình mới:
1. Tạo file mới trong `lib/screens/`
2. Import vào `home_screen.dart` nếu cần bottom nav item
3. Hoặc navigate từ màn hình khác

### Thêm theme mới:
1. Mở `main.dart`
2. Thêm ThemeData trong MaterialApp
3. Implement theme switcher

### Connect API:
1. Tạo `lib/services/api_service.dart`
2. Tạo `lib/models/` cho data models
3. Update các screen để dùng real data

## Testing

```bash
# Run tests (khi có test files)
flutter test

# Run app trong debug mode
flutter run

# Run app trong profile mode (performance testing)
flutter run --profile

# Run app trong release mode
flutter run --release
```

## Build Commands

```bash
# Build APK
flutter build apk --release

# Build App Bundle (cho Play Store)
flutter build appbundle --release

# Build iOS (trên macOS)
flutter build ios --release
```

## Liên hệ & Support

- GitHub: https://github.com/IoT-2110/fastelec-app
- Issues: https://github.com/IoT-2110/fastelec-app/issues

---
> Cre: IoT-2110 Team, at 19/11/2025
