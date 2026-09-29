import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProjectEditorPage extends ConsumerStatefulWidget {
  final int? projectId;

  const ProjectEditorPage({
    super.key,
    this.projectId,
  });

  @override
  ConsumerState<ProjectEditorPage> createState() =>
      _ProjectEditorPageState();
}

class _ProjectEditorPageState
    extends ConsumerState<ProjectEditorPage> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _taglineController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _technologiesController = TextEditingController();
  final _githubController = TextEditingController();
  final _demoController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _taglineController.dispose();
    _descriptionController.dispose();
    _technologiesController.dispose();
    _githubController.dispose();
    _demoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final editing = widget.projectId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          editing ? 'Edit Project' : 'New Project',
          style: const TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
          children: [
            Text(
              'PROJECT DETAILS',
              style: theme.textTheme.labelMedium?.copyWith(
                letterSpacing: 1.3,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Project title',
                hintText: 'My awesome project',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Project title is required';
                }
                return null;
              },
            ),

            const SizedBox(height: 14),

            TextFormField(
              controller: _taglineController,
              decoration: const InputDecoration(
                labelText: 'Tagline',
                hintText: 'A short description of your project',
              ),
            ),

            const SizedBox(height: 14),

            TextFormField(
              controller: _descriptionController,
              maxLines: 8,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Markdown supported',
                alignLabelWithHint: true,
              ),
            ),

            const SizedBox(height: 28),

            Text(
              'TECHNOLOGIES',
              style: theme.textTheme.labelMedium?.copyWith(
                letterSpacing: 1.3,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _technologiesController,
              decoration: const InputDecoration(
                labelText: 'Technologies',
                hintText: 'Python, FastAPI, PostgreSQL, React',
              ),
            ),

            const SizedBox(height: 28),

            Text(
              'LINKS',
              style: theme.textTheme.labelMedium?.copyWith(
                letterSpacing: 1.3,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _githubController,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                labelText: 'GitHub URL',
                hintText: 'https://github.com/...',
              ),
            ),

            const SizedBox(height: 14),

            TextFormField(
              controller: _demoController,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                labelText: 'Live Demo URL',
                hintText: 'https://...',
              ),
            ),

            const SizedBox(height: 32),

            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save_outlined),
              label: Text(
                editing ? 'Save Changes' : 'Create Project',
              ),
            ),

            const SizedBox(height: 10),

            OutlinedButton(
              onPressed: () => context.pop(),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final technologies = _technologiesController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    try {
      final repository = ref.read(projectRepositoryProvider);

      if (widget.projectId == null) {
        await repository.createProject(
          title: _titleController.text.trim(),
          tagline: _taglineController.text.trim(),
          description: _descriptionController.text.trim(),
          technologies: technologies,
          githubUrl: _githubController.text.trim().isEmpty
              ? null
              : _githubController.text.trim(),
          demoUrl: _demoController.text.trim().isEmpty
              ? null
              : _demoController.text.trim(),
        );
      } else {
        await repository.updateProject(
          widget.projectId!,
          title: _titleController.text.trim(),
          tagline: _taglineController.text.trim(),
          description: _descriptionController.text.trim(),
          technologies: technologies,
          githubUrl: _githubController.text.trim().isEmpty
              ? null
              : _githubController.text.trim(),
          demoUrl: _demoController.text.trim().isEmpty
              ? null
              : _demoController.text.trim(),
        );
      }

      ref.invalidate(projectsProvider);

      if (mounted) {
        context.go('/projects');
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save project: $e'),
        ),
      );
    }
  }
}
