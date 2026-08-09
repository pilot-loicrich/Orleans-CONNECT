/// Catégories de l'annuaire des commerces et services de proximité.
enum BusinessCategory {
  restaurant('Restauration'),
  boulangerie('Boulangerie'),
  cafe('Café / Bar'),
  commerce('Commerce'),
  sante('Santé'),
  artisan('Artisan'),
  service('Service'),
  culture('Culture / Loisirs');

  const BusinessCategory(this.label);
  final String label;
}

/// Un commerce ou service de proximité référencé dans l'annuaire.
class Business {
  const Business({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.address,
    required this.district,
    required this.rating,
    required this.reviewCount,
    this.phone,
    this.website,
    this.openNow = true,
    this.tags = const [],
  });

  final String id;
  final String name;
  final BusinessCategory category;
  final String description;
  final String address;
  final String district; // Quartier d'Orléans
  final double rating; // 0.0 – 5.0
  final int reviewCount;
  final String? phone;
  final String? website;
  final bool openNow;
  final List<String> tags;

  factory Business.fromJson(Map<String, dynamic> json) => Business(
        id: json['id'] as String,
        name: json['name'] as String,
        category: BusinessCategory.values.byName(json['category'] as String),
        description: json['description'] as String,
        address: json['address'] as String,
        district: json['district'] as String,
        rating: (json['rating'] as num).toDouble(),
        reviewCount: json['reviewCount'] as int,
        phone: json['phone'] as String?,
        website: json['website'] as String?,
        openNow: json['openNow'] as bool? ?? true,
        tags: (json['tags'] as List<dynamic>? ?? [])
            .map((e) => e as String)
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category.name,
        'description': description,
        'address': address,
        'district': district,
        'rating': rating,
        'reviewCount': reviewCount,
        'phone': phone,
        'website': website,
        'openNow': openNow,
        'tags': tags,
      };
}
