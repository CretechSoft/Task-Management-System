import 'package:freezed_annotation/freezed_annotation.dart';

part 'project.freezed.dart';
part 'project.g.dart';

@freezed
class Project with _$Project {
  const factory Project({
    required String id,
    required String name,
    required String code,
    String? description,
    @Default(true) bool isActive,
  }) = _Project;

  factory Project.fromJson(Map<String, dynamic> json) => _$ProjectFromJson(json);
}

@freezed
class Department with _$Department {
  const factory Department({
    required String id,
    required String name,
    required String code,
  }) = _Department;

  factory Department.fromJson(Map<String, dynamic> json) => 
      _$DepartmentFromJson(json);
}
