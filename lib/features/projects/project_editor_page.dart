import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/project.dart';
import 'project_provider.dart';

class ProjectEditorPage extends ConsumerStatefulWidget {
  final int? projectId;

  const ProjectEditorPage({super.key, this.projectId});

  @override
  ConsumerState<ProjectEditorPage> createState() => _ProjectEditorPageState();
}

class _ProjectEditorPageState extends ConsumerState<ProjectEditorPage> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _taglineController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _technologiesController = TextEditingController();
  final _githubController = TextEditingController();
  final _demoController = TextEditingController();

  final List<XFile> _images = [];

  bool _saving = false;
  bool _loadingProject = false;

  @override
  void initState() {
    super.initState();

    if (widget.projectId != null) {
      _loadProject();
    }
  }

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

  Future<void> _loadProject() async {
    setState(() {
      _loadingProject = true;
    });

    try {
      final project = await ref
          .read(projectRepositoryProvider)
          .getProject(widget.projectId!);

      if (!mounted) return;

      _titleController.text = project.title;
      _taglineController.text = project.tagline;
      _descriptionController.text = project.description ?? '';
      _technologiesController.text = project.technologies.join(', ');
      _githubController.text = project.githubUrl ?? '';
      _demoController.text = project.demoUrl ?? '';
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to load project: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _loadingProject = false;
        });
      }
    }
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();

    final selected = await picker.pickMultiImage(imageQuality: 85);

    if (!mounted) return;

    setState(() {
      _images
        ..clear()
        ..addAll(selected.take(5));
    });
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _saving = true;
    });

    final technologies = _technologiesController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    try {
      final repository = ref.read(projectRepositoryProvider);

      late final Project project;

      if (widget.projectId == null) {
        project = await repository.createProject(
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
        project = await repository.updateProject(
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

      for (final image in _images) {
        await repository.uploadMedia(project.id, image.path);
      }

      ref.invalidate(projectsProvider);
      ref.invalidate(projectDetailProvider(project.id));

      if (!mounted) return;

      context.go('/projects');
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _saving = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to save project: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final editing = widget.projectId != null;

    if (_loadingProject) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            editing ? 'Edit Project' : 'New Project',
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          editing ? 'Edit Project' : 'New Project',
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        leading: IconButton(
          onPressed: _saving ? null : () => context.pop(),
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
              enabled: !_saving,
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
              enabled: !_saving,
              decoration: const InputDecoration(
                labelText: 'Tagline',
                hintText: 'A short description of your project',
              ),
            ),

            const SizedBox(height: 14),

            TextFormField(
              controller: _descriptionController,
              enabled: !_saving,
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
              enabled: !_saving,
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
              enabled: !_saving,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                labelText: 'GitHub URL',
                hintText: 'https://github.com/...',
              ),
            ),

            const SizedBox(height: 14),

            TextFormField(
              controller: _demoController,
              enabled: !_saving,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                labelText: 'Live Demo URL',
                hintText: 'https://...',
              ),
            ),

            const SizedBox(height: 28),

            Text(
              'SCREENSHOTS',
              style: theme.textTheme.labelMedium?.copyWith(
                letterSpacing: 1.3,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 12),

            OutlinedButton.icon(
              onPressed: _saving ? null : _pickImages,
              icon: const Icon(Icons.add_photo_alternate_outlined),
              label: Text(
                _images.isEmpty
                    ? 'Add screenshots'
                    : '${_images.length}/5 selected',
              ),
            ),

            if (_images.isNotEmpty) ...[
              const SizedBox(height: 12),
              SizedBox(
                height: 110,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _images.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            File(_images[index].path),
                            width: 150,
                            height: 110,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 6,
                          right: 6,
                          child: Material(
                            color: Colors.black54,
                            shape: const CircleBorder(),
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: _saving ? null : () => _removeImage(index),
                              child: const Padding(
                                padding: EdgeInsets.all(5),
                                child: Icon(
                                  Icons.close_rounded,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],

            const SizedBox(height: 32),

            FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save_outlined),
              label: Text(
                _saving
                    ? 'Saving...'
                    : editing
                    ? 'Save Changes'
                    : 'Create Project',
              ),
            ),

            const SizedBox(height: 10),

            OutlinedButton(
              onPressed: _saving ? null : () => context.pop(),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
