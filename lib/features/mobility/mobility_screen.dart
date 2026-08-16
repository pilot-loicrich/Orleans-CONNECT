import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../data/repositories/mobility_repository.dart';
import '../../models/ride.dart';
import '../../shared/widgets/async_view.dart';
import 'widgets/publish_ride_sheet.dart';
import 'widgets/ride_card.dart';

/// Module mobilité : état des transports en commun (TAO) et covoiturage local.
class MobilityScreen extends StatefulWidget {
  const MobilityScreen({super.key});

  @override
  State<MobilityScreen> createState() => _MobilityScreenState();
}

class _MobilityScreenState extends State<MobilityScreen> {
  // Change de valeur pour forcer le rechargement des Future après publication.
  int _reloadKey = 0;

  Future<void> _publishRide() async {
    final repo = context.read<MobilityRepository>();
    final ride = await showModalBottomSheet<Ride>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => const PublishRideSheet(),
    );
    if (ride == null || !mounted) return;
    await repo.publishRide(ride);
    if (!mounted) return;
    setState(() => _reloadKey++);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Trajet publié, merci !')),
    );
  }

  void _book(Ride ride) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Demande envoyée à ${ride.driverName}.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final repo = context.read<MobilityRepository>();

    return Scaffold(
      appBar: AppBar(title: const Text('Mobilité')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _publishRide,
        backgroundColor: AppColors.orange,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Proposer'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
        children: [
          const _SectionTitle('Transports en commun'),
          AsyncView<List<TransitLine>>(
            key: ValueKey('transit-$_reloadKey'),
            future: repo.fetchTransit(),
            builder: (context, lines) => Column(
              children: [for (final l in lines) _TransitTile(line: l)],
            ),
          ),
          const SizedBox(height: 24),
          const _SectionTitle('Covoiturage local'),
          AsyncView<List<Ride>>(
            key: ValueKey('rides-$_reloadKey'),
            future: repo.fetchRides(),
            isEmpty: (data) => data.isEmpty,
            emptyMessage: 'Aucun trajet proposé pour l\'instant.',
            builder: (context, rides) => Column(
              children: [
                for (final r in rides)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: RideCard(ride: r, onBook: () => _book(r)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 4),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}

class _TransitTile extends StatelessWidget {
  const _TransitTile({required this.line});

  final TransitLine line;

  Color get _statusColor => switch (line.status) {
        TransitStatus.normal => AppColors.success,
        TransitStatus.perturbe => AppColors.warning,
        TransitStatus.interrompu => AppColors.danger,
      };

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Icon(
              line.type == TransitType.tram
                  ? Icons.tram
                  : Icons.directions_bus,
              color: AppColors.navy,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    line.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        line.status.label,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  line.nextDepartures.first,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppColors.orange,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'puis ${line.nextDepartures.skip(1).join(', ')}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
