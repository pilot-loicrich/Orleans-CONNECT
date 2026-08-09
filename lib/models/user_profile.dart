import 'business.dart';
import 'news_article.dart';

/// Profil local de l'utilisateur : centres d'intérêt et quartier.
///
/// Pour le MVP, ces préférences sont conservées en mémoire. Elles alimentent
/// le moteur de recommandations. À terme, elles seront persistées
/// (SharedPreferences) puis synchronisées avec le backend.
class UserProfile {
  const UserProfile({
    required this.displayName,
    required this.homeDistrict,
    required this.interestCategories,
    required this.newsInterests,
  });

  final String displayName;
  final String homeDistrict;

  /// Catégories de commerces qui intéressent l'utilisateur.
  final Set<BusinessCategory> interestCategories;

  /// Rubriques d'actualité suivies.
  final Set<NewsCategory> newsInterests;

  UserProfile copyWith({
    String? displayName,
    String? homeDistrict,
    Set<BusinessCategory>? interestCategories,
    Set<NewsCategory>? newsInterests,
  }) {
    return UserProfile(
      displayName: displayName ?? this.displayName,
      homeDistrict: homeDistrict ?? this.homeDistrict,
      interestCategories: interestCategories ?? this.interestCategories,
      newsInterests: newsInterests ?? this.newsInterests,
    );
  }

  /// Profil par défaut pour démarrer la démo.
  static const UserProfile demo = UserProfile(
    displayName: 'Orléanais·e',
    homeDistrict: 'Centre-ville',
    interestCategories: {
      BusinessCategory.restaurant,
      BusinessCategory.cafe,
      BusinessCategory.culture,
    },
    newsInterests: {
      NewsCategory.evenement,
      NewsCategory.culture,
      NewsCategory.commerce,
    },
  );
}
