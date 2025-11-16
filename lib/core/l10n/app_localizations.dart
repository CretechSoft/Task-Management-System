import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en', ''),
    Locale('ar', ''),
  ];

  // Common
  String get appName => _localizedValues[locale.languageCode]!['app_name']!;
  String get ok => _localizedValues[locale.languageCode]!['ok']!;
  String get cancel => _localizedValues[locale.languageCode]!['cancel']!;
  String get save => _localizedValues[locale.languageCode]!['save']!;
  String get delete => _localizedValues[locale.languageCode]!['delete']!;
  String get edit => _localizedValues[locale.languageCode]!['edit']!;
  String get search => _localizedValues[locale.languageCode]!['search']!;
  String get filter => _localizedValues[locale.languageCode]!['filter']!;
  String get loading => _localizedValues[locale.languageCode]!['loading']!;
  String get error => _localizedValues[locale.languageCode]!['error']!;
  String get retry => _localizedValues[locale.languageCode]!['retry']!;
  
  // Auth
  String get login => _localizedValues[locale.languageCode]!['login']!;
  String get logout => _localizedValues[locale.languageCode]!['logout']!;
  String get email => _localizedValues[locale.languageCode]!['email']!;
  String get password => _localizedValues[locale.languageCode]!['password']!;
  String get forgotPassword => _localizedValues[locale.languageCode]!['forgot_password']!;
  
  // Dashboard
  String get dashboard => _localizedValues[locale.languageCode]!['dashboard']!;
  String get todayTasks => _localizedValues[locale.languageCode]!['today_tasks']!;
  String get overdueTasks => _localizedValues[locale.languageCode]!['overdue_tasks']!;
  
  // Tasks
  String get tasks => _localizedValues[locale.languageCode]!['tasks']!;
  String get createTask => _localizedValues[locale.languageCode]!['create_task']!;
  String get taskTitle => _localizedValues[locale.languageCode]!['task_title']!;
  String get taskDescription => _localizedValues[locale.languageCode]!['task_description']!;
  String get assignee => _localizedValues[locale.languageCode]!['assignee']!;
  String get priority => _localizedValues[locale.languageCode]!['priority']!;
  String get status => _localizedValues[locale.languageCode]!['status']!;
  String get dueDate => _localizedValues[locale.languageCode]!['due_date']!;
  String get attachments => _localizedValues[locale.languageCode]!['attachments']!;
  String get comments => _localizedValues[locale.languageCode]!['comments']!;
  
  // Status
  String get draft => _localizedValues[locale.languageCode]!['draft']!;
  String get assigned => _localizedValues[locale.languageCode]!['assigned']!;
  String get inProgress => _localizedValues[locale.languageCode]!['in_progress']!;
  String get submittedForReview => _localizedValues[locale.languageCode]!['submitted_for_review']!;
  String get qaApproved => _localizedValues[locale.languageCode]!['qa_approved']!;
  String get qaRejected => _localizedValues[locale.languageCode]!['qa_rejected']!;
  
  // Priority
  String get low => _localizedValues[locale.languageCode]!['low']!;
  String get medium => _localizedValues[locale.languageCode]!['medium']!;
  String get high => _localizedValues[locale.languageCode]!['high']!;
  String get urgent => _localizedValues[locale.languageCode]!['urgent']!;
  
  // Projects & Departments
  String get projects => _localizedValues[locale.languageCode]!['projects']!;
  String get departments => _localizedValues[locale.languageCode]!['departments']!;
  String get employees => _localizedValues[locale.languageCode]!['employees']!;
  
  // Notifications
  String get notifications => _localizedValues[locale.languageCode]!['notifications']!;
  String get settings => _localizedValues[locale.languageCode]!['settings']!;

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_name': 'Task Management System',
      'ok': 'OK',
      'cancel': 'Cancel',
      'save': 'Save',
      'delete': 'Delete',
      'edit': 'Edit',
      'search': 'Search',
      'filter': 'Filter',
      'loading': 'Loading...',
      'error': 'Error',
      'retry': 'Retry',
      
      'login': 'Login',
      'logout': 'Logout',
      'email': 'Email',
      'password': 'Password',
      'forgot_password': 'Forgot Password?',
      
      'dashboard': 'Dashboard',
      'today_tasks': 'Today\'s Tasks',
      'overdue_tasks': 'Overdue Tasks',
      
      'tasks': 'Tasks',
      'create_task': 'Create Task',
      'task_title': 'Task Title',
      'task_description': 'Task Description',
      'assignee': 'Assignee',
      'priority': 'Priority',
      'status': 'Status',
      'due_date': 'Due Date',
      'attachments': 'Attachments',
      'comments': 'Comments',
      
      'draft': 'Draft',
      'assigned': 'Assigned',
      'in_progress': 'In Progress',
      'submitted_for_review': 'Submitted for Review',
      'qa_approved': 'QA Approved',
      'qa_rejected': 'QA Rejected',
      
      'low': 'Low',
      'medium': 'Medium',
      'high': 'High',
      'urgent': 'Urgent',
      
      'projects': 'Projects',
      'departments': 'Departments',
      'employees': 'Employees',
      
      'notifications': 'Notifications',
      'settings': 'Settings',
    },
    'ar': {
      'app_name': 'نظام إدارة المهام',
      'ok': 'موافق',
      'cancel': 'إلغاء',
      'save': 'حفظ',
      'delete': 'حذف',
      'edit': 'تعديل',
      'search': 'بحث',
      'filter': 'تصفية',
      'loading': 'جاري التحميل...',
      'error': 'خطأ',
      'retry': 'إعادة المحاولة',
      
      'login': 'تسجيل الدخول',
      'logout': 'تسجيل الخروج',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'forgot_password': 'نسيت كلمة المرور؟',
      
      'dashboard': 'لوحة التحكم',
      'today_tasks': 'مهام اليوم',
      'overdue_tasks': 'المهام المتأخرة',
      
      'tasks': 'المهام',
      'create_task': 'إنشاء مهمة',
      'task_title': 'عنوان المهمة',
      'task_description': 'وصف المهمة',
      'assignee': 'المسؤول',
      'priority': 'الأولوية',
      'status': 'الحالة',
      'due_date': 'تاريخ الاستحقاق',
      'attachments': 'المرفقات',
      'comments': 'التعليقات',
      
      'draft': 'مسودة',
      'assigned': 'مسند',
      'in_progress': 'قيد التنفيذ',
      'submitted_for_review': 'مرسل للمراجعة',
      'qa_approved': 'معتمد من الجودة',
      'qa_rejected': 'مرفوض من الجودة',
      
      'low': 'منخفض',
      'medium': 'متوسط',
      'high': 'عالي',
      'urgent': 'عاجل',
      
      'projects': 'المشاريع',
      'departments': 'الأقسام',
      'employees': 'الموظفون',
      
      'notifications': 'الإشعارات',
      'settings': 'الإعدادات',
    },
  };
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
