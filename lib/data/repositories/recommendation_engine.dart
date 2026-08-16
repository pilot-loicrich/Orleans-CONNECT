import '../../models/business.dart';
import '../../models/news_article.dart';
import '../../models/recommendation.dart';
import '../../models/ride.dart';
import '../../models/user_profile.dart';

/// Moteur de recommandations *content-based* (basé sur le contenu).
///
/// Principe (volontairement simple et explicable pour le MVP) :
/// on attribue à chaque candidat un score dans [0, 1] combinant plusieurs
/// signaux pondérés, puis on trie et on ne garde que le haut du panier.
/// Chaque suggestion embarque une [Recommendation.reason] lisible, pour que
/// l'utilisateur comprenne *pourquoi* on lui propose ceci.
///
/// Signaux actuels :
///  - correspondance de catégorie avec les centres d'intérêt (poids fort) ;
///  - proximité (même quartier que l'utilisateur) ;
///  - qualité (note moyenne pour les commerces) ;
///  - fraîcheur / imminence (récence d'une actu, départ proche d'un trajet).
///
/// Cette structure pondérée se prête ensuite naturellement à un passage vers
/// un modèle appris (collaboratif ou hybride) côté backend Data/IA.
class RecommendationEngine {
  const RecommendationEngine();

  // Pondérations des signaux (somme non normalisée ; on borne le score à 1).
  static const double _wCategory = 0.55;
  static const double _wDistrict = 0.20;
  static const double _wQuality = 0.15;
  static const double _wFreshness = 0.20;

  List<Recommendation> recommend({
    required UserProfile profile,
    required List<Business> businesses,
    required List<NewsArticle> news,
    required List<Ride> rides,
    int limit = 6,
  }) {
    final results = <Recommendation>[
      ..._scoreBusinesses(profile, businesses),
      ..._scoreNews(profile, news),
      ..._scoreRides(profile, rides),
    ]..sort((a, b) => b.score.compareTo(a.score));

    return results.take(limit).toList();
  }

  Iterable<Recommendation> _scoreBusinesses(
    UserProfile profile,
    List<Business> businesses,
  ) {
    return businesses.map((b) {
      final reasons = <String>[];
      var score = 0.0;

      if (profile.interestCategories.contains(b.category)) {
        score += _wCategory;
        reasons.add('correspond à vos centres d\'intérêt '
            '(${b.category.label})');
      }
      if (b.district == profile.homeDistrict) {
        score += _wDistrict;
        reasons.add('proche de chez vous (${b.district})');
      }
      score += _wQuality * (b.rating / 5.0);
      if (b.rating >= 4.6) {
        reasons.add('très bien noté (${b.rating.toStringAsFixed(1)}/5)');
      }

      return Recommendation(
        id: 'rec-b-${b.id}',
        kind: RecommendationKind.commerce,
        title: b.name,
        subtitle: '${b.category.label} · ${b.district}',
        reason: _joinReasons(reasons),
        score: score.clamp(0.0, 1.0),
        targetId: b.id,
      );
    });
  }

  Iterable<Recommendation> _scoreNews(
    UserProfile profile,
    List<NewsArticle> news,
  ) {
    final now = DateTime(2026, 8, 9, 9, 0);
    return news.map((a) {
      final reasons = <String>[];
      var score = 0.0;

      if (profile.newsInterests.contains(a.category)) {
        score += _wCategory;
        reasons.add('rubrique suivie (${a.category.label})');
      }
      // Fraîcheur : décroît sur 48 h.
      final ageHours = now.difference(a.publishedAt).inHours.abs();
      final freshness = (1.0 - (ageHours / 48.0)).clamp(0.0, 1.0);
      score += _wFreshness * freshness;
      if (freshness > 0.7) reasons.add('publié récemment');

      return Recommendation(
        id: 'rec-n-${a.id}',
        kind: RecommendationKind.evenement,
        title: a.title,
        subtitle: a.category.label,
        reason: _joinReasons(reasons),
        score: score.clamp(0.0, 1.0),
        targetId: a.id,
      );
    });
  }

  Iterable<Recommendation> _scoreRides(
    UserProfile profile,
    List<Ride> rides,
  ) {
    final now = DateTime(2026, 8, 9, 9, 0);
    return rides.map((r) {
      final reasons = <String>[];
      var score = 0.0;

      if (r.origin.toLowerCase().contains(
            profile.homeDistrict.toLowerCase(),
          )) {
        score += _wDistrict;
        reasons.add('départ près de chez vous');
      }
      // Imminence : un départ dans les 2 h est mis en avant.
      final minutesToDeparture = r.departureTime.difference(now).inMinutes;
      if (minutesToDeparture > 0 && minutesToDeparture <= 120) {
        score += _wFreshness;
        reasons.add('départ imminent');
      }
      if (r.recurring) {
        score += 0.1;
        reasons.add('trajet régulier');
      }

      return Recommendation(
        id: 'rec-r-${r.id}',
        kind: RecommendationKind.trajet,
        title: '${r.origin} → ${r.destination}',
        subtitle: 'Covoiturage · ${r.seatsAvailable} place(s)',
        reason: _joinReasons(reasons),
        score: score.clamp(0.0, 1.0),
        targetId: r.id,
      );
    });
  }

  String _joinReasons(List<String> reasons) {
    if (reasons.isEmpty) return 'Sélection découverte à Orléans';
    final capped = reasons.take(2).join(', ');
    return 'Parce que $capped.';
  }
}
