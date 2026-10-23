import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:yoon_wi/core/di/injection_container.dart';
import 'package:yoon_wi/core/router/route_names.dart';
import 'package:yoon_wi/core/theme/app_colors.dart';
import 'package:yoon_wi/core/theme/app_text_styles.dart';
import 'package:yoon_wi/core/utils/duration_formatter.dart';
import 'package:yoon_wi/core/utils/price_formatter.dart';
import 'package:yoon_wi/features/guidance/presentation/bloc/guidance_cubit.dart';
import 'package:yoon_wi/features/guidance/presentation/widgets/next_step_card.dart';
import 'package:yoon_wi/features/guidance/presentation/widgets/step_progress_bar.dart';
import 'package:yoon_wi/features/itinerary/domain/entities/itinerary.dart';
import 'package:yoon_wi/features/itinerary/domain/entities/step.dart';
import 'package:yoon_wi/features/itinerary/presentation/roadmap_labels.dart';
import 'package:yoon_wi/features/search/presentation/bloc/search_form_cubit.dart';
import 'package:yoon_wi/shared/widgets/empty_state.dart';
import 'package:yoon_wi/shared/widgets/primary_button.dart';
import 'package:yoon_wi/shared/widgets/secondary_button.dart';

class GuidancePage extends StatelessWidget {
  const GuidancePage({super.key, required this.itinerary});

  final Itinerary? itinerary;

  Future<bool> _confirmStop(BuildContext context) async {
    final stop = await showDialog<bool>(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text('Arrêter le guidage ?'),
            content: const Text(
              'Vous pourrez le relancer depuis la feuille de route.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text('Continuer'),
              ),
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: const Text('Arrêter'),
              ),
            ],
          ),
    );
    return stop ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final form = sl<SearchFormCubit>().state;
    final it = itinerary;
    final from = form.departure;
    final to = form.arrival;

    if (it == null || from == null || to == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Guidage')),
        body: SafeArea(
          child: EmptyState(
            icon: Icons.route,
            title: 'Trajet introuvable',
            message: 'Relancez une recherche pour démarrer le guidage.',
            actions: [
              PrimaryButton(
                label: 'Retour à la recherche',
                onPressed: () => context.go(RouteNames.search),
              ),
            ],
          ),
        ),
      );
    }

    return BlocProvider(
      create: (_) => GuidanceCubit(itinerary: it, from: from, to: to),
      child: BlocConsumer<GuidanceCubit, GuidanceState>(
        listenWhen:
            (previous, current) => !previous.finished && current.finished,
        listener:
            (context, state) => context.pushReplacement(
              RouteNames.arrival,
              extra: state.summary,
            ),
        builder: (context, state) {
          final progress = state.progress;
          final view = describeStep(progress.current);
          final nextView =
              progress.next == null ? null : describeStep(progress.next!);
          final cubit = context.read<GuidanceCubit>();

          Future<void> stop() async {
            if (await _confirmStop(context) && context.mounted) {
              context.pop();
            }
          }

          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, _) {
              if (!didPop) stop();
            },
            child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  tooltip: 'Arrêter le guidage',
                  icon: const Icon(Icons.close),
                  onPressed: stop,
                ),
                // Appui long : alerte de démonstration, versions de
                // développement seulement.
                title: GestureDetector(
                  onLongPress:
                      kDebugMode
                          ? () => context.push(
                            RouteNames.alert,
                            extra:
                                progress.current.kind == StepKind.ride
                                    ? progress.current
                                    : null,
                          )
                          : null,
                  child: const Text('Guidage'),
                ),
              ),
              body: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                        children: [
                          StepProgressBar(
                            index: progress.index,
                            total: progress.steps.length,
                            color: view.color,
                          ),
                          const SizedBox(height: 24),
                          Semantics(
                            liveRegion: true,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  view.label.toUpperCase(),
                                  style: AppTextStyles.caption.copyWith(
                                    color: view.color,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.4,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(view.title, style: AppTextStyles.h1),
                                if (view.subtitle.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    view.subtitle,
                                    style: AppTextStyles.bodyMuted,
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          NextStepCard(next: nextView),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Reste ${DurationFormatter.range(progress.remainingMin, progress.remainingMax)}',
                                  style: AppTextStyles.body,
                                ),
                              ),
                              Text(
                                'À payer encore ${PriceFormatter.format(progress.remainingFare)}',
                                style: AppTextStyles.bodyMuted,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                      child: Column(
                        children: [
                          PrimaryButton(
                            label:
                                progress.isLast
                                    ? 'Terminer le trajet'
                                    : 'Étape suivante',
                            onPressed: cubit.next,
                          ),
                          if (!progress.isFirst)
                            TextButton(
                              onPressed: cubit.previous,
                              style: TextButton.styleFrom(
                                minimumSize: const Size.fromHeight(48),
                                foregroundColor: AppColors.primary,
                              ),
                              child: const Text('Étape précédente'),
                            ),
                          const SizedBox(height: 4),
                          SecondaryButton(
                            label: 'Arrêter le guidage',
                            onPressed: stop,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
