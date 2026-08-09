import '../../models/ride.dart';
import '../mock_data.dart';

/// Accès au covoiturage local et aux informations de transport.
class MobilityRepository {
  MobilityRepository();

  // Copie mutable pour permettre l'ajout de trajets pendant la démo.
  final List<Ride> _rides = [...MockData.rides];

  Future<List<Ride>> fetchRides({String? destinationQuery}) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    var items = [..._rides]
      ..sort((a, b) => a.departureTime.compareTo(b.departureTime));
    if (destinationQuery != null && destinationQuery.trim().isNotEmpty) {
      final q = destinationQuery.toLowerCase().trim();
      items = items
          .where((r) =>
              r.destination.toLowerCase().contains(q) ||
              r.origin.toLowerCase().contains(q))
          .toList();
    }
    return items;
  }

  Future<void> publishRide(Ride ride) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    _rides.add(ride);
  }

  Future<List<TransitLine>> fetchTransit() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return MockData.transit;
  }
}
