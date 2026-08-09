import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../models/business.dart';
import '../../models/news_article.dart';
import 'profile_controller.dart';

/// Écran de profil : centres d'intérêt et quartier. Chaque changement met à
/// jour le [ProfileController], ce qui recalcule l'onglet « Pour vous ».
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const _districts = [
    'Centre-ville',
    'Cathédrale',
    'Bourgogne',
    'Carmes',
    'Bannier',
    'Loire',
    'La Source',
    'Saint-Marceau',
  ];

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ProfileController>();
    final profile = controller.profile;

    return Scaffold(
      appBar: AppBar(title: const Text('Mon profil')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.navy.withValues(alpha: 0.08),
                child: const Icon(Icons.person, color: AppColors.navy),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.displayName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    'Quartier ${profile.homeDistrict}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
          const Divider(height: 36),
          _SectionLabel('Mon quartier'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final d in _districts)
                ChoiceChip(
                  label: Text(d),
                  selected: profile.homeDistrict == d,
                  onSelected: (_) => controller.setHomeDistrict(d),
                ),
            ],
          ),
          const SizedBox(height: 28),
          _SectionLabel('Ce qui m\'intéresse'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final c in BusinessCategory.values)
                FilterChip(
                  label: Text(c.label),
                  selected: profile.interestCategories.contains(c),
                  onSelected: (_) => controller.toggleBusinessInterest(c),
                ),
            ],
          ),
          const SizedBox(height: 28),
          _SectionLabel('Rubriques d\'actualité suivies'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final c in NewsCategory.values)
                FilterChip(
                  label: Text(c.label),
                  selected: profile.newsInterests.contains(c),
                  onSelected: (_) => controller.toggleNewsInterest(c),
                ),
            ],
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.mist,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppColors.slate),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Vos préférences affinent l\'onglet « Pour vous ». '
                    'Elles restent sur votre appareil (MVP).',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.ink,
        fontWeight: FontWeight.w800,
        fontSize: 15,
      ),
    );
  }
}
