# Build Instructions

This document provides comprehensive instructions for building the Task Management System across different platforms and environments.

## Table of Contents
- [Prerequisites](#prerequisites)
- [First-Time Setup](#first-time-setup)
- [Code Generation](#code-generation)
- [Development Build](#development-build)
- [Production Build](#production-build)
- [Platform-Specific Builds](#platform-specific-builds)
- [Troubleshooting](#troubleshooting)

## Prerequisites

### Required Software

1. **Flutter SDK** (>= 3.0.0)
   - Download: https://flutter.dev/docs/get-started/install
   - Verify: `flutter --version`

2. **Dart SDK** (comes with Flutter)
   - Verify: `dart --version`

3. **Git**
   - Download: https://git-scm.com/downloads
   - Verify: `git --version`

4. **Platform-Specific Tools**:
   - **Android**: Android Studio with Android SDK
   - **iOS**: Xcode (macOS only)
   - **Web**: Chrome browser
   - **Desktop**: Platform-specific tools (Visual Studio for Windows, Xcode for macOS)

## First-Time Setup

### 1. Clone Repository

```bash
git clone https://github.com/CretechSoft/Task-Management-System.git
cd Task-Management-System
```

### 2. Check Flutter Setup

```bash
flutter doctor -v
```

Fix any issues reported by `flutter doctor`.

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Generate Code Files

**CRITICAL STEP:** This project uses `freezed` for immutable models and `json_serializable` for JSON conversion. You must generate code files before building:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

This command generates:
- `*.freezed.dart` - Immutable model implementations
- `*.g.dart` - JSON serialization code

**Expected output:**
```
[INFO] Generating build script...
[INFO] Generating build script completed, took 2.5s
[INFO] Creating build script snapshot......
[INFO] Creating build script snapshot... completed, took 10.2s
[INFO] Building new asset graph...
[INFO] Building new asset graph completed, took 1.5s
[INFO] Checking for unexpected pre-existing outputs....
[INFO] Deleting 0 declared outputs which already existed on disk.
[INFO] Running build...
[INFO] Running build completed, took 15.4s
[INFO] Caching finalized dependency graph...
[INFO] Caching finalized dependency graph completed, took 0.3s
[INFO] Succeeded after 15.7s with 42 outputs
```

**Note:** If you see errors about missing files, this is expected on first run. The build_runner will create them.

## Code Generation

### One-Time Generation

Use when you want to generate code once:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Watch Mode (Recommended for Development)

Auto-regenerates code when you modify entity files:

```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

Keep this running in a separate terminal while developing.

### Clean and Rebuild

If you encounter issues:

```bash
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

## Development Build

### Run on Device/Emulator

```bash
# List available devices
flutter devices

# Run on default device
flutter run

# Run on specific device
flutter run -d <device-id>

# Run with debugging enabled (default)
flutter run --debug

# Run with hot reload enabled (default)
flutter run
```

### Hot Reload

While the app is running:
- Press `r` to hot reload
- Press `R` to hot restart
- Press `q` to quit

### Development Tools

```bash
# Analyze code
flutter analyze

# Format code
flutter format lib/ test/

# Run tests
flutter test

# Run tests with coverage
flutter test --coverage

# Check dependencies
flutter pub outdated
```

## Production Build

### Android

#### APK (for testing/distribution)

```bash
# Standard APK
flutter build apk --release

# Split APKs by architecture (smaller files)
flutter build apk --split-per-abi --release
```

Output location:
- Standard: `build/app/outputs/flutter-apk/app-release.apk`
- Split: `build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk`, etc.

#### App Bundle (for Play Store)

```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

### iOS

```bash
# Build iOS app
flutter build ios --release

# Build without code signing (for CI)
flutter build ios --release --no-codesign
```

Then open `ios/Runner.xcworkspace` in Xcode to:
1. Configure signing
2. Archive the app
3. Submit to App Store

### Web

```bash
# Build for web
flutter build web --release

# Build with specific renderer
flutter build web --release --web-renderer canvaskit
flutter build web --release --web-renderer html
```

Output: `build/web/`

Deploy to hosting:
```bash
# Example: Firebase Hosting
firebase deploy --only hosting

# Example: GitHub Pages
# Copy build/web/* to gh-pages branch
```

### Desktop

#### Windows

```bash
flutter build windows --release
```

Output: `build/windows/runner/Release/`

#### macOS

```bash
flutter build macos --release
```

Output: `build/macos/Build/Products/Release/`

#### Linux

```bash
flutter build linux --release
```

Output: `build/linux/x64/release/bundle/`

## Platform-Specific Builds

### Android Configuration

1. **Update package name** in `android/app/build.gradle`:
```gradle
defaultConfig {
    applicationId "com.cretechsoft.task_management"
    // ...
}
```

2. **Configure signing** in `android/key.properties`:
```properties
storePassword=<password>
keyPassword=<password>
keyAlias=<key-alias>
storeFile=<keystore-file-path>
```

3. **Update app name** in `android/app/src/main/AndroidManifest.xml`:
```xml
<application
    android:label="Task Management"
    ...>
```

### iOS Configuration

1. **Update bundle identifier** in `ios/Runner.xcodeproj`

2. **Configure signing** in Xcode:
   - Open `ios/Runner.xcworkspace`
   - Select Runner target
   - Configure signing certificate

3. **Update display name** in `ios/Runner/Info.plist`:
```xml
<key>CFBundleDisplayName</key>
<string>Task Management</string>
```

### Web Configuration

1. **Update title** in `web/index.html`:
```html
<title>Task Management System</title>
```

2. **Configure base href** for deployment:
```html
<base href="/">
<!-- or for subdirectory -->
<base href="/task-management/">
```

## Build Optimization

### Reduce App Size

```bash
# Use split APKs
flutter build apk --split-per-abi --release

# Enable code shrinking (Android)
# Add to android/app/build.gradle:
buildTypes {
    release {
        minifyEnabled true
        shrinkResources true
        proguardFiles getDefaultProguardFile('proguard-android.txt')
    }
}
```

### Optimize Performance

```bash
# Build with performance profiling
flutter build apk --profile

# Analyze app size
flutter build apk --analyze-size
```

## Troubleshooting

### Common Issues

#### 1. Missing Generated Files

**Error:**
```
Error: Couldn't resolve the import 'package:task_management/domain/entities/task.freezed.dart'
```

**Solution:**
```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

#### 2. Outdated Generated Files

**Error:**
```
The getter 'xxx' isn't defined for the type 'Task'
```

**Solution:**
```bash
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

#### 3. Build Conflicts

**Error:**
```
Conflicting outputs were detected...
```

**Solution:**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

#### 4. Gradle Issues (Android)

**Error:**
```
FAILURE: Build failed with an exception.
```

**Solution:**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter build apk
```

#### 5. Pod Install Issues (iOS)

**Error:**
```
CocoaPods not installed or not in valid state
```

**Solution:**
```bash
cd ios
pod deintegrate
pod install
cd ..
flutter clean
flutter build ios
```

#### 6. Cache Issues

**Solution:**
```bash
flutter clean
flutter pub cache repair
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Clean Build (Nuclear Option)

If all else fails:

```bash
# Clean everything
flutter clean
cd android && ./gradlew clean && cd ..
cd ios && rm -rf Pods && pod deintegrate && pod install && cd ..

# Reinstall dependencies
flutter pub get

# Regenerate code
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs

# Rebuild
flutter build <platform> --release
```

## CI/CD Integration

### GitHub Actions

The project includes `.github/workflows/ci.yml` for automated builds:

```yaml
- Run analyzer
- Run tests
- Build Android APK
- Build iOS (on macOS runner)
- Build Web
```

### Environment Variables

For CI/CD, set these environment variables:

```bash
# API Configuration
API_BASE_URL=https://api.example.com

# Android Signing (for CI)
ANDROID_KEYSTORE_BASE64=<base64-encoded-keystore>
ANDROID_KEY_ALIAS=<key-alias>
ANDROID_KEY_PASSWORD=<password>
ANDROID_STORE_PASSWORD=<password>

# iOS Signing (for CI)
IOS_CERTIFICATE_BASE64=<base64-encoded-cert>
IOS_PROVISION_PROFILE_BASE64=<base64-encoded-profile>
```

## Build Checklist

Before releasing:

- [ ] Run `flutter analyze` - no issues
- [ ] Run `flutter test` - all tests pass
- [ ] Generate code: `flutter pub run build_runner build --delete-conflicting-outputs`
- [ ] Update version in `pubspec.yaml`
- [ ] Update `CHANGELOG.md`
- [ ] Test on physical devices (Android & iOS)
- [ ] Test all critical user flows
- [ ] Build release version
- [ ] Test release build on device
- [ ] Create release notes
- [ ] Tag release in Git
- [ ] Upload to stores/deploy

## Support

For build issues:
1. Check this document
2. Check [SETUP_GUIDE.md](SETUP_GUIDE.md)
3. Run `flutter doctor -v`
4. Check Flutter issues: https://github.com/flutter/flutter/issues
5. Create an issue in this repository

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Flutter Build Modes](https://flutter.dev/docs/testing/build-modes)
- [Freezed Package](https://pub.dev/packages/freezed)
- [Build Runner](https://pub.dev/packages/build_runner)
- [JSON Serializable](https://pub.dev/packages/json_serializable)
