import '../models/business.dart';
import '../models/news_article.dart';
import '../models/ride.dart';

/// Jeu de données de démonstration pour le MVP.
///
/// Ces données locales permettent de faire tourner et de démontrer
/// l'application sans backend. Chaque dépôt (repository) lit ici ; il suffira
/// de remplacer l'implémentation du dépôt par des appels HTTP pour brancher
/// une vraie API, sans toucher à l'interface.
abstract final class MockData {
  static final DateTime _now = DateTime(2026, 8, 9, 9, 0);

  static final List<NewsArticle> news = [
    NewsArticle(
      id: 'n1',
      title: 'Le Festival de Loire prépare son édition 2026',
      summary:
          'Le plus grand rassemblement européen de marine fluviale revient '
          'sur les quais d\'Orléans avec 700 bateaux attendus.',
      body:
          'Tous les deux ans, le Festival de Loire transforme les quais en '
          'un immense village de mariniers. L\'édition 2026 promet un record '
          'de participation avec des bateaux venus de toute l\'Europe, des '
          'concerts gratuits et un feu d\'artifice sur le fleuve. Les '
          'inscriptions bénévoles ouvrent la semaine prochaine.',
      category: NewsCategory.evenement,
      publishedAt: _now.subtract(const Duration(hours: 3)),
      author: 'Mairie d\'Orléans',
      location: 'Quais de Loire',
    ),
    NewsArticle(
      id: 'n2',
      title: 'Nouvelle exposition au Musée des Beaux-Arts',
      summary:
          'Une rétrospective consacrée aux peintres ligériens ouvre ses '
          'portes ce week-end.',
      body:
          'Le Musée des Beaux-Arts d\'Orléans met à l\'honneur les artistes '
          'ayant peint la Loire du XIXe siècle à nos jours. Entrée gratuite '
          'le premier dimanche du mois.',
      category: NewsCategory.culture,
      publishedAt: _now.subtract(const Duration(hours: 8)),
      author: 'Musée des Beaux-Arts',
      location: 'Place Sainte-Croix',
    ),
    NewsArticle(
      id: 'n3',
      title: 'Marché de producteurs place du Martroi',
      summary:
          'Chaque samedi matin, retrouvez les producteurs locaux au cœur '
          'de la ville.',
      body:
          'Fromages du Loiret, miel de Sologne, légumes de saison : le '
          'marché de producteurs s\'installe place du Martroi tous les '
          'samedis de 8h à 13h. Un rendez-vous incontournable des '
          'circuits courts.',
      category: NewsCategory.commerce,
      publishedAt: _now.subtract(const Duration(days: 1, hours: 2)),
      author: 'Association des commerçants',
      location: 'Place du Martroi',
    ),
    NewsArticle(
      id: 'n4',
      title: 'Travaux sur la ligne A : circulation adaptée',
      summary:
          'Des travaux de maintenance impactent la ligne A du tram ce '
          'week-end.',
      body:
          'La ligne A du tramway sera interrompue entre les stations '
          'De Gaulle et Université samedi de 22h à 2h pour maintenance. '
          'Un service de bus de substitution est mis en place.',
      category: NewsCategory.municipal,
      publishedAt: _now.subtract(const Duration(days: 1, hours: 6)),
      author: 'TAO Orléans',
      location: 'Ligne A',
    ),
    NewsArticle(
      id: 'n5',
      title: 'L\'USO Basket lance sa campagne d\'abonnements',
      summary:
          'Le club phare de la ville ouvre la billetterie pour la nouvelle '
          'saison de Pro B.',
      body:
          'L\'Orléans Loiret Basket dévoile ses tarifs d\'abonnement pour '
          'la saison à venir au Palais des Sports. Des offres familles et '
          'étudiants sont proposées.',
      category: NewsCategory.sport,
      publishedAt: _now.subtract(const Duration(days: 2)),
      author: 'Orléans Loiret Basket',
      location: 'Palais des Sports',
    ),
    NewsArticle(
      id: 'n6',
      title: 'Vigilance orange : orages attendus en fin de journée',
      summary:
          'Météo-France place le Loiret en vigilance orange orages pour '
          'cet après-midi.',
      body:
          'De forts orages sont attendus sur l\'agglomération orléanaise en '
          'fin de journée. La préfecture recommande la prudence et de '
          'limiter les déplacements.',
      category: NewsCategory.alerte,
      publishedAt: _now.subtract(const Duration(minutes: 40)),
      author: 'Préfecture du Loiret',
    ),
  ];

