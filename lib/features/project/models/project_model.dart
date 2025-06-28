import 'package:hive/hive.dart';

part 'project_model.g.dart';

@HiveType(typeId: 4)
class ProjectModel extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String description;
  
  @HiveField(3)
  final String path;
  
  @HiveField(4)
  final DateTime createdAt;
  
  @HiveField(5)
  final DateTime updatedAt;
  
  @HiveField(6)
  final Map<String, dynamic>? gitConfig;
  
  @HiveField(7)
  final Map<String, dynamic>? firebaseConfig;

  ProjectModel({
    required this.id,
    required this.name,
    required this.description,
    required this.path,
    required this.createdAt,
    required this.updatedAt,
    this.gitConfig,
    this.firebaseConfig,
  });

  ProjectModel copyWith({
    String? id,
    String? name,
    String? description,
    String? path,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? gitConfig,
    Map<String, dynamic>? firebaseConfig,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      path: path ?? this.path,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      gitConfig: gitConfig ?? this.gitConfig,
      firebaseConfig: firebaseConfig ?? this.firebaseConfig,
    );
  }
}
