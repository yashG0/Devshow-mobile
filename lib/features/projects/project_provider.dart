import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../../models/project.dart';
import '../auth/auth_provider.dart';
import 'project_repository.dart';

final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  return ProjectRepository(
    ref.watch(apiClientProvider),
  );
});

final projectsProvider = FutureProvider<List<Project>>((ref) {
  return ref.watch(projectRepositoryProvider).getProjects();
});

final projectDetailProvider =
    FutureProvider.family<Project, int>((ref, id) {
  return ref.watch(projectRepositoryProvider).getProject(id);
});
