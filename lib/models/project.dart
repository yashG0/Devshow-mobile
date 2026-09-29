class Project {
  final int id;
  final String title;
  final String tagline;
  final String? description;
  final List<String> technologies;
  final String? githubUrl;
  final String? demoUrl;
  final bool published;
  final int viewCount;
  final List<ProjectMedia> media;

  const Project({
    required this.id,
    required this.title,
    required this.tagline,
    this.description,
    required this.technologies,
    this.githubUrl,
    this.demoUrl,
    required this.published,
    required this.viewCount,
    required this.media,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] as int,
      title: json['title'] as String,
      tagline: json['tagline'] as String? ?? '',
      description: json['description'] as String?,
      technologies: (json['technologies'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      githubUrl: json['github_url'] as String?,
      demoUrl: json['demo_url'] as String?,
      published: json['published'] as bool? ?? false,
      viewCount: json['view_count'] as int? ?? 0,
      media: (json['media'] as List<dynamic>? ?? [])
          .map(
            (e) => ProjectMedia.fromJson(
              Map<String, dynamic>.from(e),
            ),
          )
          .toList(),
    );
  }
}

class ProjectMedia {
  final int id;
  final String path;

  const ProjectMedia({
    required this.id,
    required this.path,
  });

  factory ProjectMedia.fromJson(Map<String, dynamic> json) {
    return ProjectMedia(
      id: json['id'] as int,
      path: json['path'] as String,
    );
  }
}
