# Testing Guide

## Overview

This guide provides instructions for testing the Task Management System application. The testing strategy includes unit tests, widget tests, integration tests, and manual testing scenarios.

## Test Structure

```
test/
├── unit/
│   ├── domain/
│   │   ├── entities/
│   │   └── usecases/
│   ├── data/
│   │   ├── models/
│   │   ├── datasources/
│   │   └── repositories/
│   └── core/
│       └── utils/
├── widget/
│   ├── auth/
│   ├── dashboard/
│   ├── tasks/
│   └── common/
└── integration/
    └── workflows/
```

## Unit Tests

### Testing Entities

```dart
// test/unit/domain/entities/task_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:task_management_system/domain/entities/task.dart';

void main() {
  group('Task Entity', () {
    test('should create a valid task', () {
      final task = Task(
        id: 'tsk-001',
        title: 'Test Task',
        projectId: 'prj-001',
        departmentId: 'dept-001',
        assigneeId: 'usr-001',
        createdBy: 'usr-002',
        priority: TaskPriority.high,
        status: TaskStatus.draft,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(task.id, 'tsk-001');
      expect(task.title, 'Test Task');
      expect(task.priority, TaskPriority.high);
      expect(task.status, TaskStatus.draft);
    });

    test('should handle optional fields', () {
      final task = Task(
        id: 'tsk-001',
        title: 'Test Task',
        projectId: 'prj-001',
        departmentId: 'dept-001',
        assigneeId: 'usr-001',
        createdBy: 'usr-002',
        priority: TaskPriority.low,
        status: TaskStatus.draft,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(task.description, isNull);
      expect(task.slaDueAt, isNull);
      expect(task.colorHex, isNull);
    });
  });
}
```

### Testing Utils

```dart
// test/unit/core/utils/date_time_utils_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:task_management_system/core/utils/app_utils.dart';

void main() {
  group('DateTimeUtils', () {
    test('should format date correctly', () {
      final date = DateTime(2024, 1, 15, 10, 30);
      final formatted = DateTimeUtils.formatDate(date);
      expect(formatted, 'Jan 15, 2024');
    });

    test('should detect today correctly', () {
      final today = DateTime.now();
      expect(DateTimeUtils.isToday(today), isTrue);
      
      final yesterday = today.subtract(const Duration(days: 1));
      expect(DateTimeUtils.isToday(yesterday), isFalse);
    });

    test('should calculate SLA status', () {
      final overdue = DateTime.now().subtract(const Duration(hours: 1));
      expect(
        DateTimeUtils.getSLAStatus(overdue),
        SLAStatus.overdue,
      );

      final critical = DateTime.now().add(const Duration(minutes: 30));
      expect(
        DateTimeUtils.getSLAStatus(critical),
        SLAStatus.critical,
      );

      final onTrack = DateTime.now().add(const Duration(days: 2));
      expect(
        DateTimeUtils.getSLAStatus(onTrack),
        SLAStatus.onTrack,
      );
    });
  });

  group('FileUtils', () {
    test('should format file size', () {
      expect(FileUtils.formatFileSize(500), '500 B');
      expect(FileUtils.formatFileSize(1536), '1.5 KB');
      expect(FileUtils.formatFileSize(1572864), '1.5 MB');
    });

    test('should detect file types', () {
      expect(FileUtils.isImage('photo.jpg'), isTrue);
      expect(FileUtils.isImage('document.pdf'), isFalse);
      expect(FileUtils.isDocument('file.pdf'), isTrue);
      expect(FileUtils.isVideo('movie.mp4'), isTrue);
    });
  });

  group('ValidationUtils', () {
    test('should validate email', () {
      expect(ValidationUtils.isValidEmail('test@example.com'), isTrue);
      expect(ValidationUtils.isValidEmail('invalid.email'), isFalse);
      expect(ValidationUtils.isValidEmail('test@'), isFalse);
    });

    test('should validate password strength', () {
      expect(ValidationUtils.isStrongPassword('weak'), isFalse);
      expect(ValidationUtils.isStrongPassword('StrongPass123'), isTrue);
      
      expect(ValidationUtils.getPasswordStrength('weak'), lessThan(3));
      expect(ValidationUtils.getPasswordStrength('StrongPass123!'), greaterThanOrEqualTo(4));
    });
  });
}
```

## Widget Tests

### Testing Login Page

```dart
// test/widget/auth/login_page_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_management_system/features/auth/presentation/pages/login_page.dart';

void main() {
  testWidgets('LoginPage displays all required fields', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LoginPage(),
      ),
    );

    // Verify email field exists
    expect(find.byType(TextFormField), findsNWidgets(2));
    
    // Verify login button exists
    expect(find.text('Login'), findsOneWidget);
    
    // Verify forgot password link exists
    expect(find.text('Forgot Password?'), findsOneWidget);
  });

  testWidgets('LoginPage validates empty email', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LoginPage(),
      ),
    );

    // Tap login without entering email
    await tester.tap(find.text('Login'));
    await tester.pump();

    // Should show validation error
    expect(find.text('Please enter your email'), findsOneWidget);
  });

  testWidgets('LoginPage validates invalid email', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LoginPage(),
      ),
    );

    // Enter invalid email
    await tester.enterText(
      find.byType(TextFormField).first,
      'invalid-email',
    );
    
    await tester.tap(find.text('Login'));
    await tester.pump();

    expect(find.text('Please enter a valid email'), findsOneWidget);
  });

  testWidgets('LoginPage toggles password visibility', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LoginPage(),
      ),
    );

    // Find password field
    final passwordField = find.byType(TextFormField).last;
    
    // Initially password should be obscured
    var textField = tester.widget<TextFormField>(passwordField);
    expect(textField.obscureText, isTrue);

    // Tap visibility toggle
    await tester.tap(find.byIcon(Icons.visibility_outlined));
    await tester.pump();

    // Password should now be visible
    textField = tester.widget<TextFormField>(passwordField);
    expect(textField.obscureText, isFalse);
  });
}
```

