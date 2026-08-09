import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../data/repositories/business_repository.dart';
import '../../models/business.dart';
import '../../shared/widgets/async_view.dart';
import 'widgets/business_card.dart';

/// Fiche détaillée d'un commerce.
class BusinessDetailScreen extends StatelessWidget {
  const BusinessDetailScreen({required this.businessId, super.key});

  final String businessId;

  @override
  Widget build(BuildContext context) {
    final repo = context.read<BusinessRepository>();

    return Scaffold(
      appBar: AppBar(title: const Text('Fiche commerce')),
      body: AsyncView<Business?>(
        future: repo.fetchById(businessId),
        isEmpty: (data) => data == null,
        emptyMessage: 'Commerce introuvable.',
        builder: (context, business) {
          final b = business!;
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      gradient: AppColors.brandGradient,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      businessIcon(b.category),
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          b.name,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          b.category.label,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Icon(Icons.star, color: AppColors.orange, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    b.rating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '· ${b.reviewCount} avis',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const Divider(height: 32),
              Text(b.description, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 20),
              _InfoRow(icon: Icons.place_outlined, text: b.address),
              _InfoRow(icon: Icons.map_outlined, text: 'Quartier ${b.district}'),
              if (b.phone != null)
                _InfoRow(icon: Icons.phone_outlined, text: b.phone!),
              if (b.website != null)
                _InfoRow(icon: Icons.language, text: b.website!),
              if (b.tags.isNotEmpty) ...[
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final tag in b.tags) Chip(label: Text(tag)),
                  ],
                ),
              ],
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _snack(context, 'Itinéraire (à venir)'),
                      icon: const Icon(Icons.directions),
                      label: const Text('Itinéraire'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _snack(context, 'Appel (à venir)'),
                      icon: const Icon(Icons.call),
                      label: const Text('Appeler'),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  void _snack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.slate),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
