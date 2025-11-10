# Contributing to Task Management System

Thank you for your interest in contributing to the Task Management System! This document provides guidelines and instructions for contributing.

## Code of Conduct

- Be respectful and inclusive
- Welcome newcomers
- Accept constructive criticism gracefully
- Focus on what is best for the community
- Show empathy towards other contributors

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Git
- IDE (VS Code, Android Studio, or IntelliJ IDEA)
- Basic knowledge of Dart and Flutter

### Setting Up Development Environment

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/YOUR_USERNAME/Task-Management-System.git
   cd Task-Management-System
   ```
3. Add upstream remote:
   ```bash
   git remote add upstream https://github.com/CretechSoft/Task-Management-System.git
   ```
4. Install dependencies:
   ```bash
   flutter pub get
   ```
5. Run code generation:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

## Development Workflow

### 1. Create a Branch

Always create a new branch for your work:

```bash
git checkout -b feature/your-feature-name
```

Branch naming conventions:
- `feature/` - New features
- `fix/` - Bug fixes
- `docs/` - Documentation updates
- `refactor/` - Code refactoring
- `test/` - Adding or updating tests

### 2. Make Changes

- Write clean, readable code
- Follow the existing code style
- Add comments for complex logic
- Update documentation as needed

### 3. Test Your Changes

```bash
# Run tests
flutter test

# Run analyzer
flutter analyze

# Check formatting
flutter format lib test
```

### 4. Commit Your Changes

Follow conventional commit format:

```
<type>(<scope>): <subject>

<body>

<footer>
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

Example:
```bash
git commit -m "feat(tasks): add task priority filtering

Added ability to filter tasks by priority level.
Includes UI updates and tests.

Closes #123"
```

### 5. Push and Create Pull Request

```bash
git push origin feature/your-feature-name
```

Then create a Pull Request on GitHub.

## Code Style Guide

### Dart/Flutter Conventions

1. **Follow official Dart style guide**: https://dart.dev/guides/language/effective-dart/style

2. **Use meaningful names**:
   ```dart
   // Good
   final userName = user.name;
   final isTaskCompleted = task.status == TaskStatus.completed;
   
   // Bad
   final n = user.name;
   final b = task.status == TaskStatus.completed;
   ```

3. **Prefer const constructors**:
   ```dart
   const SizedBox(height: 16)  // Good
   SizedBox(height: 16)         // Avoid if possible
   ```

4. **Use trailing commas**:
   ```dart
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         title: Text('Title'),
       ),
       body: Container(
         child: Text('Body'),
       ),
     );
   }
   ```

5. **Organize imports**:
   ```dart
   // Dart imports
   import 'dart:async';
   
   // Flutter imports
   import 'package:flutter/material.dart';
   
   // Package imports
   import 'package:freezed_annotation/freezed_annotation.dart';
   
   // Local imports
   import '../core/theme/app_theme.dart';
   ```

### File Organization

```
lib/
├── core/                 # Core functionality
├── data/                 # Data layer
├── domain/               # Business logic
└── features/             # Feature modules
    └── feature_name/
        ├── data/
        ├── domain/
        └── presentation/
            ├── bloc/
            ├── pages/
            └── widgets/
```

### Widget Structure

```dart
class MyWidget extends StatelessWidget {
  // 1. Fields
  final String title;
  final VoidCallback? onTap;
  
  // 2. Constructor
  const MyWidget({
    super.key,
    required this.title,
    this.onTap,
  });
  
  // 3. Build method
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(title),
    );
  }
  
  // 4. Private methods
  void _handleTap() {
    onTap?.call();
  }
}
```

## Testing Guidelines

### Unit Tests

- Test business logic and utilities
- Mock external dependencies
- Aim for >80% code coverage

```dart
test('should return formatted date', () {
  final date = DateTime(2024, 1, 15);
  final result = DateTimeUtils.formatDate(date);
  expect(result, 'Jan 15, 2024');
});
```

### Widget Tests

- Test UI components
- Verify user interactions
- Check widget tree structure

```dart
testWidgets('displays task title', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: TaskCard(task: mockTask),
    ),
  );
  
  expect(find.text('Test Task'), findsOneWidget);
});
```

### Integration Tests

- Test complete user workflows
- Verify end-to-end functionality

## Documentation

### Code Documentation

Add documentation comments for public APIs:

```dart
/// Formats a [DateTime] to a human-readable string.
///
/// If [format] is provided, uses that format pattern.
/// Otherwise, uses the default format 'MMM dd, yyyy'.
///
/// Example:
/// ```dart
/// formatDate(DateTime(2024, 1, 15)) // Returns "Jan 15, 2024"
/// ```
String formatDate(DateTime date, {String? format}) {
  // implementation
}
```

### README Updates

When adding new features, update the README.md with:
- Feature description
- Usage examples
- Configuration instructions

### API Documentation

When adding or modifying API endpoints, update `docs/API.md`.

## Pull Request Process

1. **Title**: Clear and descriptive
   - ✅ "Add task filtering by priority"
   - ❌ "Update tasks"

2. **Description**: Include:
   - What changed and why
   - How to test the changes
   - Screenshots (for UI changes)
   - Related issues

3. **Checklist**:
   - [ ] Tests added/updated
   - [ ] Documentation updated
   - [ ] Code follows style guidelines
   - [ ] No linter warnings
   - [ ] Commits follow conventional format

4. **Review**: Address reviewer feedback promptly

5. **Merge**: Wait for approval from maintainers

## Reporting Bugs

### Before Reporting

1. Check existing issues
2. Verify it's reproducible
3. Test on latest version

### Bug Report Template

```markdown
**Describe the bug**
A clear description of the bug.

**To Reproduce**
Steps to reproduce:
1. Go to '...'
2. Click on '...'
3. See error

**Expected behavior**
What you expected to happen.

**Screenshots**
If applicable, add screenshots.

**Environment:**
 - Device: [e.g. iPhone 12, Pixel 5]
 - OS: [e.g. iOS 15, Android 12]
 - App Version: [e.g. 1.0.0]

**Additional context**
Any other relevant information.
```

## Requesting Features

### Feature Request Template

```markdown
**Is your feature request related to a problem?**
Describe the problem.

**Describe the solution you'd like**
Clear description of the desired solution.

**Describe alternatives you've considered**
Any alternative solutions or features.

**Additional context**
Mockups, examples, or other context.
```

## Review Process

### For Reviewers

- Review within 2-3 business days
- Provide constructive feedback
- Test the changes locally
- Check for:
  - Code quality
  - Test coverage
  - Documentation
  - Performance implications

### For Contributors

- Be receptive to feedback
- Make requested changes promptly
- Ask questions if unclear
- Keep PR scope focused

## Release Process

1. Version bump in `pubspec.yaml`
2. Update CHANGELOG.md
3. Create release branch
4. Final testing
5. Create GitHub release
6. Deploy to stores

## Getting Help

- 📖 Read the documentation in `/docs`
- 💬 Ask questions in GitHub Discussions
- 🐛 Report bugs in GitHub Issues
- 📧 Email: support@cretechsoft.com

## Recognition

Contributors will be recognized in:
- CONTRIBUTORS.md
- Release notes
- About page in the app

Thank you for contributing! 🎉
