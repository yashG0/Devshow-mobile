import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/project.dart';
import '../auth/auth_provider.dart';
import 'project_repository.dart';

final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  return ProjectRepository(ref.watch(apiClientProvider));
});

final projectsProvider = FutureProvider<List<Project>>((ref) {
  return ref.watch(projectRepositoryProvider).getProjects();
});

final projectDetailProvider = FutureProvider.family<Project, int>((ref, id) {
  return ref.watch(projectRepositoryProvider).getProject(id);
});

Future<Project> createProject({
  required String title,
  required String tagline,
  required String description,
  required List<String> technologies,
  String? githubUrl,
  String? demoUrl,
}) async {
  final response = await api.dio.post(
    '/api/projects',
    data: {
      'title': title,
      'tagline': tagline,
      'description': description,
      'technologies': technologies,
      'github_url': githubUrl,
      'demo_url': demoUrl,
    },
  );

  return Project.fromJson(
    Map<String, dynamic>.from(response.data),
  );
}

Future<Project> updateProject(
  int id, {
  required String title,
  required String tagline,
  required String description,
  required List<String> technologies,
  String? githubUrl,
  String? demoUrl,
}) async {
  final response = await api.dio.put(
    '/api/projects/$id',
    data: {
      'title': title,
      'tagline': tagline,
      'description': description,
      'technologies': technologies,
      'github_url': githubUrl,
      'demo_url': demoUrl,
    },
  );

  return Project.fromJson(
    Map<String, dynamic>.from(response.data),
  );
}