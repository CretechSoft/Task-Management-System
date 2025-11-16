import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/repositories.dart';
import '../../core/error/failures.dart';

/// Mock implementation of AuthRepository for demonstration
class MockAuthRepository implements AuthRepository {
  final SharedPreferences _prefs;

  MockAuthRepository(this._prefs);

  @override
  Future<Either<Failure, AuthResponse>> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    try {
      // Mock validation
      if (email == 'test@example.com' && password == 'password123') {
        final user = User(
          id: 'usr-001',
          name: 'John Doe',
          email: email,
          role: UserRole.employee,
          departmentId: 'dept-001',
          isActive: true,
        );

        final token = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
        
        // Save to local storage
        await _prefs.setString('auth_token', token);
        await _prefs.setString('user_id', user.id);
        await _prefs.setString('user_email', user.email);
        await _prefs.setString('user_name', user.name);
        await _prefs.setString('user_role', user.role.name);

        return Right(AuthResponse(token: token, user: user));
      } else {
        return const Left(UnauthorizedFailure(
          message: 'Invalid email or password',
        ));
      }
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthResponse>> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    try {
      final user = User(
        id: 'usr-${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        email: email,
        phone: phone,
        role: UserRole.employee,
        isActive: true,
      );

      final token = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
      
      // Save to local storage
      await _prefs.setString('auth_token', token);
      await _prefs.setString('user_id', user.id);
      await _prefs.setString('user_email', user.email);
      await _prefs.setString('user_name', user.name);
      await _prefs.setString('user_role', user.role.name);

      return Right(AuthResponse(token: token, user: user));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      await _prefs.remove('auth_token');
      await _prefs.remove('user_id');
      await _prefs.remove('user_email');
      await _prefs.remove('user_name');
      await _prefs.remove('user_role');
      
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      final userId = _prefs.getString('user_id');
      final email = _prefs.getString('user_email');
      final name = _prefs.getString('user_name');
      final roleStr = _prefs.getString('user_role');

      if (userId == null || email == null || name == null) {
        return const Left(UnauthorizedFailure(
          message: 'User not found',
        ));
      }

      final role = UserRole.values.firstWhere(
        (r) => r.name == roleStr,
        orElse: () => UserRole.employee,
      );

      final user = User(
        id: userId,
        name: name,
        email: email,
        role: role,
        isActive: true,
      );

      return Right(user);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = _prefs.getString('auth_token');
    return token != null && token.isNotEmpty;
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1));

    try {
      // Mock success
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
