import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/business.dart';

IconData businessIcon(BusinessCategory c) => switch (c) {
      BusinessCategory.restaurant => Icons.restaurant,
      BusinessCategory.boulangerie => Icons.bakery_dining,
      BusinessCategory.cafe => Icons.local_cafe,
      BusinessCategory.commerce => Icons.shopping_bag,
      BusinessCategory.sante => Icons.local_pharmacy,
      BusinessCategory.artisan => Icons.handyman,
      BusinessCategory.service => Icons.build,
      BusinessCategory.culture => Icons.theater_comedy,
    };

class BusinessCard extends StatelessWidget {
  const BusinessCard({required this.business, required this.onTap, super.key});

  final Business business;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.navy.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  businessIcon(business.category),
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            business.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        _OpenBadge(open: business.openNow),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${business.category.label} · ${business.district}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 15, color: AppColors.orange),
                        const SizedBox(width: 3),
                        Text(
                          business.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: AppColors.ink,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${business.reviewCount} avis)',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OpenBadge extends StatelessWidget {
  const _OpenBadge({required this.open});

  final bool open;

  @override
  Widget build(BuildContext context) {
    final color = open ? AppColors.success : AppColors.slate;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        open ? 'Ouvert' : 'Fermé',
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),
      ),
    );
  }
}
