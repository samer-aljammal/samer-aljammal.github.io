import 'package:flutter/material.dart';

import '../../../core/responsive/breakpoints.dart';
import '../../../core/widgets/section_shell.dart';
import '../../../core/widgets/section_title.dart';
import '../domain/entities/project.dart';
import 'widgets/project_showcase.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({required this.projects, super.key});

  final List<Project> projects;

  @override
  Widget build(BuildContext context) {
    final double gap = context.responsive(mobile: 96, tablet: 120, desktop: 140);

    return SectionShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            eyebrow: '02 — Work',
            title: 'Things I have',
            highlight: 'shipped.',
            subtitle:
                'Messaging, personal finance, food delivery, e-commerce and '
                'marketplace apps. Every screen below is the real thing — hover '
                'a phone to take a closer look.',
          ),
          SizedBox(height: gap * 0.72),

          for (final (int index, Project project) in projects.indexed)
            Padding(
              padding: EdgeInsets.only(
                bottom: index == projects.length - 1 ? 0 : gap,
              ),
              child: ProjectShowcase(project: project, index: index),
            ),
        ],
      ),
    );
  }
}
