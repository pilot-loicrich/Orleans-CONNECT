import '../../models/business.dart';
import '../mock_data.dart';

/// Accès à l'annuaire des commerces et services de proximité.
class BusinessRepository {
  const BusinessRepository();

  Future<List<Business>> fetchAll({
    BusinessCategory? category,
    String? query,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    var items = [...MockData.businesses];

    if (category != null) {
      items = items.where((b) => b.category == category).toList();
    }
    if (query != null && query.trim().isNotEmpty) {
      final q = query.toLowerCase().trim();
      items = items.where((b) {
        return b.name.toLowerCase().contains(q) ||
            b.description.toLowerCase().contains(q) ||
            b.district.toLowerCase().contains(q) ||
            b.tags.any((t) => t.toLowerCase().contains(q));
      }).toList();
    }

    items.sort((a, b) => b.rating.compareTo(a.rating));
    return items;
  }

  Future<Business?> fetchById(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    for (final b in MockData.businesses) {
      if (b.id == id) return b;
    }
    return null;
  }
}
