# Hướng dẫn Cài đặt và Chạy Ứng dụng FastElec

## Bước 1: Cài đặt Flutter

### Windows
1. Tải Flutter SDK từ: https://docs.flutter.dev/get-started/install/windows
2. Giải nén file vào thư mục (ví dụ: C:\src\flutter)
3. Thêm Flutter vào PATH environment variable
4. Chạy `flutter doctor` để kiểm tra

### macOS
1. Tải Flutter SDK từ: https://docs.flutter.dev/get-started/install/macos
2. Giải nén file vào thư mục
3. Thêm vào PATH trong file ~/.zshrc hoặc ~/.bash_profile:
   ```bash
   export PATH="$PATH:[PATH_TO_FLUTTER_DIRECTORY]/flutter/bin"
   ```
4. Chạy `flutter doctor` để kiểm tra

### Linux
1. Tải Flutter SDK từ: https://docs.flutter.dev/get-started/install/linux
2. Giải nén và thêm vào PATH
3. Chạy `flutter doctor` để kiểm tra

## Bước 2: Cài đặt Android Studio / Xcode

### Android (Android Studio)
1. Tải Android Studio: https://developer.android.com/studio
2. Cài đặt Android SDK và Android SDK Platform-Tools
3. Tạo Android Virtual Device (AVD) để test

### iOS (chỉ trên macOS)
1. Cài đặt Xcode từ App Store
2. Cài đặt Xcode command line tools:
   ```bash
   sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
   sudo xcodebuild -runFirstLaunch
   ```
3. Cài đặt CocoaPods:
   ```bash
   sudo gem install cocoapods
   ```

## Bước 3: Clone và Setup Project

1. Clone repository:
```bash
git clone https://github.com/IoT-2110/fastelec-app.git
cd fastelec-app
```

2. Cài đặt dependencies:
```bash
flutter pub get
```

3. Kiểm tra thiết bị kết nối:
```bash
flutter devices
```

## Bước 4: Chạy Ứng dụng

### Chạy trên Emulator/Simulator
```bash
# Khởi động emulator (Android)
flutter emulators --launch <emulator_id>

# Hoặc khởi động simulator (iOS)
open -a Simulator

# Chạy app
flutter run
```

### Chạy trên thiết bị thật
1. Bật USB Debugging trên thiết bị Android
   - Vào Settings > About phone
   - Tap 7 lần vào Build number
   - Vào Developer options > Bật USB debugging

2. Kết nối thiết bị qua USB

3. Chạy app:
```bash
flutter run
```

### Chạy ở chế độ Release
```bash
flutter run --release
```

## Bước 5: Build APK/IPA

### Build APK (Android)
```bash
# Build APK
flutter build apk

# Build APK tách theo ABI (kích thước nhỏ hơn)
flutter build apk --split-per-abi

# File APK sẽ ở: build/app/outputs/flutter-apk/
```

### Build App Bundle (Android - khuyến nghị cho Google Play)
```bash
flutter build appbundle

# File AAB sẽ ở: build/app/outputs/bundle/release/
```

### Build IPA (iOS)
```bash
flutter build ios --release

# Sau đó mở Xcode để archive và export
open ios/Runner.xcworkspace
```

## Troubleshooting

### Lỗi "Waiting for another flutter command to release the startup lock"
```bash
rm -rf [FLUTTER_DIRECTORY]/bin/cache/lockfile
```

### Lỗi Gradle (Android)
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### Lỗi CocoaPods (iOS)
```bash
cd ios
pod deintegrate
pod install
cd ..
```

### Lỗi "Unable to locate Android SDK"
- Mở Android Studio
- Vào Tools > SDK Manager
- Cài đặt Android SDK

## Các lệnh hữu ích

```bash
# Xem danh sách thiết bị
flutter devices

# Xem danh sách emulator
flutter emulators

# Clean project
flutter clean

# Xem phiên bản Flutter
flutter --version

# Kiểm tra sức khỏe Flutter
flutter doctor -v

# Hot reload (khi app đang chạy)
# Nhấn 'r' trong terminal

# Hot restart (khi app đang chạy)
# Nhấn 'R' trong terminal

# Thoát debug mode
# Nhấn 'q' trong terminal
```

## Debug trong VS Code

1. Cài đặt extensions:
   - Flutter
   - Dart

2. Mở project trong VS Code

3. Nhấn F5 hoặc vào Run > Start Debugging

4. Chọn thiết bị từ status bar

## Cấu hình VS Code (launch.json)

Tạo file `.vscode/launch.json`:

```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "FastElec (Debug)",
            "request": "launch",
            "type": "dart",
            "program": "lib/main.dart"
        },
        {
            "name": "FastElec (Profile)",
            "request": "launch",
            "type": "dart",
            "program": "lib/main.dart",
            "flutterMode": "profile"
        },
        {
            "name": "FastElec (Release)",
            "request": "launch",
            "type": "dart",
            "program": "lib/main.dart",
            "flutterMode": "release"
        }
    ]
}
```

## Tài liệu tham khảo

- Flutter Documentation: https://docs.flutter.dev/
- Flutter Cookbook: https://docs.flutter.dev/cookbook
- Dart Language: https://dart.dev/guides
- Material Design: https://material.io/design

## Hỗ trợ

Nếu gặp vấn đề, vui lòng tạo Issue tại:
https://github.com/IoT-2110/fastelec-app/issues
