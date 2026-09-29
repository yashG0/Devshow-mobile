import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../core/api/api_client.dart';
import '../../core/widgets/tech_chip.dart';
import 'public_repository.dart';

class PublicProjectPage extends ConsumerWidget {
  final String username;
  final String slug;

  const PublicProjectPage({
    super.key,
    required this.username,
    required this.slug,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<Map<String, dynamic>>(
      future: ref.read(publicRepositoryProvider).getProject(username, slug),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return const Scaffold(body: Center(child: Text('Project not found')));
        }

        return _ProjectView(data: snapshot.data!, username: username);
      },
    );
  }
}

class _ProjectView extends StatelessWidget {
  final Map<String, dynamic> data;
  final String username;

  const _ProjectView({required this.data, required this.username});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final developer = Map<String, dynamic>.from(data['developer'] ?? {});

    final project = Map<String, dynamic>.from(data['project'] ?? {});

    final title = project['title']?.toString() ?? '';
    final tagline = project['tagline']?.toString() ?? '';
    final description = project['description_md']?.toString() ?? '';

    final technologies = (project['tech'] as List<dynamic>? ?? [])
        .map((e) => e.toString())
        .toList();

    final media = (project['media'] as List<dynamic>? ?? [])
        .map((e) => Map<String, dynamic>.from(e))
        .toList();

    final github = project['github_url']?.toString();
    final demo = project['demo_url']?.toString();

    final developerName =
        developer['display_name']?.toString() ??
        developer['username']?.toString() ??
        username;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('DevShow'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const SizedBox(height: 20),

              Text(
                title,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                tagline,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 18),

              Row(
                children: [
                  const Icon(Icons.person_outline_rounded, size: 18),
                  const SizedBox(width: 7),
                  Text(
                    developerName,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),

              if (technologies.isNotEmpty) ...[
                const SizedBox(height: 20),
                Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: technologies
                      .map((tech) => TechChip(label: tech))
                      .toList(),
                ),
              ],

              if (media.isNotEmpty) ...[
                const SizedBox(height: 28),
                ...media.map((item) {
                  final path = item['path']?.toString();

                  if (path == null) {
                    return const SizedBox.shrink();
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                        getMediaUrl(path),
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) {
                          return const SizedBox(
                            height: 180,
                            child: Center(child: Text('Image unavailable')),
                          );
                        },
                      ),
                    ),
                  );
                }),
              ],

              if (description.isNotEmpty) ...[
                const SizedBox(height: 20),
                MarkdownBody(data: description, selectable: true),
              ],

              const SizedBox(height: 28),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  if (github != null)
                    FilledButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.code),
                      label: const Text('GitHub'),
                    ),
                  if (demo != null)
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.open_in_new),
                      label: const Text('Live Demo'),
                    ),
                ],
              ),

              const SizedBox(height: 40),

              Text(
                '${project['view_count'] ?? 0} views',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
