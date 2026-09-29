import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/widgets/tech_chip.dart';
import 'project_provider.dart';

class ProjectDetailPage extends ConsumerWidget {
  final int projectId;

  const ProjectDetailPage({super.key, required this.projectId});

  Future<void> _openUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final project = ref.watch(projectDetailProvider(projectId));

    return Scaffold(
      appBar: AppBar(title: const Text('Project')),
      body: project.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline_rounded, size: 40),
                const SizedBox(height: 12),
                const Text('Unable to load project'),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () {
                    ref.invalidate(projectDetailProvider(projectId));
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (project) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(projectDetailProvider(projectId));
              await ref.read(projectDetailProvider(projectId).future);
            },
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
              children: [
                Text(
                  project.title,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  project.tagline,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    _StatusBadge(published: project.published),
                    const SizedBox(width: 10),
                    Icon(
                      Icons.visibility_outlined,
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${project.viewCount} views',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),

                if (project.media.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _ScreenshotGallery(
                    paths: project.media.map((media) => media.path).toList(),
                  ),
                ],

                if (project.technologies.isNotEmpty) ...[
                  const SizedBox(height: 28),
                  Text(
                    'TECHNOLOGIES',
                    style: theme.textTheme.labelMedium?.copyWith(
                      letterSpacing: 1.3,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: project.technologies
                        .map<Widget>(
                          (technology) => TechChip(label: technology),
                        )
                        .toList(),
                  ),
                ],

                if (project.description != null &&
                    project.description!.trim().isNotEmpty) ...[
                  const SizedBox(height: 28),
                  Text(
                    'ABOUT THIS PROJECT',
                    style: theme.textTheme.labelMedium?.copyWith(
                      letterSpacing: 1.3,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: theme.colorScheme.outline),
                    ),
                    child: Text(
                      project.description!,
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.65),
                    ),
                  ),
                ],

                if (project.githubUrl != null || project.demoUrl != null) ...[
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      if (project.githubUrl != null)
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _openUrl(project.githubUrl!),
                            icon: const Icon(Icons.code_rounded),
                            label: const Text('GitHub'),
                          ),
                        ),
                      if (project.githubUrl != null && project.demoUrl != null)
                        const SizedBox(width: 10),
                      if (project.demoUrl != null)
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () => _openUrl(project.demoUrl!),
                            icon: const Icon(Icons.open_in_new_rounded),
                            label: const Text('Live Demo'),
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool published;

  const _StatusBadge({required this.published});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: published
            ? theme.colorScheme.primary.withValues(alpha: 0.12)
            : theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: published
              ? theme.colorScheme.primary.withValues(alpha: 0.35)
              : theme.colorScheme.outline,
        ),
      ),
      child: Text(
        published ? 'PUBLISHED' : 'DRAFT',
        style: theme.textTheme.labelSmall?.copyWith(
          color: published
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _ScreenshotGallery extends StatelessWidget {
  final List<String> paths;

  const _ScreenshotGallery({required this.paths});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210,
      child: PageView.builder(
        itemCount: paths.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(right: index == paths.length - 1 ? 0 : 12),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Image.network(
              paths[index],
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) {
                return const Center(
                  child: Icon(Icons.image_not_supported_outlined, size: 36),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
