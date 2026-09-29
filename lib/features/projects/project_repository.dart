import '../../core/api/api_client.dart';
import '../../models/project.dart';

class ProjectRepository {
  final ApiClient api;

  ProjectRepository(this.api);

  Future<List<Project>> getProjects() async {
    final response = await api.dio.get('/api/projects');

    final data = response.data;

    if (data is! List) {
      return [];
    }

    return data
        .map(
          (item) => Project.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }

  Future<Project> getProject(int id) async {
    final response = await api.dio.get('/api/projects/$id');

    return Project.fromJson(
      Map<String, dynamic>.from(response.data),
    );
  }
}
