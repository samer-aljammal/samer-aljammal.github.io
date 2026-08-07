import 'package:flutter/material.dart';

import '../../../core/responsive/breakpoints.dart';
import '../../../core/widgets/section_heading.dart';
import '../../../core/widgets/section_shell.dart';
import '../domain/entities/project.dart';
import 'widgets/project_showcase.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({required this.projects, super.key});

  final List<Project> projects;

  @override
  Widget build(BuildContext context) {
    final double gap = context.responsive<double>(
      mobile: 104,
      tablet: 132,
      desktop: 160,
    );

    return SectionShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeading(
            index: '02',
            label: 'Work',
            lines: ['Shipped, not', 'sketched.'],
            trailing:
                'Messaging, personal finance, food delivery, commerce and '
                'marketplace. Every screen below is the real application. '
                'Hover a device to look closer.',
          ),
          SizedBox(height: gap * 0.8),

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
