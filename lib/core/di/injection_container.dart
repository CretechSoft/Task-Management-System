import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../config/app_config.dart';
import '../../domain/repositories/repositories.dart';
import '../../data/repositories/mock_task_repository.dart';
import '../../data/repositories/mock_auth_repository.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/tasks/presentation/bloc/tasks_bloc.dart';
import '../../features/tasks/presentation/bloc/task_details_bloc.dart';
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);
  
  // Dio setup
  final dio = Dio(
    BaseOptions(
      baseUrl: '${AppConfig.baseUrl}/${AppConfig.apiVersion}',
      connectTimeout: Duration(milliseconds: AppConfig.connectTimeout),
      receiveTimeout: Duration(milliseconds: AppConfig.receiveTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );
  
  // Add interceptors
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Add auth token if available
        final token = sharedPreferences.getString('auth_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) {
        // Handle errors globally
        return handler.next(error);
      },
    ),
  );
  
  getIt.registerSingleton<Dio>(dio);

  // Repositories
  getIt.registerLazySingleton<TaskRepository>(
    () => MockTaskRepository(),
  );
  
  getIt.registerLazySingleton<AuthRepository>(
    () => MockAuthRepository(getIt<SharedPreferences>()),
  );

  // BLoCs
  getIt.registerFactory(
    () => AuthBloc(authRepository: getIt<AuthRepository>()),
  );
  
  getIt.registerFactory(
    () => TasksBloc(taskRepository: getIt<TaskRepository>()),
  );
  
  getIt.registerFactory(
    () => TaskDetailsBloc(taskRepository: getIt<TaskRepository>()),
  );
  
  getIt.registerFactory(
    () => DashboardBloc(taskRepository: getIt<TaskRepository>()),
  );
}

