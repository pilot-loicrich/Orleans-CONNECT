import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../data/repositories/business_repository.dart';
import '../../data/repositories/mobility_repository.dart';
import '../../data/repositories/news_repository.dart';
import '../../data/repositories/recommendation_engine.dart';
import '../../models/recommendation.dart';
import '../../shared/widgets/async_view.dart';
import '../profile/profile_controller.dart';

/// Écran « Pour vous » : suggestions personnalisées produites par le
/// [RecommendationEngine] à partir du profil utilisateur.
class RecommendationsScreen extends StatelessWidget {
  const RecommendationsScreen({super.key});

  Future<List<Recommendation>> _load(BuildContext context) async {
    final profile = context.read<ProfileController>().profile;
    final engine = context.read<RecommendationEngine>();
    final businesses = await context.read<BusinessRepository>().fetchAll();
    final news = await context.read<NewsRepository>().fetchNews();
    final rides = await context.read<MobilityRepository>().fetchRides();

    return engine.recommend(
      profile: profile,
      businesses: businesses,
      news: news,
      rides: rides,
    );
  }

  @override
  Widget build(BuildContext context) {
    // On observe le profil : toute modification recalcule les suggestions.
    final profile = context.watch<ProfileController>().profile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pour vous'),
        actions: [
          IconButton(
            tooltip: 'Ajuster mes préférences',
            icon: const Icon(Icons.tune),
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      body: AsyncView<List<Recommendation>>(
        // La clé force le recalcul quand le profil change.
        key: ValueKey(profile.hashCode),
        future: _load(context),
        isEmpty: (data) => data.isEmpty,
        emptyMessage: 'Ajoutez des centres d\'intérêt pour voir des '
            'suggestions personnalisées.',
        builder: (context, recos) => ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            _Header(district: profile.homeDistrict),
            const SizedBox(height: 12),
            for (final r in recos)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _RecommendationCard(reco: r),
              ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.district});

  final String district;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: AppColors.brandGradient,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sélectionné pour vous',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'D\'après vos centres d\'intérêt · quartier $district',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.9)),
          ),
        ],
      ),
    );
  }
}

IconData _kindIcon(RecommendationKind k) => switch (k) {
      RecommendationKind.evenement => Icons.event,
      RecommendationKind.commerce => Icons.storefront,
      RecommendationKind.trajet => Icons.directions_car,
      RecommendationKind.lieu => Icons.place,
    };

void _open(BuildContext context, Recommendation r) {
  if (r.targetId == null) return;
  switch (r.kind) {
    case RecommendationKind.commerce:
      context.push('/directory/${r.targetId}');
    case RecommendationKind.evenement:
      context.push('/news/${r.targetId}');
    case RecommendationKind.trajet:
      context.go('/mobility');
    case RecommendationKind.lieu:
      break;
  }
}

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({required this.reco});

  final Recommendation reco;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => _open(context, reco),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.orange.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(_kindIcon(reco.kind), color: AppColors.orange),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reco.title,
                          style: Theme.of(context).textTheme.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          reco.subtitle,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  _MatchBadge(score: reco.score),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.lightbulb_outline,
                    size: 15,
                    color: AppColors.slate,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      reco.reason,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Petit badge affichant le pourcentage de correspondance (le [score] du
/// moteur exprimé de façon lisible).
class _MatchBadge extends StatelessWidget {
  const _MatchBadge({required this.score});

  final double score;

  @override
  Widget build(BuildContext context) {
    final pct = (score * 100).round();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.navy.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$pct %',
        style: const TextStyle(
          color: AppColors.navy,
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
      ),
    );
  }
}
