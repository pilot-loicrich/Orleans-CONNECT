import 'package:flutter_test/flutter_test.dart';
import 'package:orleans_connect/data/mock_data.dart';
import 'package:orleans_connect/data/repositories/recommendation_engine.dart';
import 'package:orleans_connect/models/business.dart';
import 'package:orleans_connect/models/news_article.dart';
import 'package:orleans_connect/models/recommendation.dart';
import 'package:orleans_connect/models/user_profile.dart';

void main() {
  const engine = RecommendationEngine();

  List<Recommendation> recommendFor(UserProfile profile, {int limit = 6}) =>
      engine.recommend(
        profile: profile,
        businesses: MockData.businesses,
        news: MockData.news,
        rides: MockData.rides,
        limit: limit,
      );

  double bestScore(
    List<Recommendation> recos,
    bool Function(Recommendation) where,
  ) {
    final matching = recos.where(where).map((r) => r.score);
    return matching.isEmpty ? 0 : matching.reduce((a, b) => a > b ? a : b);
  }

  test('respecte la limite et trie par score décroissant', () {
    final recos = recommendFor(UserProfile.demo, limit: 5);

    expect(recos.length, lessThanOrEqualTo(5));
    for (var i = 1; i < recos.length; i++) {
      expect(recos[i - 1].score, greaterThanOrEqualTo(recos[i].score));
    }
  });

  test('les scores restent bornés dans [0, 1]', () {
    for (final r in recommendFor(UserProfile.demo)) {
      expect(r.score, inInclusiveRange(0.0, 1.0));
    }
  });

  test('un centre d\'intérêt supplémentaire fait remonter la catégorie', () {
    const base = UserProfile(
      displayName: 'Test',
      homeDistrict: 'Centre-ville',
      interestCategories: {},
      newsInterests: {},
    );
    final withSante = base.copyWith(
      interestCategories: {BusinessCategory.sante},
    );

    bool isSante(Recommendation r) =>
        r.subtitle.contains(BusinessCategory.sante.label);

    final before = bestScore(recommendFor(base), isSante);
    final after = bestScore(recommendFor(withSante), isSante);

    expect(after, greaterThan(before));
  });

  test('chaque recommandation porte une explication non vide', () {
    for (final r in recommendFor(UserProfile.demo)) {
      expect(r.reason, isNotEmpty);
    }
  });

  test('suivre une rubrique la met en avant', () {
    const base = UserProfile(
      displayName: 'Test',
      homeDistrict: 'Centre-ville',
      interestCategories: {},
      newsInterests: {},
    );
    final withAlerte = base.copyWith(newsInterests: {NewsCategory.alerte});

    final alerte = recommendFor(withAlerte).where(
      (r) => r.subtitle.contains(NewsCategory.alerte.label),
    );
    expect(alerte, isNotEmpty);
    expect(alerte.first.score, greaterThan(0));
  });
}
