import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Marque textuelle « Orléans Connect » avec le dégradé signature.
///
/// Placeholder typographique en attendant l'intégration du logo officiel
/// (cathédrale + Loire) dans assets/images.
class BrandMark extends StatelessWidget {
  const BrandMark({this.compact = false, super.key});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: compact ? 28 : 34,
          height: compact ? 28 : 34,
          decoration: BoxDecoration(
            gradient: AppColors.brandGradient,
            borderRadius: BorderRadius.circular(9),
          ),
          child: const Icon(
            Icons.account_balance, // évoque la cathédrale
            color: Colors.white,
            size: 18,
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ORLÉANS',
              style: TextStyle(
                color: AppColors.navy,
                fontWeight: FontWeight.w800,
                fontSize: compact ? 14 : 16,
                letterSpacing: 1.5,
                height: 1,
              ),
            ),
            Text(
              'CONNECT',
              style: TextStyle(
                color: AppColors.orange,
                fontWeight: FontWeight.w600,
                fontSize: compact ? 10 : 11,
                letterSpacing: 3,
                height: 1.2,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
