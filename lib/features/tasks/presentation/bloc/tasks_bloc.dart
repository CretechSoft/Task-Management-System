import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../domain/entities/task.dart';
import '../../../../domain/repositories/repositories.dart';

// Events
abstract class TasksEvent extends Equatable {
  const TasksEvent();

  @override
  List<Object?> get props => [];
}

class LoadTasksEvent extends TasksEvent {
  final TaskStatus? status;
  final TaskPriority? priority;
  final String? assigneeId;
  final String? projectId;
  final String? search;

  const LoadTasksEvent({
    this.status,
    this.priority,
    this.assigneeId,
    this.projectId,
    this.search,
  });

  @override
  List<Object?> get props => [status, priority, assigneeId, projectId, search];
}

class RefreshTasksEvent extends TasksEvent {}

class FilterTasksEvent extends TasksEvent {
  final TaskStatus? status;
  final TaskPriority? priority;

  const FilterTasksEvent({this.status, this.priority});

  @override
  List<Object?> get props => [status, priority];
}

class SearchTasksEvent extends TasksEvent {
  final String query;

  const SearchTasksEvent(this.query);

  @override
  List<Object?> get props => [query];
}

// States
abstract class TasksState extends Equatable {
  const TasksState();

  @override
  List<Object?> get props => [];
}

class TasksInitial extends TasksState {}

class TasksLoading extends TasksState {}

class TasksLoaded extends TasksState {
  final List<Task> tasks;
  final TaskStatus? activeStatusFilter;
  final TaskPriority? activePriorityFilter;
  final String? activeSearch;

  const TasksLoaded({
    required this.tasks,
    this.activeStatusFilter,
    this.activePriorityFilter,
    this.activeSearch,
  });

  @override
  List<Object?> get props => [
        tasks,
        activeStatusFilter,
        activePriorityFilter,
        activeSearch,
      ];

  TasksLoaded copyWith({
    List<Task>? tasks,
    TaskStatus? activeStatusFilter,
    TaskPriority? activePriorityFilter,
    String? activeSearch,
    bool clearStatusFilter = false,
    bool clearPriorityFilter = false,
    bool clearSearch = false,
  }) {
    return TasksLoaded(
      tasks: tasks ?? this.tasks,
      activeStatusFilter: clearStatusFilter ? null : (activeStatusFilter ?? this.activeStatusFilter),
      activePriorityFilter: clearPriorityFilter ? null : (activePriorityFilter ?? this.activePriorityFilter),
      activeSearch: clearSearch ? null : (activeSearch ?? this.activeSearch),
    );
  }
}

class TasksError extends TasksState {
  final String message;

  const TasksError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final TaskRepository taskRepository;

  TasksBloc({required this.taskRepository}) : super(TasksInitial()) {
    on<LoadTasksEvent>(_onLoadTasks);
    on<RefreshTasksEvent>(_onRefreshTasks);
    on<FilterTasksEvent>(_onFilterTasks);
    on<SearchTasksEvent>(_onSearchTasks);
  }

  Future<void> _onLoadTasks(
    LoadTasksEvent event,
    Emitter<TasksState> emit,
  ) async {
    emit(TasksLoading());

    final result = await taskRepository.getTasks(
      status: event.status,
      priority: event.priority,
      assigneeId: event.assigneeId,
      projectId: event.projectId,
      search: event.search,
    );

    result.fold(
      (failure) => emit(TasksError(failure.message)),
      (tasks) => emit(TasksLoaded(
        tasks: tasks,
        activeStatusFilter: event.status,
        activePriorityFilter: event.priority,
        activeSearch: event.search,
      )),
    );
  }

  Future<void> _onRefreshTasks(
    RefreshTasksEvent event,
    Emitter<TasksState> emit,
  ) async {
    final currentState = state;
    if (currentState is TasksLoaded) {
      final result = await taskRepository.getTasks(
        status: currentState.activeStatusFilter,
        priority: currentState.activePriorityFilter,
        search: currentState.activeSearch,
      );

      result.fold(
        (failure) => emit(TasksError(failure.message)),
        (tasks) => emit(currentState.copyWith(tasks: tasks)),
      );
    } else {
      add(const LoadTasksEvent());
    }
  }

  Future<void> _onFilterTasks(
    FilterTasksEvent event,
    Emitter<TasksState> emit,
  ) async {
    final currentState = state;
    if (currentState is TasksLoaded) {
      emit(TasksLoading());

      final result = await taskRepository.getTasks(
        status: event.status,
        priority: event.priority,
        search: currentState.activeSearch,
      );

      result.fold(
        (failure) => emit(TasksError(failure.message)),
        (tasks) => emit(TasksLoaded(
          tasks: tasks,
          activeStatusFilter: event.status,
          activePriorityFilter: event.priority,
          activeSearch: currentState.activeSearch,
        )),
      );
    }
  }

  Future<void> _onSearchTasks(
    SearchTasksEvent event,
    Emitter<TasksState> emit,
  ) async {
    final currentState = state;
    if (currentState is TasksLoaded) {
      emit(TasksLoading());

      final result = await taskRepository.getTasks(
        status: currentState.activeStatusFilter,
        priority: currentState.activePriorityFilter,
        search: event.query,
      );

      result.fold(
        (failure) => emit(TasksError(failure.message)),
        (tasks) => emit(TasksLoaded(
          tasks: tasks,
          activeStatusFilter: currentState.activeStatusFilter,
          activePriorityFilter: currentState.activePriorityFilter,
          activeSearch: event.query,
        )),
      );
    }
  }
}
