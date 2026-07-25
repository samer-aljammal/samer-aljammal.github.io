import '../entities/project.dart';

abstract interface class ProjectsRepository {
  /// Projects in display order.
  List<Project> getProjects();
}
