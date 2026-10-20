import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:yoon_wi/core/bloc/load_state.dart';
import 'package:yoon_wi/core/constants/transport_mode.dart';
import 'package:yoon_wi/core/di/injection_container.dart';
import 'package:yoon_wi/core/router/route_names.dart';
import 'package:yoon_wi/core/theme/app_text_styles.dart';
import 'package:yoon_wi/core/utils/plural.dart';
import 'package:yoon_wi/core/utils/price_formatter.dart';
import 'package:yoon_wi/features/networks/domain/entities/line.dart';
import 'package:yoon_wi/features/networks/presentation/bloc/stops_cubit.dart';
import 'package:yoon_wi/features/networks/presentation/widgets/stop_timeline_tile.dart';
import 'package:yoon_wi/shared/widgets/breadcrumb.dart';
import 'package:yoon_wi/shared/widgets/empty_state.dart';
import 'package:yoon_wi/shared/widgets/loading_skeleton.dart';
import 'package:yoon_wi/shared/widgets/primary_button.dart';
import 'package:yoon_wi/shared/widgets/transport_chip.dart';

class StopsPage extends StatelessWidget {
  const StopsPage({super.key, required this.typeName, required this.lineCode});

  final String typeName;
  final String lineCode;

  @override
  Widget build(BuildContext context) {
    final mode = TransportMode.fromLabel(typeName) ?? TransportMode.walk;
    return BlocProvider(
      create: (_) => sl<StopsCubit>()..load(typeName, lineCode),
      child: Scaffold(
        appBar: AppBar(title: Text(lineCode)),
        body: SafeArea(
          child: BlocBuilder<StopsCubit, LoadState<Line>>(
            builder: (context, state) {
              switch (state.status) {
                case LoadStatus.loading:
                  return ListView.separated(
                    padding: const EdgeInsets.all(24),
                    itemCount: 5,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, __) => const LoadingSkeleton(height: 32),
                  );
                case LoadStatus.failure:
                  return EmptyState(
                    title: 'Ligne introuvable',
                    message: state.message ?? 'Une erreur est survenue.',
                    icon: Icons.error_outline,
                    actions: [
                      PrimaryButton(
                        label: 'Retour aux lignes',
                        onPressed:
                            () => context.go(RouteNames.linesOf(typeName)),
                      ),
                    ],
                  );
                case LoadStatus.success:
                  final line = state.data!;
                  final breadcrumb = Breadcrumb(
                    items: [
                      BreadcrumbItem(
                        'Réseaux',
                        onTap: () => context.go(RouteNames.networks),
                      ),
                      BreadcrumbItem(
                        typeName,
                        onTap: () => context.go(RouteNames.linesOf(typeName)),
                      ),
                      BreadcrumbItem(line.name),
                    ],
                  );

                  if (line.stops.isEmpty) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: breadcrumb,
                          ),
                        ),
                        Expanded(
                          child: EmptyState(
                            title: 'Arrêts non disponibles',
                            message:
                                'Les arrêts de cette ligne ne sont pas encore renseignés dans l’application.',
                            actions: [
                              PrimaryButton(
                                label: 'Retour aux lignes',
                                onPressed:
                                    () => context.go(
                                      RouteNames.linesOf(typeName),
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }

                  final summary =
                      line.fare > 0
                          ? '${plural(line.stops.length, 'arrêt')} · ${PriceFormatter.format(line.fare)}'
                          : plural(line.stops.length, 'arrêt');

                  return ListView(
                    padding: const EdgeInsets.all(24),
                    children: [
                      breadcrumb,
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          TransportChip(mode),
                          const Spacer(),
                          Text(summary, style: AppTextStyles.bodyMuted),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Semantics(
                        header: true,
                        child: Text(
                          'Arrêts de la ligne',
                          style: AppTextStyles.h2.copyWith(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 12),
                      for (var i = 0; i < line.stops.length; i++)
                        StopTimelineTile(
                          name: line.stops[i].name,
                          color: mode.color,
                          index: i + 1,
                          total: line.stops.length,
                        ),
                    ],
                  );
              }
            },
          ),
        ),
      ),
    );
  }
}
