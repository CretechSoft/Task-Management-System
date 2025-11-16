import 'package:dartz/dartz.dart';
import '../../domain/entities/task.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/repositories.dart';
import '../../core/error/failures.dart';

/// Mock implementation of TaskRepository for demonstration
/// In production, this would connect to real API
class MockTaskRepository implements TaskRepository {
  // Sample data
  final List<Task> _tasks = [];

  MockTaskRepository() {
    _initializeSampleData();
  }

  void _initializeSampleData() {
    final now = DateTime.now();
    
    _tasks.addAll([
      Task(
        id: 'tsk-001',
        title: 'Implement authentication module',
        description: 'Create login, registration, and password reset functionality',
        projectId: 'prj-001',
        departmentId: 'dept-001',
        assigneeId: 'usr-001',
        createdBy: 'usr-002',
        priority: TaskPriority.high,
        status: TaskStatus.inProgress,
        progress: 65,
        tags: ['backend', 'security'],
        colorHex: '#FF9800',
        slaDueAt: now.add(const Duration(days: 3)),
        createdAt: now.subtract(const Duration(days: 2)),
        updatedAt: now,
      ),
      Task(
        id: 'tsk-002',
        title: 'Design user interface mockups',
        description: 'Create mockups for the dashboard and task screens',
        projectId: 'prj-001',
        departmentId: 'dept-002',
        assigneeId: 'usr-003',
        createdBy: 'usr-002',
        priority: TaskPriority.medium,
        status: TaskStatus.submittedForReview,
        progress: 100,
        tags: ['design', 'ui'],
        colorHex: '#9C27B0',
        slaDueAt: now.add(const Duration(days: 1)),
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now.subtract(const Duration(hours: 2)),
      ),
      Task(
        id: 'tsk-003',
        title: 'Write technical documentation',
        description: 'Document the API endpoints and data models',
        projectId: 'prj-002',
        departmentId: 'dept-001',
        assigneeId: 'usr-004',
        createdBy: 'usr-002',
        priority: TaskPriority.low,
        status: TaskStatus.assigned,
        progress: 0,
        tags: ['documentation'],
        colorHex: '#2196F3',
        slaDueAt: now.add(const Duration(days: 7)),
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
      Task(
        id: 'tsk-004',
        title: 'Fix critical bug in payment system',
        description: 'Users unable to complete checkout process',
        projectId: 'prj-001',
        departmentId: 'dept-001',
        assigneeId: 'usr-001',
        createdBy: 'usr-005',
        priority: TaskPriority.urgent,
        status: TaskStatus.inProgress,
        progress: 80,
        tags: ['bug', 'critical'],
        colorHex: '#F44336',
        slaDueAt: now.subtract(const Duration(hours: 2)), // Overdue
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(minutes: 30)),
      ),
      Task(
        id: 'tsk-005',
        title: 'Optimize database queries',
        description: 'Improve performance of slow queries',
        projectId: 'prj-002',
        departmentId: 'dept-001',
        assigneeId: 'usr-001',
        createdBy: 'usr-002',
        priority: TaskPriority.medium,
        status: TaskStatus.qaApproved,
        progress: 100,
        tags: ['performance', 'database'],
        colorHex: '#4CAF50',
        slaDueAt: now.subtract(const Duration(days: 2)),
        createdAt: now.subtract(const Duration(days: 10)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
    ]);
  }

  @override
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
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      var filteredTasks = List<Task>.from(_tasks);

      // Apply filters
      if (status != null) {
        filteredTasks = filteredTasks.where((t) => t.status == status).toList();
      }
      if (priority != null) {
        filteredTasks = filteredTasks.where((t) => t.priority == priority).toList();
      }
      if (assigneeId != null) {
        filteredTasks = filteredTasks.where((t) => t.assigneeId == assigneeId).toList();
      }
      if (projectId != null) {
        filteredTasks = filteredTasks.where((t) => t.projectId == projectId).toList();
      }
      if (search != null && search.isNotEmpty) {
        filteredTasks = filteredTasks.where((t) =>
          t.title.toLowerCase().contains(search.toLowerCase()) ||
          (t.description?.toLowerCase().contains(search.toLowerCase()) ?? false)
        ).toList();
      }

      return Right(filteredTasks);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Task>> getTask(String taskId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      final task = _tasks.firstWhere((t) => t.id == taskId);
      return Right(task);
    } catch (e) {
      return const Left(NotFoundFailure(message: 'Task not found'));
    }
  }

  @override
  Future<Either<Failure, Task>> createTask(Task task) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      _tasks.add(task);
      return Right(task);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Task>> updateTask(Task task) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = task;
        return Right(task);
      }
      return const Left(NotFoundFailure(message: 'Task not found'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTask(String taskId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      _tasks.removeWhere((t) => t.id == taskId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Task>> changeTaskStatus({
    required String taskId,
    required TaskStatus toStatus,
    String? note,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final index = _tasks.indexWhere((t) => t.id == taskId);
      if (index != -1) {
        final updatedTask = Task(
          id: _tasks[index].id,
          title: _tasks[index].title,
          description: _tasks[index].description,
          projectId: _tasks[index].projectId,
          departmentId: _tasks[index].departmentId,
          assigneeId: _tasks[index].assigneeId,
          createdBy: _tasks[index].createdBy,
          priority: _tasks[index].priority,
          status: toStatus,
          colorHex: _tasks[index].colorHex,
          slaDueAt: _tasks[index].slaDueAt,
          startAt: _tasks[index].startAt,
          endAt: _tasks[index].endAt,
          progress: _tasks[index].progress,
          tags: _tasks[index].tags,
          createdAt: _tasks[index].createdAt,
          updatedAt: DateTime.now(),
        );
        _tasks[index] = updatedTask;
        return Right(updatedTask);
      }
      return const Left(NotFoundFailure(message: 'Task not found'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Task>> updateTaskProgress({
    required String taskId,
    required int progress,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      final index = _tasks.indexWhere((t) => t.id == taskId);
      if (index != -1) {
        final updatedTask = Task(
          id: _tasks[index].id,
          title: _tasks[index].title,
          description: _tasks[index].description,
          projectId: _tasks[index].projectId,
          departmentId: _tasks[index].departmentId,
          assigneeId: _tasks[index].assigneeId,
          createdBy: _tasks[index].createdBy,
          priority: _tasks[index].priority,
          status: _tasks[index].status,
          colorHex: _tasks[index].colorHex,
          slaDueAt: _tasks[index].slaDueAt,
          startAt: _tasks[index].startAt,
          endAt: _tasks[index].endAt,
          progress: progress,
          tags: _tasks[index].tags,
          createdAt: _tasks[index].createdAt,
          updatedAt: DateTime.now(),
        );
        _tasks[index] = updatedTask;
        return Right(updatedTask);
      }
      return const Left(NotFoundFailure(message: 'Task not found'));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, TaskAttachment>> addAttachment({
    required String taskId,
    required String filePath,
    required AttachmentType type,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    try {
      final attachment = TaskAttachment(
        id: 'att-${DateTime.now().millisecondsSinceEpoch}',
        taskId: taskId,
        type: type,
        url: 'https://example.com/files/$filePath',
        name: filePath.split('/').last,
        size: 1024567,
        createdBy: 'usr-001',
        createdAt: DateTime.now(),
      );
      return Right(attachment);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TaskAttachment>>> getAttachments(String taskId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Return sample attachments
    return Right([
      TaskAttachment(
        id: 'att-001',
        taskId: taskId,
        type: AttachmentType.image,
        url: 'https://example.com/files/screenshot.png',
        name: 'screenshot.png',
        size: 1024567,
        createdBy: 'usr-001',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      TaskAttachment(
        id: 'att-002',
        taskId: taskId,
        type: AttachmentType.pdf,
        url: 'https://example.com/files/document.pdf',
        name: 'requirements.pdf',
        size: 2048567,
        createdBy: 'usr-001',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
    ]);
  }

  @override
  Future<Either<Failure, TaskComment>> addComment({
    required String taskId,
    required String text,
    List<String> mentions = const [],
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final comment = TaskComment(
        id: 'cmt-${DateTime.now().millisecondsSinceEpoch}',
        taskId: taskId,
        authorId: 'usr-001',
        text: text,
        mentions: mentions,
        createdAt: DateTime.now(),
      );
      return Right(comment);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TaskComment>>> getComments(String taskId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    return Right([
      TaskComment(
        id: 'cmt-001',
        taskId: taskId,
        authorId: 'usr-002',
        text: 'Great progress! Keep it up.',
        mentions: [],
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      TaskComment(
        id: 'cmt-002',
        taskId: taskId,
        authorId: 'usr-001',
        text: 'Thanks! Almost done.',
        mentions: [],
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
    ]);
  }

  @override
  Future<Either<Failure, List<dynamic>>> getTimeline(String taskId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    return Right([]);
  }

  @override
  Future<Either<Failure, List<TaskChecklist>>> getChecklist(String taskId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    return Right([
      const TaskChecklist(
        id: 'chk-001',
        taskId: taskId,
        text: 'Design database schema',
        isDone: true,
        order: 0,
      ),
      const TaskChecklist(
        id: 'chk-002',
        taskId: taskId,
        text: 'Implement user model',
        isDone: true,
        order: 1,
      ),
      const TaskChecklist(
        id: 'chk-003',
        taskId: taskId,
        text: 'Create authentication API',
        isDone: false,
        order: 2,
      ),
    ]);
  }

  @override
  Future<Either<Failure, TaskChecklist>> updateChecklistItem(TaskChecklist item) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Right(item);
  }
}
