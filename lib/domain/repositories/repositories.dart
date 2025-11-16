import 'package:dartz/dartz.dart';
import '../entities/task.dart';
import '../entities/user.dart';
import '../../core/error/failures.dart';

abstract class TaskRepository {
  /// Get all tasks with optional filters
  Future<Either<Failure, List<Task>>> getTasks({
    TaskStatus? status,
    TaskPriority? priority,
    String? assigneeId,
    String? projectId,
    String? departmentId,
    String? search,
    DateTime? dueFrom,
    DateTime? dueTo,
    int page = 1,
    int size = 20,
  });

  /// Get a single task by ID
  Future<Either<Failure, Task>> getTask(String taskId);

  /// Create a new task
  Future<Either<Failure, Task>> createTask(Task task);

  /// Update an existing task
  Future<Either<Failure, Task>> updateTask(Task task);

  /// Delete a task
  Future<Either<Failure, void>> deleteTask(String taskId);

  /// Change task status
  Future<Either<Failure, Task>> changeTaskStatus({
    required String taskId,
    required TaskStatus toStatus,
    String? note,
  });

  /// Update task progress
  Future<Either<Failure, Task>> updateTaskProgress({
    required String taskId,
    required int progress,
  });

  /// Add attachment to task
  Future<Either<Failure, TaskAttachment>> addAttachment({
    required String taskId,
    required String filePath,
    required AttachmentType type,
  });

  /// Get task attachments
  Future<Either<Failure, List<TaskAttachment>>> getAttachments(String taskId);

  /// Add comment to task
  Future<Either<Failure, TaskComment>> addComment({
    required String taskId,
    required String text,
    List<String> mentions = const [],
  });

  /// Get task comments
  Future<Either<Failure, List<TaskComment>>> getComments(String taskId);

  /// Get task timeline (audit trail + comments)
  Future<Either<Failure, List<dynamic>>> getTimeline(String taskId);

  /// Get task checklist items
  Future<Either<Failure, List<TaskChecklist>>> getChecklist(String taskId);

  /// Update checklist item
  Future<Either<Failure, TaskChecklist>> updateChecklistItem(TaskChecklist item);
}

abstract class AuthRepository {
  /// Login user
  Future<Either<Failure, AuthResponse>> login({
    required String email,
    required String password,
  });

  /// Register new user
  Future<Either<Failure, AuthResponse>> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  });

  /// Logout current user
  Future<Either<Failure, void>> logout();

  /// Get current user
  Future<Either<Failure, User>> getCurrentUser();

  /// Check if user is logged in
  Future<bool> isLoggedIn();

  /// Forgot password
  Future<Either<Failure, void>> forgotPassword(String email);
}

abstract class ProjectRepository {
  /// Get all projects
  Future<Either<Failure, List<dynamic>>> getProjects({bool? isActive});

  /// Get project by ID
  Future<Either<Failure, dynamic>> getProject(String projectId);
}

abstract class DepartmentRepository {
  /// Get all departments
  Future<Either<Failure, List<dynamic>>> getDepartments();

  /// Get department by ID
  Future<Either<Failure, dynamic>> getDepartment(String departmentId);
}

abstract class UserRepository {
  /// Get all users
  Future<Either<Failure, List<User>>> getUsers({
    String? departmentId,
    UserRole? role,
  });

  /// Get user by ID
  Future<Either<Failure, User>> getUser(String userId);
}
