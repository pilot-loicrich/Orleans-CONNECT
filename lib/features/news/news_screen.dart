import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/news_repository.dart';
import '../../models/news_article.dart';
import '../../shared/widgets/async_view.dart';
import '../../shared/widgets/brand_mark.dart';
import 'widgets/news_card.dart';

/// Fil d'actualité local : événements, culture, vie municipale, alertes.
class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  NewsCategory? _filter;

  @override
  Widget build(BuildContext context) {
    final repo = context.read<NewsRepository>();

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: const BrandMark(),
        actions: [
          IconButton(
            tooltip: 'Mon profil',
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      body: Column(
        children: [
          _CategoryFilter(
            selected: _filter,
            onChanged: (c) => setState(() => _filter = c),
          ),
          Expanded(
            child: AsyncView<List<NewsArticle>>(
              future: repo.fetchNews(category: _filter),
              isEmpty: (data) => data.isEmpty,
              emptyMessage: 'Aucune actualité dans cette rubrique.',
              builder: (context, articles) => ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                itemCount: articles.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, i) => NewsCard(
                  article: articles[i],
                  onTap: () => context.push('/news/${articles[i].id}'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryFilter extends StatelessWidget {
  const _CategoryFilter({required this.selected, required this.onChanged});

  final NewsCategory? selected;
  final ValueChanged<NewsCategory?> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _chip(context, label: 'Tout', value: null),
          for (final c in NewsCategory.values)
            _chip(context, label: c.label, value: c),
        ],
      ),
    );
  }

  Widget _chip(
    BuildContext context, {
    required String label,
    required NewsCategory? value,
  }) {
    final isSelected = selected == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onChanged(value),
      ),
    );
  }
}