### Testing Task Card Widget

```dart
// test/widget/tasks/task_card_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('TaskCard displays task information', (tester) async {
    // Create test task
    final task = MockTask(
      title: 'Test Task',
      status: TaskStatus.inProgress,
      priority: TaskPriority.high,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TaskCard(task: task),
        ),
      ),
    );

    // Verify task title is displayed
    expect(find.text('Test Task'), findsOneWidget);
    
    // Verify status is displayed
    expect(find.text('In Progress'), findsOneWidget);
    
    // Verify priority is displayed
    expect(find.text('High'), findsOneWidget);
  });
}
```

## Integration Tests

### Testing Complete Task Workflow

```dart
// integration_test/task_workflow_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:task_management_system/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Complete task creation to approval workflow', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Step 1: Login
    await tester.enterText(
      find.byType(TextFormField).first,
      'test@example.com',
    );
    await tester.enterText(
      find.byType(TextFormField).last,
      'password123',
    );
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    // Step 2: Navigate to create task
    await tester.tap(find.text('Create Task'));
    await tester.pumpAndSettle();

    // Step 3: Fill task form
    await tester.enterText(
      find.byType(TextFormField).first,
      'Integration Test Task',
    );
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'This is a test task description',
    );

    // Select priority
    await tester.tap(find.byType(DropdownButtonFormField).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('High').last);
    await tester.pumpAndSettle();

    // Step 4: Save task
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // Verify task was created
    expect(find.text('Task created successfully'), findsOneWidget);

    // Step 5: Navigate to tasks list
    await tester.tap(find.text('Tasks'));
    await tester.pumpAndSettle();

    // Verify task appears in list
    expect(find.text('Integration Test Task'), findsOneWidget);
  });
}
```

## Manual Testing Checklist

### Authentication
- [ ] User can login with valid credentials
- [ ] User cannot login with invalid credentials
- [ ] Password visibility toggle works
- [ ] Forgot password link is accessible
- [ ] Logout functionality works

### Dashboard
- [ ] KPI cards display correct data
- [ ] Quick actions navigate to correct screens
- [ ] Recent tasks list is populated
- [ ] Navigation drawer opens and closes
- [ ] All menu items are accessible

### Tasks
- [ ] Task list displays all tasks
- [ ] Filters work correctly (status, priority)
- [ ] Search finds relevant tasks
- [ ] Task cards show correct information
- [ ] Pagination loads more tasks
- [ ] Pull to refresh works

### Task Details
- [ ] All tabs (Details, Attachments, Comments) work
- [ ] Task information is displayed correctly
- [ ] Status chips show correct colors
- [ ] Priority is displayed with correct icon
- [ ] Progress bar reflects actual progress
- [ ] Checklist items can be toggled
- [ ] Comments can be added
- [ ] Attachments are visible

### Task Creation
- [ ] All form fields are accessible
- [ ] Validation works for required fields
- [ ] Priority dropdown works
- [ ] Project/Department/Assignee selection works
- [ ] Due date picker works
- [ ] Checklist items can be added/removed
- [ ] Attachments can be added
- [ ] Task is created successfully

### Notifications
- [ ] Notifications list displays all notifications
- [ ] Unread filter works
- [ ] Mark as read functionality works
- [ ] Notification types are displayed correctly
- [ ] Tapping notification navigates to relevant screen

### Settings
- [ ] Language can be changed
- [ ] Dark mode toggle works
- [ ] Notification preferences can be updated
- [ ] Logout confirmation dialog appears
- [ ] Settings persist after app restart

## Performance Testing

### Load Testing
- [ ] App handles 1000+ tasks without lag
- [ ] Infinite scroll performs smoothly
- [ ] Image loading doesn't block UI
- [ ] Search is responsive with large datasets

### Memory Testing
- [ ] No memory leaks when navigating between screens
- [ ] Images are cached properly
- [ ] Old data is cleared from memory

### Network Testing
- [ ] App handles slow network gracefully
- [ ] Offline mode works
- [ ] Data syncs when connection restored
- [ ] Loading states are shown during requests

## Accessibility Testing

- [ ] All interactive elements have semantic labels
- [ ] Screen reader can navigate all screens
- [ ] Color contrast meets WCAG AA standards
- [ ] Text is readable at different font sizes
- [ ] Touch targets are at least 48x48dp

## Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/unit/core/utils/app_utils_test.dart

# Run with coverage
flutter test --coverage

# Run integration tests
flutter test integration_test/task_workflow_test.dart

# Generate coverage report
genhtml coverage/lcov.info -o coverage/html
```

## CI/CD Integration

Add to `.github/workflows/test.yml`:

```yaml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
      - run: flutter pub get
      - run: flutter test --coverage
      - run: flutter analyze
```
