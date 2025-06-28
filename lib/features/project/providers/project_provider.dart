import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../models/project_model.dart';

final projectsProvider = StateNotifierProvider<ProjectsNotifier, List<ProjectModel>>((ref) {
  return ProjectsNotifier();
});

final currentProjectProvider = StateProvider<ProjectModel?>((ref) => null);

class ProjectsNotifier extends StateNotifier<List<ProjectModel>> {
  ProjectsNotifier() : super([]);

  void addProject(ProjectModel project) {
    state = [project, ...state];
  }

  void updateProject(ProjectModel updatedProject) {
    state = state.map((project) {
      return project.id == updatedProject.id ? updatedProject : project;
    }).toList();
  }

  void deleteProject(String projectId) {
    state = state.where((project) => project.id != projectId).toList();
  }

  ProjectModel? getProject(String id) {
    try {
      return state.firstWhere((project) => project.id == id);
    } catch (e) {
      return null;
    }
  }

  ProjectModel createNewProject({
    required String name,
    required String description,
    required String path,
  }) {
    final project = ProjectModel(
      id: const Uuid().v4(),
      name: name,
      description: description,
      path: path,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    addProject(project);
    return project;
  }
}
