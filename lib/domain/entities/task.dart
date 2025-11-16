import 'package:freezed_annotation/freezed_annotation.dart';

part 'task.freezed.dart';
part 'task.g.dart';

enum TaskStatus {
  @JsonValue('draft')
  draft,
  @JsonValue('assigned')
  assigned,
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('submitted_for_review')
  submittedForReview,
  @JsonValue('qa_approved')
  qaApproved,
  @JsonValue('qa_rejected')
  qaRejected,
}

enum TaskPriority {
  @JsonValue('low')
  low,
  @JsonValue('medium')
  medium,
  @JsonValue('high')
  high,
  @JsonValue('urgent')
  urgent,
}

@freezed
class Task with _$Task {
  const factory Task({
    required String id,
    required String title,
    String? description,
    required String projectId,
    required String departmentId,
    required String assigneeId,
    required String createdBy,
    required TaskPriority priority,
    required TaskStatus status,
    String? colorHex,
    DateTime? slaDueAt,
    DateTime? startAt,
    DateTime? endAt,
    @Default(0) int progress,
    @Default([]) List<String> tags,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}

@freezed
class TaskChecklist with _$TaskChecklist {
  const factory TaskChecklist({
    required String id,
    required String taskId,
    required String text,
    @Default(false) bool isDone,
    @Default(0) int order,
  }) = _TaskChecklist;

  factory TaskChecklist.fromJson(Map<String, dynamic> json) => 
      _$TaskChecklistFromJson(json);
}

enum AttachmentType {
  @JsonValue('image')
  image,
  @JsonValue('pdf')
  pdf,
  @JsonValue('video')
  video,
  @JsonValue('doc')
  doc,
  @JsonValue('link')
  link,
}

@freezed
class TaskAttachment with _$TaskAttachment {
  const factory TaskAttachment({
    required String id,
    required String taskId,
    required AttachmentType type,
    required String url,
    required String name,
    int? size,
    required String createdBy,
    required DateTime createdAt,
  }) = _TaskAttachment;

  factory TaskAttachment.fromJson(Map<String, dynamic> json) => 
      _$TaskAttachmentFromJson(json);
}

@freezed
class TaskComment with _$TaskComment {
  const factory TaskComment({
    required String id,
    required String taskId,
    required String authorId,
    required String text,
    @Default([]) List<String> mentions,
    required DateTime createdAt,
  }) = _TaskComment;

  factory TaskComment.fromJson(Map<String, dynamic> json) => 
      _$TaskCommentFromJson(json);
}

@freezed
class TaskAudit with _$TaskAudit {
  const factory TaskAudit({
    required String id,
    required String taskId,
    required TaskStatus fromStatus,
    required TaskStatus toStatus,
    required String byUserId,
    String? note,
    required DateTime at,
  }) = _TaskAudit;

  factory TaskAudit.fromJson(Map<String, dynamic> json) => 
      _$TaskAuditFromJson(json);
}

enum ReminderChannel {
  @JsonValue('push')
  push,
  @JsonValue('email')
  email,
  @JsonValue('sms')
  sms,
}

@freezed
class Reminder with _$Reminder {
  const factory Reminder({
    required String id,
    required String taskId,
    required DateTime at,
    required ReminderChannel channel,
    @Default(false) bool isSent,
  }) = _Reminder;

  factory Reminder.fromJson(Map<String, dynamic> json) => 
      _$ReminderFromJson(json);
}
