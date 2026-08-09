import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/date_format.dart';
import '../../data/repositories/news_repository.dart';
import '../../models/news_article.dart';
import '../../shared/widgets/async_view.dart';
import 'widgets/news_card.dart';

/// Vue détaillée d'une actualité.
class NewsDetailScreen extends StatelessWidget {
  const NewsDetailScreen({required this.articleId, super.key});

  final String articleId;

  @override
  Widget build(BuildContext context) {
    final repo = context.read<NewsRepository>();

    return Scaffold(
      appBar: AppBar(title: const Text('Actualité')),
      body: AsyncView<NewsArticle?>(
        future: repo.fetchById(articleId),
        isEmpty: (data) => data == null,
        emptyMessage: 'Article introuvable.',
        builder: (context, article) {
          final a = article!;
          final color = categoryColor(a.category);
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  a.category.label,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(a.title, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.schedule,
                    size: 15,
                    color: AppColors.slate,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${DateFormatFr.relative(a.publishedAt)} · ${a.author}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              if (a.location != null) ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.place_outlined,
                      size: 15,
                      color: AppColors.slate,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      a.location!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
              const Divider(height: 32),
              Text(a.summary, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 16),
              Text(a.body, style: Theme.of(context).textTheme.bodyMedium),
            ],
          );
        },
      ),
    );
  }
}
