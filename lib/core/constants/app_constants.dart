class AppConstants {
  // Status Colors (matching AppTheme)
  static const Map<String, String> statusColors = {
    'draft': '#9E9E9E',
    'assigned': '#2196F3',
    'in_progress': '#FF9800',
    'submitted_for_review': '#9C27B0',
    'qa_approved': '#4CAF50',
    'qa_rejected': '#F44336',
  };

  // Priority Colors (matching AppTheme)
  static const Map<String, String> priorityColors = {
    'low': '#8BC34A',
    'medium': '#FFC107',
    'high': '#FF5722',
    'urgent': '#D32F2F',
  };

  // Notification Types
  static const String notificationTypeAssignment = 'assignment';
  static const String notificationTypeStatusChange = 'status_change';
  static const String notificationTypeMention = 'mention';
  static const String notificationTypeSLAWarning = 'sla_warning';
  static const String notificationTypeSLAOverdue = 'sla_overdue';
  static const String notificationTypeQAResult = 'qa_result';

  // Notification Channels
  static const String channelPush = 'push';
  static const String channelEmail = 'email';
  static const String channelSMS = 'sms';

  // Attachment Types
  static const List<String> imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
  static const List<String> documentExtensions = ['pdf', 'doc', 'docx', 'txt'];
  static const List<String> videoExtensions = ['mp4', 'mov', 'avi', 'mkv'];

  // File Size Limits
  static const int maxImageSize = 10 * 1024 * 1024; // 10MB
  static const int maxDocumentSize = 20 * 1024 * 1024; // 20MB
  static const int maxVideoSize = 50 * 1024 * 1024; // 50MB

  // Shared Preferences Keys
  static const String keyAuthToken = 'auth_token';
  static const String keyUserId = 'user_id';
  static const String keyUserRole = 'user_role';
  static const String keyLanguage = 'language';
  static const String keyThemeMode = 'theme_mode';
  static const String keyNotificationsEnabled = 'notifications_enabled';
  static const String keyLastSyncTime = 'last_sync_time';

  // Validation
  static const int minPasswordLength = 6;
  static const int maxTaskTitleLength = 200;
  static const int maxTaskDescriptionLength = 5000;
  static const int maxCommentLength = 1000;

  // Pagination
  static const int defaultPageSize = 20;
  static const int tasksPageSize = 20;
  static const int commentsPageSize = 50;
  static const int notificationsPageSize = 30;

  // Refresh Intervals (in seconds)
  static const int tasksRefreshInterval = 300; // 5 minutes
  static const int notificationsRefreshInterval = 60; // 1 minute
  static const int dashboardRefreshInterval = 180; // 3 minutes

  // Animation Durations (in milliseconds)
  static const int defaultAnimationDuration = 300;
  static const int fastAnimationDuration = 150;
  static const int slowAnimationDuration = 500;

  // Debounce Delays (in milliseconds)
  static const int searchDebounceDelay = 500;
  static const int filterDebounceDelay = 300;

  // Regex Patterns
  static final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  static final RegExp phoneRegex = RegExp(
    r'^\+?[1-9]\d{1,14}$',
  );

  // Date Formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
  static const String timeFormat = 'HH:mm';
  static const String displayDateFormat = 'MMM dd, yyyy';
  static const String displayDateTimeFormat = 'MMM dd, yyyy HH:mm';

  // Error Messages
  static const String errorGeneric = 'An error occurred. Please try again.';
  static const String errorNetwork = 'Network error. Please check your connection.';
  static const String errorUnauthorized = 'Unauthorized. Please login again.';
  static const String errorNotFound = 'Resource not found.';
  static const String errorValidation = 'Please check your input.';
  static const String errorServerError = 'Server error. Please try again later.';

  // Success Messages
  static const String successTaskCreated = 'Task created successfully';
  static const String successTaskUpdated = 'Task updated successfully';
  static const String successTaskDeleted = 'Task deleted successfully';
  static const String successCommentAdded = 'Comment added successfully';
  static const String successFileUploaded = 'File uploaded successfully';
  static const String successStatusChanged = 'Status changed successfully';
}
