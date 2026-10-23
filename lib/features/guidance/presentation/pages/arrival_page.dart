import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yoon_wi/core/di/injection_container.dart';
import 'package:yoon_wi/core/router/route_names.dart';
import 'package:yoon_wi/core/theme/app_colors.dart';
import 'package:yoon_wi/core/theme/app_text_styles.dart';
import 'package:yoon_wi/core/utils/duration_formatter.dart';
import 'package:yoon_wi/core/utils/price_formatter.dart';
import 'package:yoon_wi/features/guidance/domain/entities/trip_summary.dart';
import 'package:yoon_wi/features/search/presentation/bloc/search_form_cubit.dart';
import 'package:yoon_wi/shared/widgets/primary_button.dart';
import 'package:yoon_wi/shared/widgets/secondary_button.dart';

class ArrivalPage extends StatefulWidget {
  const ArrivalPage({super.key, required this.summary});

  final TripSummary? summary;

  @override
  State<ArrivalPage> createState() => _ArrivalPageState();
}

class _ArrivalPageState extends State<ArrivalPage> {
  bool _answered = false;

  void _answer(String message) {
    setState(() => _answered = true);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _newTrip() {
    sl<SearchFormCubit>().clearPlaces();
    context.go(RouteNames.search);
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.summary;
    return Scaffold(
      appBar: AppBar(title: const Text('Trajet terminé')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  const Center(
                    child: ExcludeSemantics(
                      child: Icon(
                        Icons.check_circle,
                        size: 72,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Semantics(
                    header: true,
                    child: const Text(
                      'Vous êtes arrivé',
                      style: AppTextStyles.h1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (s != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      s.to.name,
                      style: AppTextStyles.bodyMuted,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.line),
                      ),
                      child: Column(
                        children: [
                          _SummaryRow(
                            'Durée réelle',
                            DurationFormatter.minutes(s.actualMinutes),
                            bold: true,
                          ),
                          const Divider(),
                          _SummaryRow(
                            'Durée prévue',
                            DurationFormatter.range(s.plannedMin, s.plannedMax),
                          ),
                          const Divider(),
                          _SummaryRow('Coût', PriceFormatter.format(s.fare)),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  if (_answered)
                    const Text(
                      'Merci pour votre retour.',
                      style: AppTextStyles.bodyMuted,
                      textAlign: TextAlign.center,
                    )
                  else ...[
                    Semantics(
                      header: true,
                      child: Text(
                        'Les prix et la durée étaient-ils justes ?',
                        style: AppTextStyles.h2.copyWith(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: SecondaryButton(
                            label: 'Oui',
                            onPressed:
                                () => _answer('Merci pour votre retour.'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SecondaryButton(
                            label: 'Non, signaler',
                            onPressed:
                                () => _answer(
                                  'Le signalement arrive à l’étape F14.',
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: PrimaryButton(
                label: 'Nouveau trajet',
                onPressed: _newTrip,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow(this.label, this.value, {this.bold = false});

  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label, style: AppTextStyles.body)),
        Text(
          value,
          style: AppTextStyles.body.copyWith(
            fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
