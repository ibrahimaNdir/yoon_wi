import 'package:flutter/material.dart';
import 'package:yoon_wi/core/di/injection_container.dart';
import 'package:yoon_wi/core/theme/app_colors.dart';
import 'package:yoon_wi/core/theme/app_text_styles.dart';
import 'package:yoon_wi/features/itinerary/domain/entities/itinerary.dart';
import 'package:yoon_wi/features/itinerary/domain/share_text_builder.dart';
import 'package:yoon_wi/features/itinerary/domain/usecases/share_itinerary.dart';
import 'package:yoon_wi/features/search/domain/entities/place.dart';
import 'package:yoon_wi/shared/widgets/primary_button.dart';
import 'package:yoon_wi/shared/widgets/secondary_button.dart';

Future<void> showShareSheet(
  BuildContext context, {
  required Itinerary itinerary,
  required Place from,
  required Place to,
}) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder:
        (sheetContext) => _ShareSheet(itinerary: itinerary, from: from, to: to),
  );
}

class _ShareSheet extends StatelessWidget {
  const _ShareSheet({
    required this.itinerary,
    required this.from,
    required this.to,
  });

  final Itinerary itinerary;
  final Place from;
  final Place to;

  Future<void> _share(BuildContext context, ShareChannel channel) async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final result = await sl<ShareItinerary>()(
      ShareItineraryParams(
        itinerary: itinerary,
        from: from,
        to: to,
        channel: channel,
      ),
    );
    navigator.pop();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          result.fold(
            (failure) => failure.message,
            (_) =>
                channel == ShareChannel.copy ? 'Texte copié' : 'Partage ouvert',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final preview = ShareTextBuilder.build(
      itinerary: itinerary,
      from: from,
      to: to,
    );
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Semantics(
                    header: true,
                    child: const Text(
                      'Partager ce trajet',
                      style: AppTextStyles.h2,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Fermer',
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.line),
              ),
              child: Text(preview, style: AppTextStyles.bodyMuted),
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              label: 'Envoyer par WhatsApp',
              onPressed: () => _share(context, ShareChannel.whatsapp),
            ),
            const SizedBox(height: 12),
            SecondaryButton(
              label: 'Copier le texte',
              onPressed: () => _share(context, ShareChannel.copy),
            ),
            const SizedBox(height: 12),
            SecondaryButton(
              label: 'Autres applications',
              onPressed: () => _share(context, ShareChannel.system),
            ),
          ],
        ),
      ),
    );
  }
}
