/// Un type de suggestion renvoyée par le moteur de recommandations.
enum RecommendationKind {
  evenement('Événement'),
  commerce('Commerce'),
  trajet('Trajet'),
  lieu('Lieu à découvrir');

  const RecommendationKind(this.label);
  final String label;
}

/// Une recommandation personnalisée présentée à l'utilisateur.
///
/// [score] (0.0 – 1.0) est produit par [RecommendationEngine] à partir des
/// centres d'intérêt de l'utilisateur. Il sert à trier et à expliquer la
/// suggestion ("Pourquoi ceci ?").
class Recommendation {
  const Recommendation({
    required this.id,
    required this.kind,
    required this.title,
    required this.subtitle,
    required this.reason,
    required this.score,
    this.targetId,
  });

  final String id;
  final RecommendationKind kind;
  final String title;
  final String subtitle;
  final String reason; // explication lisible du "pourquoi"
  final double score;
  final String? targetId; // id de l'entité liée (commerce, actu, trajet…)
}
