import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../domain/entities/task.dart';
import '../../../../domain/repositories/repositories.dart';

// Events
abstract class TaskDetailsEvent extends Equatable {
  const TaskDetailsEvent();

  @override
  List<Object?> get props => [];
}

class LoadTaskDetailsEvent extends TaskDetailsEvent {
  final String taskId;

  const LoadTaskDetailsEvent(this.taskId);

  @override
  List<Object> get props => [taskId];
}

class UpdateTaskStatusEvent extends TaskDetailsEvent {
  final String taskId;
  final TaskStatus toStatus;
  final String? note;

  const UpdateTaskStatusEvent({
    required this.taskId,
    required this.toStatus,
    this.note,
  });

  @override
  List<Object?> get props => [taskId, toStatus, note];
}

class UpdateTaskProgressEvent extends TaskDetailsEvent {
  final String taskId;
  final int progress;

  const UpdateTaskProgressEvent({
    required this.taskId,
    required this.progress,
  });

  @override
  List<Object> get props => [taskId, progress];
}

class AddCommentEvent extends TaskDetailsEvent {
  final String taskId;
  final String text;
  final List<String> mentions;

  const AddCommentEvent({
    required this.taskId,
    required this.text,
    this.mentions = const [],
  });

  @override
  List<Object> get props => [taskId, text, mentions];
}

class AddAttachmentEvent extends TaskDetailsEvent {
  final String taskId;
  final String filePath;
  final AttachmentType type;

  const AddAttachmentEvent({
    required this.taskId,
    required this.filePath,
    required this.type,
  });

  @override
  List<Object> get props => [taskId, filePath, type];
}

class UpdateChecklistItemEvent extends TaskDetailsEvent {
  final TaskChecklist item;

  const UpdateChecklistItemEvent(this.item);

  @override
  List<Object> get props => [item];
}

// States
abstract class TaskDetailsState extends Equatable {
  const TaskDetailsState();

  @override
  List<Object?> get props => [];
}

class TaskDetailsInitial extends TaskDetailsState {}

class TaskDetailsLoading extends TaskDetailsState {}

class TaskDetailsLoaded extends TaskDetailsState {
  final Task task;
  final List<TaskComment> comments;
  final List<TaskAttachment> attachments;
  final List<TaskChecklist> checklist;
  final List<dynamic> timeline;

  const TaskDetailsLoaded({
    required this.task,
    required this.comments,
    required this.attachments,
    required this.checklist,
    required this.timeline,
  });

  @override
  List<Object> get props => [task, comments, attachments, checklist, timeline];

  TaskDetailsLoaded copyWith({
    Task? task,
    List<TaskComment>? comments,
    List<TaskAttachment>? attachments,
    List<TaskChecklist>? checklist,
    List<dynamic>? timeline,
  }) {
    return TaskDetailsLoaded(
      task: task ?? this.task,
      comments: comments ?? this.comments,
      attachments: attachments ?? this.attachments,
      checklist: checklist ?? this.checklist,
      timeline: timeline ?? this.timeline,
    );
  }
}

class TaskDetailsError extends TaskDetailsState {
  final String message;

  const TaskDetailsError(this.message);

  @override
  List<Object> get props => [message];
}

class TaskDetailsUpdating extends TaskDetailsState {
  final Task task;

  const TaskDetailsUpdating(this.task);

  @override
  List<Object> get props => [task];
}

// BLoC
class TaskDetailsBloc extends Bloc<TaskDetailsEvent, TaskDetailsState> {
  final TaskRepository taskRepository;

  TaskDetailsBloc({required this.taskRepository}) : super(TaskDetailsInitial()) {
    on<LoadTaskDetailsEvent>(_onLoadTaskDetails);
    on<UpdateTaskStatusEvent>(_onUpdateTaskStatus);
    on<UpdateTaskProgressEvent>(_onUpdateTaskProgress);
    on<AddCommentEvent>(_onAddComment);
    on<AddAttachmentEvent>(_onAddAttachment);
    on<UpdateChecklistItemEvent>(_onUpdateChecklistItem);
  }

