# Task Management System

Enterprise task management system built with Flutter that assigns tasks to employees by project and department, supports file attachments, statuses, colors, deadlines, reminders, approvals, and quality review. The workflow covers assignment → execution with evidence upload → QA acceptance or rejection, with full audit trail and performance metrics.

## Features

### Core Functionality
- ✅ **Multi-Role Support**: Admin, Team Lead, Employee, and QA roles with appropriate permissions
- ✅ **Task Lifecycle Management**: Complete state machine from Draft → Assigned → In Progress → Submitted → Approved/Rejected
- ✅ **Rich Task Details**: Title, description, priority, status, progress tracking, and tags
- ✅ **Project & Department Organization**: Tasks organized by projects and departments
- ✅ **File Attachments**: Support for images, PDFs, videos, documents, and links
- ✅ **Comments & Mentions**: Collaborative commenting with user mentions
- ✅ **Audit Trail**: Complete history of task status changes
- ✅ **SLA Management**: Deadlines with reminders and escalation
- ✅ **Checklist Support**: Break down tasks into subtasks

### User Interface
- ✅ **Material 3 Design**: Modern UI with Material Design 3
- ✅ **RTL/LTR Support**: Full bidirectional text support
- ✅ **Internationalization**: English and Arabic languages
- ✅ **Dark Mode**: Light and dark theme support
- ✅ **Responsive Design**: Optimized for various screen sizes
- ✅ **Accessibility**: WCAG-AA compliant with high contrast support

### Navigation & Screens
- ✅ **Authentication**: Login, registration, password reset
- ✅ **Dashboard**: KPIs, quick actions, and recent tasks
- ✅ **Task List**: Filtering, searching, and sorting
- ✅ **Task Details**: Complete task information with tabs
- ✅ **Create/Edit Task**: Rich form with all task properties
- ✅ **Projects Management**: Browse and manage projects
- ✅ **Departments**: Department listing and management
- ✅ **Employees**: User directory with role information
- ✅ **Notifications**: Centralized notification center
- ✅ **Settings**: Preferences and configurations

### Technical Features
- ✅ **Clean Architecture**: Separation of concerns with domain, data, and presentation layers
- ✅ **State Management**: Ready for BLoC/Riverpod integration
- ✅ **Routing**: GoRouter for declarative navigation
- ✅ **API Integration**: Dio setup with interceptors
- ✅ **Local Storage**: Drift for offline-first capability
- ✅ **File Handling**: Support for file picking and viewing
- ✅ **Notifications**: FCM and local notifications setup

## Architecture

The project follows Clean Architecture principles:

```
lib/
├── core/                      # Core utilities and configuration
│   ├── config/               # App configuration
│   ├── theme/                # Material 3 theme
│   ├── l10n/                 # Internationalization
│   ├── router/               # Navigation setup
│   └── di/                   # Dependency injection
├── domain/                    # Business logic layer
│   ├── entities/             # Domain models (Task, User, Project)
│   ├── repositories/         # Repository interfaces
│   └── usecases/             # Business use cases
├── data/                      # Data layer
│   ├── models/               # DTOs and data models
│   ├── datasources/          # Remote and local data sources
│   └── repositories/         # Repository implementations
└── features/                  # Feature modules
    ├── auth/                 # Authentication
    ├── dashboard/            # Dashboard screen
    ├── tasks/                # Task management
    ├── projects/             # Projects management
    ├── departments/          # Departments management
    ├── employees/            # Employee directory
    ├── notifications/        # Notifications center
    └── settings/             # App settings
```

## Domain Model

### Task Status Flow
```
Draft → Assigned → In Progress → Submitted for Review → QA Approved / QA Rejected
```

### Core Entities

**Task**
- id, title, description
- projectId, departmentId, assigneeId, createdBy
- priority (Low, Medium, High, Urgent)
- status (Draft, Assigned, InProgress, SubmittedForReview, QAApproved, QARejected)
- progress (0-100)
- slaDueAt, startAt, endAt
- tags, colorHex

**User**
- id, name, email, phone
- role (Admin, TeamLead, Employee, QA)
- departmentId, avatarUrl, isActive

**Project & Department**
- id, name, code, description, isActive

**TaskAttachment**
- id, taskId, type (image, pdf, video, doc, link)
- url, name, size, createdBy, createdAt

**TaskComment**
- id, taskId, authorId, text, mentions[], createdAt

**TaskAudit**
- id, taskId, fromStatus, toStatus, byUserId, note, at

## Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK
- IDE (VS Code, Android Studio, or IntelliJ IDEA)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/CretechSoft/Task-Management-System.git
cd Task-Management-System
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate code (freezed, json_serializable):
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Run the app:
```bash
flutter run
```

### Development

**Run with hot reload:**
```bash
flutter run
```

**Generate code:**
```bash
# Watch mode
flutter pub run build_runner watch

# One-time generation
flutter pub run build_runner build --delete-conflicting-outputs
```

**Run tests:**
```bash
flutter test
```

**Analyze code:**
```bash
flutter analyze
```

## Configuration

### API Configuration
Edit `lib/core/config/app_config.dart` to configure API endpoints:
```dart
static const String baseUrl = 'https://api.taskmanagement.com';
```

### Localization
Add translations in `lib/core/l10n/app_localizations.dart` for both English and Arabic.

### Theme Customization
Modify theme in `lib/core/theme/app_theme.dart` to customize colors and styles.

## Permissions & Roles

### Admin
- Full system access
- Configure departments, projects, and users
- Assign permissions

### Team Lead
- Create and assign tasks
- View team performance
- Initial approval of completed tasks

### Employee/Assignee
- View assigned tasks
- Update task progress
- Upload evidence/attachments
- Submit tasks for review

### QA
- Review submitted tasks
- Approve or reject tasks
- Provide feedback

## API Integration

The app is ready to connect to a REST API with the following endpoints:

**Authentication**
- `POST /auth/login` - User login
- `POST /auth/register` - User registration
- `POST /auth/forgot-password` - Password reset

**Tasks**
- `GET /tasks` - List tasks with filters
- `POST /tasks` - Create task
- `GET /tasks/:id` - Get task details
- `PUT /tasks/:id` - Update task
- `PATCH /tasks/:id/status` - Change task status
- `POST /tasks/:id/attachments` - Upload attachments
- `POST /tasks/:id/comments` - Add comment

**Projects & Departments**
- `GET /projects` - List projects
- `GET /departments` - List departments
- `GET /users` - List users

## Offline Support

The app is designed for offline-first operation:
- Tasks and data cached locally using Drift
- Sync queue for pending operations
- Automatic sync when connection is restored
- Conflict resolution strategies

## Notifications

**Push Notifications (FCM)**
- Task assignments
- Status changes
- Mentions in comments
- SLA warnings

**Local Notifications**
- SLA reminders (24h, 4h, 1h before due)
- Overdue task alerts

## Testing

The project includes comprehensive testing:

**Unit Tests**
- Use cases and business logic
- Data mappers and transformations

**Widget Tests**
- UI components and screens
- User interactions

**Integration Tests**
- Complete user workflows
- End-to-end task lifecycle

## Performance Considerations

- Efficient list rendering with pagination
- Image caching and optimization
- Lazy loading of task details
- Optimized database queries with indexes
- Background sync operations

## Accessibility

- High contrast mode support
- Screen reader compatibility
- Scalable text sizes
- Semantic labels for all interactive elements
- Keyboard navigation support

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests and linters
5. Submit a pull request

## License

This project is proprietary software owned by CretechSoft.

## Support

For issues, questions, or feature requests, please contact the development team.
