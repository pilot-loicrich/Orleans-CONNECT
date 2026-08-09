/// Catégories du fil d'actualité local.
enum NewsCategory {
  evenement('Événement'),
  culture('Culture'),
  sport('Sport'),
  municipal('Vie municipale'),
  commerce('Commerce'),
  alerte('Alerte');

  const NewsCategory(this.label);
  final String label;
}

/// Un article / une actualité du fil local d'Orléans.
class NewsArticle {
  const NewsArticle({
    required this.id,
    required this.title,
    required this.summary,
    required this.body,
    required this.category,
    required this.publishedAt,
    required this.author,
    this.location,
    this.imageUrl,
  });

  final String id;
  final String title;
  final String summary;
  final String body;
  final NewsCategory category;
  final DateTime publishedAt;
  final String author;
  final String? location;
  final String? imageUrl;

  factory NewsArticle.fromJson(Map<String, dynamic> json) => NewsArticle(
        id: json['id'] as String,
        title: json['title'] as String,
        summary: json['summary'] as String,
        body: json['body'] as String,
        category: NewsCategory.values.byName(json['category'] as String),
        publishedAt: DateTime.parse(json['publishedAt'] as String),
        author: json['author'] as String,
        location: json['location'] as String?,
        imageUrl: json['imageUrl'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'summary': summary,
        'body': body,
        'category': category.name,
        'publishedAt': publishedAt.toIso8601String(),
        'author': author,
        'location': location,
        'imageUrl': imageUrl,
      };
}
