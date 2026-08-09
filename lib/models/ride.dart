/// Une offre de covoiturage local proposée par un Orléanais.
class Ride {
  const Ride({
    required this.id,
    required this.driverName,
    required this.origin,
    required this.destination,
    required this.departureTime,
    required this.seatsAvailable,
    required this.pricePerSeat,
    this.recurring = false,
    this.note,
  });

  final String id;
  final String driverName;
  final String origin;
  final String destination;
  final DateTime departureTime;
  final int seatsAvailable;
  final double pricePerSeat; // en euros
  final bool recurring; // trajet régulier (domicile-travail)
  final String? note;

  factory Ride.fromJson(Map<String, dynamic> json) => Ride(
        id: json['id'] as String,
        driverName: json['driverName'] as String,
        origin: json['origin'] as String,
        destination: json['destination'] as String,
        departureTime: DateTime.parse(json['departureTime'] as String),
        seatsAvailable: json['seatsAvailable'] as int,
        pricePerSeat: (json['pricePerSeat'] as num).toDouble(),
        recurring: json['recurring'] as bool? ?? false,
        note: json['note'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'driverName': driverName,
        'origin': origin,
        'destination': destination,
        'departureTime': departureTime.toIso8601String(),
        'seatsAvailable': seatsAvailable,
        'pricePerSeat': pricePerSeat,
        'recurring': recurring,
        'note': note,
      };
}

/// Info transport en commun (tram / bus TAO) affichée dans le module mobilité.
class TransitLine {
  const TransitLine({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    required this.nextDepartures,
  });

  final String id;
  final String name; // ex. "Ligne A", "Bus 06"
  final TransitType type;
  final TransitStatus status;
  final List<String> nextDepartures; // ex. ["3 min", "11 min"]

  factory TransitLine.fromJson(Map<String, dynamic> json) => TransitLine(
        id: json['id'] as String,
        name: json['name'] as String,
        type: TransitType.values.byName(json['type'] as String),
        status: TransitStatus.values.byName(json['status'] as String),
        nextDepartures: (json['nextDepartures'] as List<dynamic>)
            .map((e) => e as String)
            .toList(),
      );
}

enum TransitType {
  tram('Tram'),
  bus('Bus');

  const TransitType(this.label);
  final String label;
}

enum TransitStatus {
  normal('Trafic normal'),
  perturbe('Perturbé'),
  interrompu('Interrompu');

  const TransitStatus(this.label);
  final String label;
}
