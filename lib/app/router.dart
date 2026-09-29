import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/widgets/devshow_shell.dart';
import '../features/auth/login_page.dart';
import '../features/auth/register_page.dart';
import '../features/home/home_page.dart';
import '../features/projects/project_detail_page.dart';
import '../features/projects/project_editor_page.dart' as editor;
import '../features/projects/projects_page.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/projects/create',
      builder: (context, state) {
        return const editor.ProjectEditorPage(
          key: ValueKey('create-project'),
        );
      },
    ),

    GoRoute(
      path: '/projects/:id/edit',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);

        return editor.ProjectEditorPage(
          key: ValueKey('edit-project-$id'),
          projectId: id,
        );
      },
    ),

    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),

    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),

    ShellRoute(
      builder: (context, state, child) {
        return DevShowShell(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomePage(),
        ),

        GoRoute(
          path: '/projects',
          builder: (context, state) => const ProjectsPage(),
        ),

        GoRoute(
          path: '/projects/:id',
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);

            return ProjectDetailPage(
              projectId: id,
            );
          },
        ),

        GoRoute(
          path: '/profile',
          builder: (context, state) => const Scaffold(
            body: Center(
              child: Text('Profile'),
            ),
          ),
        ),
      ],
    ),
  ],
);
