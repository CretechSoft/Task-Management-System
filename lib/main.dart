import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/config/app_config.dart';
import 'core/theme/app_theme.dart';
import 'core/l10n/app_localizations.dart';
import 'core/router/app_router.dart';
import 'core/di/injection_container.dart' as di;
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/tasks/presentation/bloc/tasks_bloc.dart';
import 'features/dashboard/presentation/bloc/dashboard_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize dependencies
  await di.init();
  
  runApp(const TaskManagementApp());
}

class TaskManagementApp extends StatelessWidget {
  const TaskManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.getIt<AuthBloc>()..add(CheckAuthEvent()),
        ),
        BlocProvider(
          create: (context) => di.getIt<TasksBloc>(),
        ),
        BlocProvider(
          create: (context) => di.getIt<DashboardBloc>(),
        ),
      ],
      child: MaterialApp.router(
        title: AppConfig.appName,
        debugShowCheckedModeBanner: false,
        
        // Theme
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        
        // Localization
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        
        // Routing
        routerConfig: AppRouter.router,
      ),
    );
  }
}

