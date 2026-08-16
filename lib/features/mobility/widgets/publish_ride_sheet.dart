import 'package:flutter/material.dart';

import '../../../core/utils/date_format.dart';
import '../../../models/ride.dart';

/// Feuille de saisie pour proposer un covoiturage.
///
/// Renvoie le [Ride] créé via `Navigator.pop`, ou `null` si annulé.
class PublishRideSheet extends StatefulWidget {
  const PublishRideSheet({super.key});

  @override
  State<PublishRideSheet> createState() => _PublishRideSheetState();
}

class _PublishRideSheetState extends State<PublishRideSheet> {
  final _formKey = GlobalKey<FormState>();
  final _origin = TextEditingController();
  final _destination = TextEditingController();
  int _seats = 2;
  double _price = 2.0;

  @override
  void dispose() {
    _origin.dispose();
    _destination.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final ride = Ride(
      id: 'r-${DateTime.now().millisecondsSinceEpoch}',
      driverName: 'Vous',
      origin: _origin.text.trim(),
      destination: _destination.text.trim(),
      departureTime: DateFormatFr.now.add(const Duration(hours: 1)),
      seatsAvailable: _seats,
      pricePerSeat: _price,
    );
    Navigator.of(context).pop(ride);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Proposer un trajet',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _origin,
              decoration: const InputDecoration(
                labelText: 'Départ',
                prefixIcon: Icon(Icons.trip_origin),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Indiquez le départ' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _destination,
              decoration: const InputDecoration(
                labelText: 'Destination',
                prefixIcon: Icon(Icons.place),
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Indiquez la destination'
                  : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _Stepper(
                    label: 'Places',
                    value: '$_seats',
                    onMinus: _seats > 1
                        ? () => setState(() => _seats--)
                        : null,
                    onPlus: _seats < 6
                        ? () => setState(() => _seats++)
                        : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _Stepper(
                    label: 'Prix / place',
                    value: '${_price.toStringAsFixed(1)} €',
                    onMinus: _price > 0
                        ? () => setState(
                            () => _price =
                                (_price - 0.5).clamp(0, 20).toDouble(),
                          )
                        : null,
                    onPlus: () => setState(
                      () => _price = (_price + 0.5).clamp(0, 20).toDouble(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                child: const Text('Publier le trajet'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({
    required this.label,
    required this.value,
    required this.onMinus,
    required this.onPlus,
  });

  final String label;
  final String value;
  final VoidCallback? onMinus;
  final VoidCallback? onPlus;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton.filledTonal(
              onPressed: onMinus,
              icon: const Icon(Icons.remove),
            ),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
            IconButton.filledTonal(
              onPressed: onPlus,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ],
    );
  }
}
