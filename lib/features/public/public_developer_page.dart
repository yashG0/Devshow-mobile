import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/tech_chip.dart';
import 'public_repository.dart';

class PublicDeveloperPage extends ConsumerWidget {
  final String username;

  const PublicDeveloperPage({super.key, required this.username});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<Map<String, dynamic>>(
      future: ref.read(publicRepositoryProvider).getDeveloper(username),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return const Scaffold(
            body: Center(child: Text('Developer not found')),
          );
        }

        return _DeveloperView(data: snapshot.data!);
      },
    );
  }
}

class _DeveloperView extends StatelessWidget {
  final Map<String, dynamic> data;

  const _DeveloperView({required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final username = data['username']?.toString() ?? '';
    final displayName = data['display_name']?.toString() ?? username;
    final bio = data['bio']?.toString() ?? '';

    final github = data['github_url']?.toString();
    final linkedin = data['linkedin_url']?.toString();
    final website = data['website_url']?.toString();

    final projects = (data['projects'] as List<dynamic>? ?? [])
        .map((e) => Map<String, dynamic>.from(e))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('DevShow')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const SizedBox(height: 20),

              CircleAvatar(
                radius: 42,
                child: Text(
                  displayName.isNotEmpty ? displayName[0].toUpperCase() : '?',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              Text(
                displayName,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                '@$username',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontFamily: 'monospace',
                ),
              ),

              if (bio.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  bio,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],

              const SizedBox(height: 18),

              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                children: [
                  if (github != null)
                    _LinkButton(icon: Icons.code, label: 'GitHub', url: github),
                  if (linkedin != null)
                    _LinkButton(
                      icon: Icons.work_outline,
                      label: 'LinkedIn',
                      url: linkedin,
                    ),
                  if (website != null)
                    _LinkButton(
                      icon: Icons.language,
                      label: 'Website',
                      url: website,
                    ),
                ],
              ),

              const SizedBox(height: 44),

              Text(
                'PROJECTS',
                style: theme.textTheme.labelMedium?.copyWith(
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 14),

              if (projects.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(child: Text('No published projects yet.')),
                ),

              ...projects.map(
                (project) =>
                    _PublicProjectCard(username: username, project: project),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PublicProjectCard extends StatelessWidget {
  final String username;
  final Map<String, dynamic> project;

  const _PublicProjectCard({required this.username, required this.project});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final slug = project['slug']?.toString() ?? '';
    final title = project['title']?.toString() ?? '';
    final tagline = project['tagline']?.toString() ?? '';

    final tech = (project['tech'] as List<dynamic>? ?? [])
        .map((e) => e.toString())
        .toList();

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          context.push('/dev/$username/$slug');
        },
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                tagline,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              if (tech.isNotEmpty) ...[
                const SizedBox(height: 14),
                Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: tech
                      .take(6)
                      .map((item) => TechChip(label: item))
                      .toList(),
                ),
              ],
              const SizedBox(height: 14),
              Row(
                children: [
                  Text(
                    'View project',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 17,
                    color: theme.colorScheme.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LinkButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String url;

  const _LinkButton({
    required this.icon,
    required this.label,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {
        // URL launch will be wired in final polish.
      },
      icon: Icon(icon, size: 17),
      label: Text(label),
    );
  }
}
