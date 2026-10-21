import 'package:flutter/material.dart';
import 'package:yoon_wi/core/constants/transport_mode.dart';
import 'package:yoon_wi/core/theme/app_colors.dart';
import 'package:yoon_wi/core/utils/duration_formatter.dart';
import 'package:yoon_wi/core/utils/plural.dart';
import 'package:yoon_wi/core/utils/price_formatter.dart';
import 'package:yoon_wi/core/utils/text_normalizer.dart';
import 'package:yoon_wi/features/itinerary/domain/entities/step.dart';

enum StepAction { line, hub }

class StepView {
  const StepView({
    required this.label,
    required this.title,
    required this.color,
    this.subtitle = '',
    this.action,
    this.actionLabel,
  });

  final String label;
  final String title;
  final String subtitle;
  final Color color;
  final StepAction? action;
  final String? actionLabel;
}

/// "Liberté 6" -> "liberte-6" : l'identifiant du hub dans hubs.json.
String hubSlug(String name) =>
    TextNormalizer.normalize(name).replaceAll(' ', '-');

StepView describeStep(ItineraryStep s) {
  switch (s.kind) {
    case StepKind.walkStart:
      return StepView(
        label: 'Marche · ${DurationFormatter.minutes(s.minMinutes)}',
        title: 'Va jusqu’à l’arrêt ${s.to}',
        subtitle: 'Départ : ${s.from}',
        color: TransportMode.walk.color,
      );
    case StepKind.ride:
      final mode = s.mode!;
      final wait = DurationFormatter.range(s.waitMinMinutes, s.waitMaxMinutes);
      final ride = DurationFormatter.range(s.minMinutes, s.maxMinutes);
      return StepView(
        label: '${mode.label} · ${PriceFormatter.format(s.fare)}',
        title: 'Monte dans le ${mode.label} ${s.lineName}',
        subtitle:
            'Attente $wait · trajet $ride\n'
            'Descends à ${s.to} (${plural(s.stopsCount, 'arrêt')})',
        color: mode.color,
        action: s.lineCode == null ? null : StepAction.line,
        actionLabel: 'Voir la ligne ›',
      );
    case StepKind.transfer:
      return StepView(
        label: 'Correspondance',
        title: 'Change de transport à ${s.from}',
        subtitle:
            'Marche ${DurationFormatter.minutes(s.minMinutes)} jusqu’au quai suivant',
        color: AppColors.ink,
        action: StepAction.hub,
        actionLabel: 'Voir le hub ›',
      );
    case StepKind.walkEnd:
      return StepView(
        label: 'Arrivée',
        title: s.to,
        subtitle:
            'Marche ${DurationFormatter.minutes(s.minMinutes)} depuis l’arrêt ${s.from}',
        color: AppColors.primary,
      );
  }
}
