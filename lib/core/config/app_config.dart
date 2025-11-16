class AppConfig {
  static const String appName = 'Task Management System';
  static const String appVersion = '1.0.0';
  
  // API Configuration
  static const String baseUrl = 'https://api.taskmanagement.com';
  static const String apiVersion = 'v1';
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
  
  // Cache Configuration
  static const String dbName = 'task_management.db';
  static const int dbVersion = 1;
  static const int cacheExpiration = 3600; // 1 hour in seconds
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // File Upload
  static const int maxFileSize = 50 * 1024 * 1024; // 50MB
  static const int maxFilesPerTask = 10;
  static const List<String> allowedFileTypes = [
    'jpg', 'jpeg', 'png', 'gif',
    'pdf', 'doc', 'docx',
    'mp4', 'mov', 'avi',
  ];
  
  // SLA Configuration (in hours)
  static const int slaWarning24Hours = 24;
  static const int slaWarning4Hours = 4;
  static const int slaWarning1Hour = 1;
  
  // Sync Configuration
  static const int syncInterval = 300; // 5 minutes
  static const int maxRetryAttempts = 3;
}