  Future<void> _onLoadTaskDetails(
    LoadTaskDetailsEvent event,
    Emitter<TaskDetailsState> emit,
  ) async {
    emit(TaskDetailsLoading());

    final taskResult = await taskRepository.getTask(event.taskId);
    
    await taskResult.fold(
      (failure) async => emit(TaskDetailsError(failure.message)),
      (task) async {
        // Load all related data in parallel
        final results = await Future.wait([
          taskRepository.getComments(event.taskId),
          taskRepository.getAttachments(event.taskId),
          taskRepository.getChecklist(event.taskId),
          taskRepository.getTimeline(event.taskId),
        ]);

        var hasError = false;
        var errorMessage = '';

        final comments = results[0].fold(
          (failure) {
            hasError = true;
            errorMessage = failure.message;
            return <TaskComment>[];
          },
          (data) => data as List<TaskComment>,
        );

        final attachments = results[1].fold(
          (failure) {
            if (!hasError) {
              hasError = true;
              errorMessage = failure.message;
            }
            return <TaskAttachment>[];
          },
          (data) => data as List<TaskAttachment>,
        );

        final checklist = results[2].fold(
          (failure) {
            if (!hasError) {
              hasError = true;
              errorMessage = failure.message;
            }
            return <TaskChecklist>[];
          },
          (data) => data as List<TaskChecklist>,
        );

        final timeline = results[3].fold(
          (failure) {
            if (!hasError) {
              hasError = true;
              errorMessage = failure.message;
            }
            return <dynamic>[];
          },
          (data) => data as List<dynamic>,
        );

        if (hasError) {
          emit(TaskDetailsError(errorMessage));
        } else {
          emit(TaskDetailsLoaded(
            task: task,
            comments: comments,
            attachments: attachments,
            checklist: checklist,
            timeline: timeline,
          ));
        }
      },
    );
  }

  Future<void> _onUpdateTaskStatus(
    UpdateTaskStatusEvent event,
    Emitter<TaskDetailsState> emit,
  ) async {
    final currentState = state;
    if (currentState is TaskDetailsLoaded) {
      emit(TaskDetailsUpdating(currentState.task));

      final result = await taskRepository.changeTaskStatus(
        taskId: event.taskId,
        toStatus: event.toStatus,
        note: event.note,
      );

      result.fold(
        (failure) => emit(TaskDetailsError(failure.message)),
        (updatedTask) {
          // Reload full task details
          add(LoadTaskDetailsEvent(event.taskId));
        },
      );
    }
  }

  Future<void> _onUpdateTaskProgress(
    UpdateTaskProgressEvent event,
    Emitter<TaskDetailsState> emit,
  ) async {
    final currentState = state;
    if (currentState is TaskDetailsLoaded) {
      emit(TaskDetailsUpdating(currentState.task));

      final result = await taskRepository.updateTaskProgress(
        taskId: event.taskId,
        progress: event.progress,
      );

      result.fold(
        (failure) => emit(TaskDetailsError(failure.message)),
        (updatedTask) => emit(currentState.copyWith(task: updatedTask)),
      );
    }
  }

  Future<void> _onAddComment(
    AddCommentEvent event,
    Emitter<TaskDetailsState> emit,
  ) async {
    final currentState = state;
    if (currentState is TaskDetailsLoaded) {
      final result = await taskRepository.addComment(
        taskId: event.taskId,
        text: event.text,
        mentions: event.mentions,
      );

      result.fold(
        (failure) => emit(TaskDetailsError(failure.message)),
        (comment) {
          // Reload to get updated comments and timeline
          add(LoadTaskDetailsEvent(event.taskId));
        },
      );
    }
  }

  Future<void> _onAddAttachment(
    AddAttachmentEvent event,
    Emitter<TaskDetailsState> emit,
  ) async {
    final currentState = state;
    if (currentState is TaskDetailsLoaded) {
      final result = await taskRepository.addAttachment(
        taskId: event.taskId,
        filePath: event.filePath,
        type: event.type,
      );

      result.fold(
        (failure) => emit(TaskDetailsError(failure.message)),
        (attachment) {
          final updatedAttachments = List<TaskAttachment>.from(currentState.attachments)
            ..add(attachment);
          emit(currentState.copyWith(attachments: updatedAttachments));
        },
      );
    }
  }

  Future<void> _onUpdateChecklistItem(
    UpdateChecklistItemEvent event,
    Emitter<TaskDetailsState> emit,
  ) async {
    final currentState = state;
    if (currentState is TaskDetailsLoaded) {
      final result = await taskRepository.updateChecklistItem(event.item);

      result.fold(
        (failure) => emit(TaskDetailsError(failure.message)),
        (updatedItem) {
          final updatedChecklist = currentState.checklist.map((item) {
            return item.id == updatedItem.id ? updatedItem : item;
          }).toList();
          emit(currentState.copyWith(checklist: updatedChecklist));
        },
      );
    }
  }
}
