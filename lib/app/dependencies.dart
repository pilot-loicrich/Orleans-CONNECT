import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../data/repositories/business_repository.dart';
import '../data/repositories/mobility_repository.dart';
import '../data/repositories/news_repository.dart';
import '../data/repositories/recommendation_engine.dart';
import '../features/profile/profile_controller.dart';

/// Regroupe les dépendances de l'application (dépôts, moteurs, contrôleurs)
/// et les rend accessibles à tout l'arbre de widgets via Provider.
///
/// Point d'entrée unique pour l'injection : pour brancher un vrai backend,
/// il suffira de remplacer ici les implémentations de dépôts.
class AppDependencies extends StatelessWidget {
  const AppDependencies({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<NewsRepository>(create: (_) => const NewsRepository()),
        Provider<BusinessRepository>(
          create: (_) => const BusinessRepository(),
        ),
        Provider<MobilityRepository>(create: (_) => MobilityRepository()),
        Provider<RecommendationEngine>(
          create: (_) => const RecommendationEngine(),
        ),
        ChangeNotifierProvider<ProfileController>(
          create: (_) => ProfileController(),
        ),
      ],
      child: child,
    );
  }
}
