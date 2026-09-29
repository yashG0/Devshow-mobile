import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/section_header.dart';
import '../../core/widgets/stat_item.dart';
import '../auth/auth_provider.dart';
import '../projects/project_provider.dart';
import '../projects/projects_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final auth = ref.watch(authProvider);
    final user = auth.asData?.value.user;
    final username = user?['username']?.toString() ?? 'developer';

    final projects = ref.watch(projectsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'DevShow',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Profile',
            onPressed: () => context.go('/profile'),
            icon: const Icon(Icons.person_outline_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(projectsProvider);
          await ref.read(projectsProvider.future);
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          children: [
            Text(
              'WORKSPACE',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.6,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              username,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -1,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              'Your developer workspace.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 24),

            // Stats
            projects.when(
              loading: () => const _StatsPlaceholder(),
              error: (_, _) => const _StatsPlaceholder(),
              data: (items) {
                final published =
                    items.where((project) => project.published).length;

                final views = items.fold<int>(
                  0,
                  (sum, project) => sum + project.viewCount,
                );

                return Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: StatItem(
                          value: '${items.length}',
                          label: 'Projects',
                        ),
                      ),
                      Expanded(
                        child: StatItem(
                          value: '$published',
                          label: 'Published',
                        ),
                      ),
                      Expanded(
                        child: StatItem(
                          value: '$views',
                          label: 'Views',
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 32),

            SectionHeader(
              title: 'Your projects',
              action: 'View all',
              onAction: () => context.go('/projects'),
            ),

            const SizedBox(height: 12),

            projects.when(
              loading: () => const _ProjectLoadingCard(),
              error: (error, _) => _ProjectError(
                onRetry: () => ref.invalidate(projectsProvider),
              ),
              data: (items) {
                if (items.isEmpty) {
                  return _EmptyProjects(
                    onCreate: () => context.go('/projects/create'),
                  );
                }

                return Column(
                  children: items
                      .take(3)
                      .map(
                        (project) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: ProjectCard(project: project),
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsPlaceholder extends StatelessWidget {
  const _StatsPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}

class _ProjectLoadingCard extends StatelessWidget {
  const _ProjectLoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}

class _ProjectError extends StatelessWidget {
  final VoidCallback onRetry;

  const _ProjectError({
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
        ),
      ),
      child: Column(
        children: [
          const Icon(Icons.cloud_off_outlined),
          const SizedBox(height: 10),
          const Text('Could not load projects'),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: onRetry,
            child: const Text('Try again'),
          ),
        ],
      ),
    );
  }
}

class _EmptyProjects extends StatelessWidget {
  final VoidCallback onCreate;

  const _EmptyProjects({
    required this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
        ),
      ),
      child: Column(
        children: [
          const Icon(Icons.code_off_rounded, size: 32),
          const SizedBox(height: 12),
          const Text(
            'No projects yet',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            'Start building your developer showcase.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onCreate,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Create project'),
          ),
        ],
      ),
    );
  }
}