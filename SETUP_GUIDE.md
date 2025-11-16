# Setup Guide - Task Management System

## Prerequisites

Before running this Flutter application, ensure you have the following installed:

1. **Flutter SDK** (3.0.0 or later)
   - Download from: https://flutter.dev/docs/get-started/install
   - Verify installation: `flutter --version`

2. **Dart SDK** (comes with Flutter)

3. **Android Studio** or **VS Code** with Flutter extensions

4. **Git**

## Installation Steps

### 1. Clone the Repository

```bash
git clone https://github.com/CretechSoft/Task-Management-System.git
cd Task-Management-System
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Generate Code (Freezed & JSON Serialization)

This project uses `freezed` for immutable data models and `json_serializable` for JSON serialization. Run the following command to generate the required files:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

This will generate:
- `*.freezed.dart` files for all domain entities
- `*.g.dart` files for JSON serialization
- User, Project, Department entity files

**Note:** You must run this command before running the app for the first time, or whenever you modify entity files.

### 4. Configure Environment (Optional)

Copy the example environment file and configure it:

```bash
cp .env.example .env
```

Edit `.env` with your configuration:
```env
API_BASE_URL=https://your-api-url.com
API_TIMEOUT=30000
FIREBASE_API_KEY=your_firebase_key
# ... other configurations
```

### 5. Run the Application

#### On Android/iOS Emulator or Physical Device:

```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device-id>

# Run in debug mode (default)
flutter run

# Run in release mode (optimized)
flutter run --release
```

#### On Web:

```bash
flutter run -d chrome
# or
flutter run -d web-server
```

#### On Desktop (Windows/macOS/Linux):

```bash
# Windows
flutter run -d windows

# macOS
flutter run -d macos

# Linux
flutter run -d linux
```

## Build for Production

### Android APK

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle (for Play Store)

```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

### iOS

```bash
flutter build ios --release
```

Then open `ios/Runner.xcworkspace` in Xcode to archive and submit to App Store.

### Web

```bash
flutter build web --release
```

Output: `build/web/`

### Desktop

```bash
# Windows
flutter build windows --release

# macOS
flutter build macos --release

# Linux
flutter build linux --release
```

## Troubleshooting

### Common Issues

#### 1. Missing Generated Files

**Error:** `Error: Couldn't resolve the import 'package:task_management/domain/entities/task.freezed.dart'`

**Solution:**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

#### 2. Dependency Conflicts

**Error:** Package version conflicts

**Solution:**
```bash
flutter pub upgrade
flutter pub get
```

#### 3. Clean Build

If you encounter persistent issues:

```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

#### 4. Cache Issues

```bash
flutter pub cache repair
```

## Development Workflow

### Watch Mode for Code Generation

Instead of running `build_runner` manually every time you change entities, use watch mode:

```bash
flutter pub run build_runner watch
```

This will automatically regenerate files when you save changes.

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/unit/task_repository_test.dart

# Run with coverage
flutter test --coverage
```

### Code Analysis

```bash
# Analyze code
flutter analyze

# Format code
flutter format lib/ test/
```

## Default Credentials

For development/testing, use these credentials:

- **Email:** test@example.com
- **Password:** password123

## Project Structure

```
lib/
├── core/               # Core functionality
│   ├── config/         # App configuration
│   ├── constants/      # Constants
│   ├── di/            # Dependency injection
│   ├── error/         # Error handling
│   ├── l10n/          # Localization
│   ├── router/        # Navigation
│   ├── theme/         # App theme
│   └── utils/         # Utility functions
├── data/              # Data layer
│   └── repositories/  # Repository implementations
├── domain/            # Domain layer
│   ├── entities/      # Business entities
│   └── repositories/  # Repository interfaces
└── features/          # Feature modules
    ├── auth/          # Authentication
    ├── dashboard/     # Dashboard
    ├── tasks/         # Task management
    ├── projects/      # Projects
    ├── departments/   # Departments
    ├── employees/     # Employees
    ├── notifications/ # Notifications
    └── settings/      # Settings
```

## Environment Variables

The app supports the following environment variables (`.env` file):

```env
# API Configuration
API_BASE_URL=https://api.example.com
API_TIMEOUT=30000
API_VERSION=v1

# Firebase (for push notifications)
FIREBASE_API_KEY=your_key
FIREBASE_APP_ID=your_app_id
FIREBASE_MESSAGING_SENDER_ID=your_sender_id
FIREBASE_PROJECT_ID=your_project_id

# Features
ENABLE_ANALYTICS=true
ENABLE_CRASHLYTICS=true
ENABLE_PERFORMANCE_MONITORING=true

# Debug
DEBUG_MODE=false
ENABLE_LOGGING=true
```

## Next Steps

After setup:

1. Explore the app features
2. Read the [API Documentation](docs/API.md)
3. Check the [State Machine Documentation](docs/STATE_MACHINE.md)
4. Review [Testing Guide](docs/TESTING.md)
5. See [Deployment Guide](docs/DEPLOYMENT.md)
6. Review [Contributing Guidelines](CONTRIBUTING.md)

## Support

For issues or questions:
- Create an issue on GitHub
- Check existing documentation in the `docs/` folder
- Review the code comments

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
