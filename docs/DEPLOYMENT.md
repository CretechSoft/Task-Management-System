# Deployment Guide

## Prerequisites

- Flutter SDK 3.0 or higher
- Android Studio / Xcode for mobile deployment
- Firebase project for push notifications (optional)
- Backend API deployed and accessible

## Environment Configuration

### 1. Configure API Endpoints

Edit `lib/core/config/app_config.dart`:

```dart
class AppConfig {
  // Development
  static const String devBaseUrl = 'https://dev-api.taskmanagement.com';
  
  // Staging
  static const String stagingBaseUrl = 'https://staging-api.taskmanagement.com';
  
  // Production
  static const String prodBaseUrl = 'https://api.taskmanagement.com';
  
  // Current environment
  static const String baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: devBaseUrl,
  );
}
```

### 2. Setup Firebase (Optional)

1. Create a Firebase project at https://console.firebase.google.com
2. Add Android app with package name: `com.cretechsoft.taskmanagement`
3. Add iOS app with bundle ID: `com.cretechsoft.taskmanagement`
4. Download and add configuration files:
   - Android: `google-services.json` → `android/app/`
   - iOS: `GoogleService-Info.plist` → `ios/Runner/`

### 3. Environment Variables

Create `.env` file for different environments:

```env
# .env.development
API_URL=https://dev-api.taskmanagement.com
ENVIRONMENT=development

# .env.staging
API_URL=https://staging-api.taskmanagement.com
ENVIRONMENT=staging

# .env.production
API_URL=https://api.taskmanagement.com
ENVIRONMENT=production
```

## Android Deployment

### 1. Configure App Signing

Create `android/key.properties`:

```properties
storePassword=<your-store-password>
keyPassword=<your-key-password>
keyAlias=upload
storeFile=<path-to-keystore>
```

Generate keystore:

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload
```

### 2. Update Build Configuration

Edit `android/app/build.gradle`:

```gradle
android {
    defaultConfig {
        applicationId "com.cretechsoft.taskmanagement"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode 1
        versionName "1.0.0"
    }

    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }

    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }
}
```

### 3. Build Release APK

```bash
# Build APK
flutter build apk --release

# Build App Bundle (recommended for Play Store)
flutter build appbundle --release
```

Output locations:
- APK: `build/app/outputs/flutter-apk/app-release.apk`
- AAB: `build/app/outputs/bundle/release/app-release.aab`

### 4. Deploy to Google Play Store

1. Create a Google Play Console account
2. Create a new application
3. Fill in app details and store listing
4. Upload AAB file
5. Set up pricing and distribution
6. Submit for review

## iOS Deployment

### 1. Configure Xcode Project

Open `ios/Runner.xcworkspace` in Xcode:

1. Select Runner target
2. Update Bundle Identifier: `com.cretechsoft.taskmanagement`
3. Set deployment target to iOS 12.0 or higher
4. Configure signing & capabilities:
   - Enable automatic signing
   - Select your development team

### 2. Update Info.plist

Add required permissions in `ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to upload photos</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>This app needs photo library access to upload images</string>
<key>NSMicrophoneUsageDescription</key>
<string>This app needs microphone access to record videos</string>
```

### 3. Build Release IPA

```bash
# Build for iOS
flutter build ios --release

# Or build IPA directly
flutter build ipa --release
```

### 4. Deploy to App Store

1. Open Xcode
2. Product → Archive
3. Upload to App Store Connect
4. Fill in app metadata
5. Submit for review

## Web Deployment

### 1. Build Web App

```bash
flutter build web --release
```

Output: `build/web/`

### 2. Deploy to Hosting

#### Firebase Hosting

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login
firebase login

# Initialize
firebase init hosting

# Deploy
firebase deploy --only hosting
```

#### Netlify

```bash
# Install Netlify CLI
npm install -g netlify-cli

# Deploy
netlify deploy --dir=build/web --prod
```

#### Custom Server

Upload contents of `build/web/` to your web server's public directory.

Configure web server (nginx example):

```nginx
server {
    listen 80;
    server_name taskmanagement.com;
    root /var/www/taskmanagement/build/web;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    # Cache static assets
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
```

## Desktop Deployment

### Windows

```bash
flutter build windows --release
```

Output: `build/windows/runner/Release/`

Create installer using Inno Setup or NSIS.

### macOS

```bash
flutter build macos --release
```

Output: `build/macos/Build/Products/Release/`

Create DMG installer:

```bash
npm install -g create-dmg
create-dmg 'build/macos/Build/Products/Release/task_management_system.app'
```

### Linux

```bash
flutter build linux --release
```

Output: `build/linux/x64/release/bundle/`

## CI/CD Pipeline

### GitHub Actions Example

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
      - run: flutter pub get
      - run: flutter test
      - run: flutter analyze

  build-android:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
      - run: flutter pub get
      - run: flutter build apk --release
      - uses: actions/upload-artifact@v3
        with:
          name: android-apk
          path: build/app/outputs/flutter-apk/app-release.apk

  build-ios:
    needs: test
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
      - run: flutter pub get
      - run: flutter build ios --release --no-codesign
      - uses: actions/upload-artifact@v3
        with:
          name: ios-build
          path: build/ios/iphoneos/

  build-web:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
      - run: flutter pub get
      - run: flutter build web --release
      - uses: actions/upload-artifact@v3
        with:
          name: web-build
          path: build/web/
```

## Production Checklist

### Pre-Deployment

- [ ] All tests passing
- [ ] No linter warnings
- [ ] API endpoints configured correctly
- [ ] Firebase configured (if using)
- [ ] App signing configured
- [ ] Version numbers updated
- [ ] Release notes prepared
- [ ] Privacy policy and terms of service ready

### Security

- [ ] API keys not hardcoded
- [ ] Sensitive data encrypted
- [ ] HTTPS enforced
- [ ] Certificate pinning implemented (optional)
- [ ] ProGuard/R8 enabled for Android
- [ ] Code obfuscation enabled

### Performance

- [ ] Images optimized
- [ ] Build optimized for release
- [ ] Lazy loading implemented
- [ ] Caching configured
- [ ] Bundle size optimized

### Compliance

- [ ] GDPR compliance (if applicable)
- [ ] Data retention policies documented
- [ ] User consent mechanisms in place
- [ ] Analytics tracking disclosed

### Monitoring

- [ ] Crash reporting configured (Firebase Crashlytics)
- [ ] Analytics configured (Firebase Analytics)
- [ ] Performance monitoring enabled
- [ ] Error logging setup

## Post-Deployment

### Monitoring

1. Check crash reports daily
2. Monitor user feedback
3. Track key metrics (DAU, retention, etc.)
4. Monitor API performance

### Updates

1. Plan regular updates (monthly recommended)
2. Follow semantic versioning
3. Maintain changelog
4. Test updates thoroughly before release

### Support

1. Setup support channels (email, chat)
2. Create user documentation
3. Prepare FAQ
4. Train support team

## Rollback Plan

If issues are discovered after deployment:

1. **Immediate**: Disable features via remote config
2. **Short-term**: Deploy hotfix release
3. **Last resort**: Roll back to previous version

Keep previous APK/IPA versions for quick rollback.

## Version Management

Follow semantic versioning: `MAJOR.MINOR.PATCH`

- **MAJOR**: Breaking changes
- **MINOR**: New features (backwards compatible)
- **PATCH**: Bug fixes

Example: `1.2.3`

Update in:
- `pubspec.yaml` → `version: 1.2.3+10` (version+build number)
- Android → `versionCode` and `versionName`
- iOS → `CFBundleVersion` and `CFBundleShortVersionString`