  static final List<Business> businesses = [
    const Business(
      id: 'b1',
      name: 'La Table d\'à Côté',
      category: BusinessCategory.restaurant,
      description:
          'Bistrot de saison, produits locaux et cave de vins de Loire.',
      address: '12 rue de Bourgogne',
      district: 'Bourgogne',
      rating: 4.7,
      reviewCount: 214,
      phone: '02 38 00 00 01',
      tags: ['Terrasse', 'Fait maison', 'Vins de Loire'],
    ),
    const Business(
      id: 'b2',
      name: 'Boulangerie du Martroi',
      category: BusinessCategory.boulangerie,
      description: 'Pains au levain et pâtisseries artisanales depuis 1934.',
      address: '3 place du Martroi',
      district: 'Centre-ville',
      rating: 4.8,
      reviewCount: 512,
      tags: ['Levain', 'Artisanal'],
    ),
    const Business(
      id: 'b3',
      name: 'Café Jeanne',
      category: BusinessCategory.cafe,
      description: 'Torréfaction locale, brunch le week-end et wifi.',
      address: '25 rue Jeanne d\'Arc',
      district: 'Cathédrale',
      rating: 4.5,
      reviewCount: 176,
      tags: ['Brunch', 'Wifi', 'Végétarien'],
    ),
    const Business(
      id: 'b4',
      name: 'Librairie Les Temps Modernes',
      category: BusinessCategory.culture,
      description: 'Librairie indépendante généraliste et rencontres d\'auteurs.',
      address: '58 rue de la République',
      district: 'Centre-ville',
      rating: 4.9,
      reviewCount: 98,
      tags: ['Indépendant', 'Rencontres'],
    ),
    const Business(
      id: 'b5',
      name: 'Pharmacie de la Loire',
      category: BusinessCategory.sante,
      description: 'Pharmacie de quartier, orthopédie et conseils santé.',
      address: '9 quai du Châtelet',
      district: 'Loire',
      rating: 4.3,
      reviewCount: 64,
      phone: '02 38 00 00 05',
      openNow: false,
    ),
    const Business(
      id: 'b6',
      name: 'Atelier Vélo Ligérien',
      category: BusinessCategory.artisan,
      description: 'Réparation, entretien et location de vélos.',
      address: '41 faubourg Bannier',
      district: 'Bannier',
      rating: 4.6,
      reviewCount: 132,
      tags: ['Réparation', 'Location'],
    ),
    const Business(
      id: 'b7',
      name: 'Fromagerie des Halles',
      category: BusinessCategory.commerce,
      description: 'Fromages fermiers du Loiret et affinage maison.',
      address: 'Halles Châtelet',
      district: 'Centre-ville',
      rating: 4.8,
      reviewCount: 240,
      tags: ['Local', 'Affinage'],
    ),
    const Business(
      id: 'b8',
      name: 'Le Comptoir Réparation',
      category: BusinessCategory.service,
      description: 'Réparation smartphones et informatique en 1 heure.',
      address: '17 rue des Carmes',
      district: 'Carmes',
      rating: 4.2,
      reviewCount: 87,
      phone: '02 38 00 00 09',
    ),
  ];

  static final List<Ride> rides = [
    Ride(
      id: 'r1',
      driverName: 'Camille',
      origin: 'Orléans Centre',
      destination: 'La Source (Université)',
      departureTime: _now.add(const Duration(hours: 1, minutes: 30)),
      seatsAvailable: 3,
      pricePerSeat: 2.0,
      recurring: true,
      note: 'Trajet quotidien, ponctuel·le.',
    ),
    Ride(
      id: 'r2',
      driverName: 'Karim',
      origin: 'Saint-Jean-de-la-Ruelle',
      destination: 'Zone Ingré / Cap Saran',
      departureTime: _now.add(const Duration(hours: 3)),
      seatsAvailable: 2,
      pricePerSeat: 1.5,
      recurring: false,
    ),
    Ride(
      id: 'r3',
      driverName: 'Léa',
      origin: 'Olivet',
      destination: 'Gare d\'Orléans',
      departureTime: _now.add(const Duration(hours: 5)),
      seatsAvailable: 1,
      pricePerSeat: 2.5,
      recurring: true,
      note: 'Correspondance train de 18h12.',
    ),
    Ride(
      id: 'r4',
      driverName: 'Thomas',
      origin: 'Fleury-les-Aubrais',
      destination: 'Centre commercial Place d\'Arc',
      departureTime: _now.add(const Duration(hours: 2)),
      seatsAvailable: 3,
      pricePerSeat: 1.0,
      recurring: false,
    ),
  ];

  static const List<TransitLine> transit = [
    TransitLine(
      id: 't1',
      name: 'Tram A',
      type: TransitType.tram,
      status: TransitStatus.normal,
      nextDepartures: ['3 min', '9 min', '15 min'],
    ),
    TransitLine(
      id: 't2',
      name: 'Tram B',
      type: TransitType.tram,
      status: TransitStatus.perturbe,
      nextDepartures: ['7 min', '18 min'],
    ),
    TransitLine(
      id: 't3',
      name: 'Bus 06',
      type: TransitType.bus,
      status: TransitStatus.normal,
      nextDepartures: ['5 min', '20 min'],
    ),
  ];
}
