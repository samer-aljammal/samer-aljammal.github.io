import '../entities/profile.dart';

/// Source of the site's own content.
///
/// An interface over what is currently hardcoded data, so swapping in a CMS,
/// a JSON asset or a Firestore document later touches one implementation and no
/// widgets.
abstract interface class ProfileRepository {
  Profile getProfile();
}
