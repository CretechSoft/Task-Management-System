import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../domain/entities/task.dart';
import '../../../../domain/repositories/repositories.dart';

// Events
abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadDashboardEvent extends DashboardEvent {}

class RefreshDashboardEvent extends DashboardEvent {}

// States
abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final int todayTasksCount;
  final int overdueTasksCount;
  final int inProgressTasksCount;
  final int completedTasksCount;
  final List<Task> recentTasks;

  const DashboardLoaded({
    required this.todayTasksCount,
    required this.overdueTasksCount,
    required this.inProgressTasksCount,
    required this.completedTasksCount,
    required this.recentTasks,
  });

  @override
  List<Object> get props => [
        todayTasksCount,
        overdueTasksCount,
        inProgressTasksCount,
        completedTasksCount,
        recentTasks,
      ];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final TaskRepository taskRepository;

  DashboardBloc({required this.taskRepository}) : super(DashboardInitial()) {
    on<LoadDashboardEvent>(_onLoadDashboard);
    on<RefreshDashboardEvent>(_onRefreshDashboard);
  }

  Future<void> _onLoadDashboard(
    LoadDashboardEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());
    await _loadDashboardData(emit);
  }

  Future<void> _onRefreshDashboard(
    RefreshDashboardEvent event,
    Emitter<DashboardState> emit,
  ) async {
    await _loadDashboardData(emit);
  }

  Future<void> _loadDashboardData(Emitter<DashboardState> emit) async {
    try {
      // Load all tasks to calculate metrics
      final allTasksResult = await taskRepository.getTasks(size: 100);
      
      await allTasksResult.fold(
        (failure) async => emit(DashboardError(failure.message)),
        (allTasks) async {
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          final tomorrow = today.add(const Duration(days: 1));

          // Calculate metrics
          final todayTasks = allTasks.where((task) {
            if (task.slaDueAt == null) return false;
            return task.slaDueAt!.isAfter(today) &&
                   task.slaDueAt!.isBefore(tomorrow);
          }).length;

          final overdueTasks = allTasks.where((task) {
            if (task.slaDueAt == null) return false;
            return task.slaDueAt!.isBefore(now) &&
                   task.status != TaskStatus.qaApproved;
          }).length;

          final inProgressTasks = allTasks
              .where((task) => task.status == TaskStatus.inProgress)
              .length;

          final completedTasks = allTasks
              .where((task) => task.status == TaskStatus.qaApproved)
              .length;

          // Get recent tasks (last 5)
          final recentTasks = allTasks.take(5).toList();

          emit(DashboardLoaded(
            todayTasksCount: todayTasks,
            overdueTasksCount: overdueTasks,
            inProgressTasksCount: inProgressTasks,
            completedTasksCount: completedTasks,
            recentTasks: recentTasks,
          ));
        },
      );
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }
}
