import 'package:flutter/material.dart';
import 'package:yoon_wi/core/constants/transport_mode.dart';
import 'package:yoon_wi/features/itinerary/domain/entities/itinerary.dart';
import 'package:yoon_wi/shared/widgets/transport_chip.dart';

/// Marche, puis chaque réseau utilisé dans l'ordre du trajet.
class TransportChipsRow extends StatelessWidget {
  const TransportChipsRow({super.key, required this.itinerary});

  final Itinerary itinerary;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        const TransportChip(TransportMode.walk),
        for (final mode in itinerary.modes) TransportChip(mode),
      ],
    );
  }
}
