import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/date_format.dart';
import '../../../models/ride.dart';

class RideCard extends StatelessWidget {
  const RideCard({required this.ride, required this.onBook, super.key});

  final Ride ride;
  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.cyan.withValues(alpha: 0.15),
                  child: Text(
                    ride.driverName.characters.first,
                    style: const TextStyle(
                      color: AppColors.cyan,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ride.driverName,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      if (ride.recurring)
                        Text(
                          'Trajet régulier',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
                Text(
                  '${ride.pricePerSeat.toStringAsFixed(2)} €',
                  style: const TextStyle(
                    color: AppColors.orange,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _Leg(icon: Icons.trip_origin, text: ride.origin),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Container(width: 2, height: 14, color: AppColors.mist),
            ),
            _Leg(icon: Icons.place, text: ride.destination),
            const SizedBox(height: 14),
            Row(
              children: [
                const Icon(Icons.schedule, size: 15, color: AppColors.slate),
                const SizedBox(width: 4),
                Text(
                  '${DateFormatFr.dayMonth(ride.departureTime)} · '
                  '${DateFormatFr.time(ride.departureTime)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const Spacer(),
                Icon(
                  Icons.event_seat,
                  size: 15,
                  color: ride.seatsAvailable > 0
                      ? AppColors.success
                      : AppColors.slate,
                ),
                const SizedBox(width: 4),
                Text(
                  '${ride.seatsAvailable} place(s)',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            if (ride.note != null) ...[
              const SizedBox(height: 8),
              Text(
                ride.note!,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontStyle: FontStyle.italic),
              ),
            ],
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: ride.seatsAvailable > 0 ? onBook : null,
                child: const Text('Réserver une place'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Leg extends StatelessWidget {
  const _Leg({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.cyan),
        const SizedBox(width: 10),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}
