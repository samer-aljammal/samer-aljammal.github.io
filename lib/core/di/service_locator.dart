import 'package:flutter/foundation.dart';

import '../../features/profile/data/local_profile_repository.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/projects/data/local_projects_repository.dart';
import '../../features/projects/domain/repositories/projects_repository.dart';

/// Composition root.
///
/// A static locator rather than a DI package: the site has exactly two
/// dependencies and no scopes, so anything heavier would be ceremony. Widgets
/// depend on the abstract types, so tests can [override] with fakes.
abstract final class ServiceLocator {
  const ServiceLocator._();

  static ProfileRepository _profile = const LocalProfileRepository();
  static ProjectsRepository _projects = const LocalProjectsRepository();

  static ProfileRepository get profile => _profile;
  static ProjectsRepository get projects => _projects;

  @visibleForTesting
  static void override({
    ProfileRepository? profile,
    ProjectsRepository? projects,
  }) {
    if (profile != null) _profile = profile;
    if (projects != null) _projects = projects;
  }

  @visibleForTesting
  static void reset() {
    _profile = const LocalProfileRepository();
    _projects = const LocalProjectsRepository();
  }
}
