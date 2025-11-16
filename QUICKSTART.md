# Task Management System - Quick Start Guide

## 🚀 Quick Setup (5 Minutes)

### Step 1: Prerequisites Check

Ensure you have:
- ✅ Flutter SDK 3.0+ installed
- ✅ Git installed
- ✅ Your favorite IDE (VS Code, Android Studio, or IntelliJ)

Verify Flutter installation:
```bash
flutter --version
flutter doctor
```

### Step 2: Clone and Setup

```bash
# Clone the repository
git clone https://github.com/CretechSoft/Task-Management-System.git
cd Task-Management-System

# Get dependencies
flutter pub get

# Generate code (for freezed models)
flutter pub run build_runner build --delete-conflicting-outputs
```

### Step 3: Run the App

```bash
# Run on your device/emulator
flutter run

# Or specify a device
flutter devices
flutter run -d <device-id>
```

That's it! The app should now be running.

## 📱 First Use

### Default Login (Demo Mode)
- Email: `test@example.com`
- Password: `password123`

**Note**: This is currently UI-only. Backend integration is pending.

## 🎨 What You'll See

1. **Login Screen**: Material 3 design with email/password fields
2. **Dashboard**: KPIs, quick actions, and recent tasks
3. **Tasks**: Browse, filter, and search tasks
4. **Task Details**: View complete task information
5. **Create Task**: Rich form with all features

## 🌍 Language Support

The app supports:
- 🇬🇧 English (default)
- 🇸🇦 Arabic with RTL support

Change language in Settings → Language

## 🎨 Theme

- Light mode (default)
- Dark mode
- High contrast support

Toggle in Settings → Dark Mode

## 🧪 Testing

### Run Tests
```bash
# All tests
flutter test

# With coverage
flutter test --coverage

# Specific test
flutter test test/unit/core/utils/app_utils_test.dart
```

### Code Quality
```bash
# Analyze code
flutter analyze

# Format code
flutter format lib test
```

## 📚 Project Structure Tour

```
lib/
├── core/              # Shared utilities and configuration
├── domain/            # Business entities (Task, User, etc.)
├── features/          # Feature modules
│   ├── auth/          # Login and authentication
│   ├── dashboard/     # Main dashboard
│   ├── tasks/         # Task management
│   └── ...
└── main.dart          # App entry point
```

## 🔧 Common Tasks

### Add a New Screen

1. Create screen file:
   ```dart
   // lib/features/my_feature/presentation/pages/my_page.dart
   class MyPage extends StatelessWidget {
     const MyPage({super.key});
     
     @override
     Widget build(BuildContext context) {
       return Scaffold(
         appBar: AppBar(title: Text('My Page')),
         body: Center(child: Text('Hello!')),
       );
     }
   }
   ```

2. Add route in `lib/core/router/app_router.dart`:
   ```dart
   GoRoute(
     path: '/my-page',
     name: 'my-page',
     builder: (context, state) => const MyPage(),
   ),
   ```

3. Navigate to it:
   ```dart
   context.push('/my-page');
   ```

### Add a New Localization String

Edit `lib/core/l10n/app_localizations.dart`:

```dart
// Add getter
String get myString => _localizedValues[locale.languageCode]!['my_string']!;

// Add to both languages
static const Map<String, Map<String, String>> _localizedValues = {
  'en': {
    'my_string': 'My English String',
  },
  'ar': {
    'my_string': 'النص بالعربية',
  },
};
```

### Customize Theme Colors

Edit `lib/core/theme/app_theme.dart`:

```dart
static const Color primaryColor = Color(0xFF6750A4); // Change this
```

## 🐛 Troubleshooting

### Issue: Build fails with freezed errors

**Solution**: Run code generation:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Issue: iOS build fails

**Solution**: 
1. Open `ios/Runner.xcworkspace` in Xcode
2. Update Bundle Identifier
3. Select Development Team
4. Run from Xcode first

### Issue: Android build fails

**Solution**: 
1. Check `android/app/build.gradle`
2. Ensure `minSdkVersion` is at least 21
3. Clean and rebuild:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

### Issue: Hot reload not working

**Solution**:
1. Stop the app
2. Run `flutter clean`
3. Run `flutter run` again

## 📖 Learn More

- [README.md](README.md) - Full project documentation
- [docs/API.md](docs/API.md) - Backend API specification
- [docs/TESTING.md](docs/TESTING.md) - Testing guide
- [CONTRIBUTING.md](CONTRIBUTING.md) - How to contribute

## 🆘 Getting Help

- 📝 Check [Issues](https://github.com/CretechSoft/Task-Management-System/issues)
- 💬 Start a [Discussion](https://github.com/CretechSoft/Task-Management-System/discussions)
- 📧 Email: support@cretechsoft.com

## ✨ What's Next?

Now that you have the app running, you can:

1. **Explore the UI**: Navigate through all screens
2. **Read the docs**: Understand the architecture
3. **Try customizing**: Change colors, add features
4. **Contribute**: Check CONTRIBUTING.md

## 🎯 Quick Development Tips

### Faster Development

Use hot reload:
- `r` - Hot reload
- `R` - Hot restart
- `p` - Show performance overlay
- `w` - Show widget inspector

### Debugging

Add breakpoints in your IDE and use:
- VS Code: F5 to start debugging
- Android Studio: Shift+F9

### Code Generation Watch Mode

Keep this running while developing:
```bash
flutter pub run build_runner watch
```

## 📱 Platform-Specific Setup

### Android
- Minimum SDK: 21 (Android 5.0)
- Target SDK: 34 (Android 14)
- Permissions configured in `AndroidManifest.xml`

### iOS
- Minimum: iOS 12.0
- Permissions in `Info.plist`
- Camera, Photo Library access configured

### Web
- Responsive design ready
- Works in Chrome, Firefox, Safari, Edge

Happy coding! 🚀
