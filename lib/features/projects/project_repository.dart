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
        .map((item) => Project.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<Project> getProject(int id) async {
    final response = await api.dio.get('/api/projects/$id');

    return Project.fromJson(Map<String, dynamic>.from(response.data));
  }
}

Future<Project> uploadMedia(
  int projectId,
  String filePath,
) async {
  final formData = FormData.fromMap({
    'file': await MultipartFile.fromFile(filePath),
  });

  final response = await api.dio.post(
    '/api/projects/$projectId/media',
    data: formData,
  );

  return Project.fromJson(
    Map<String, dynamic>.from(response.data),
  );
}
Future<void> deleteProject(int id) async {
  await api.dio.delete('/api/projects/$id');
}

Future<void> publishProject(int id) async {
  await api.dio.post('/api/projects/$id/publish');
}

Future<void> unpublishProject(int id) async {
  await api.dio.post('/api/projects/$id/unpublish');
}
