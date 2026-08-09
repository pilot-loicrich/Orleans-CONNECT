import 'package:flutter/foundation.dart';

import '../../models/business.dart';
import '../../models/news_article.dart';
import '../../models/user_profile.dart';

/// Détient le profil utilisateur en mémoire et notifie l'UI à chaque
/// changement de préférences. Les écrans de recommandations écoutent ce
/// contrôleur pour se recalculer automatiquement.
class ProfileController extends ChangeNotifier {
  ProfileController([UserProfile? initial])
      : _profile = initial ?? UserProfile.demo;

  UserProfile _profile;
  UserProfile get profile => _profile;

  void toggleBusinessInterest(BusinessCategory category) {
    final next = {..._profile.interestCategories};
    if (!next.add(category)) next.remove(category);
    _profile = _profile.copyWith(interestCategories: next);
    notifyListeners();
  }

  void toggleNewsInterest(NewsCategory category) {
    final next = {..._profile.newsInterests};
    if (!next.add(category)) next.remove(category);
    _profile = _profile.copyWith(newsInterests: next);
    notifyListeners();
  }

  void setHomeDistrict(String district) {
    _profile = _profile.copyWith(homeDistrict: district);
    notifyListeners();
  }
}
