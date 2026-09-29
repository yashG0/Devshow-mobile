@override
void initState() {
  super.initState();

  if (widget.projectId != null) {
    _loadProject();
  }
}

Future<void> _loadProject() async {
  try {
    final project = await ref
        .read(projectRepositoryProvider)
        .getProject(widget.projectId!);

    if (!mounted) return;

    _titleController.text = project.title;
    _taglineController.text = project.tagline;
    _descriptionController.text = project.description ?? '';
    _technologiesController.text =
        project.technologies.join(', ');
    _githubController.text = project.githubUrl ?? '';
    _demoController.text = project.demoUrl ?? '';

    setState(() {});
  } catch (e) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Failed to load project: $e'),
      ),
    );
  }
}