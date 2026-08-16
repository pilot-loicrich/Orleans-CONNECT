import '../../models/news_article.dart';
import '../mock_data.dart';

/// Accès aux actualités locales.
///
/// Implémentation MVP : renvoie les données mockées. Pour brancher une API,
/// remplacer le corps des méthodes par des appels HTTP (le reste de l'app
/// dépend uniquement de cette interface).
class NewsRepository {
  const NewsRepository();

  Future<List<NewsArticle>> fetchNews({NewsCategory? category}) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final items = [...MockData.news]
      ..sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
    if (category == null) return items;
    return items.where((a) => a.category == category).toList();
  }

  Future<NewsArticle?> fetchById(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    for (final a in MockData.news) {
      if (a.id == id) return a;
    }
    return null;
  }
}
