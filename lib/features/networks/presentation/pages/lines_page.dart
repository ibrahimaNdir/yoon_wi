import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:yoon_wi/core/bloc/load_state.dart';
import 'package:yoon_wi/core/di/injection_container.dart';
import 'package:yoon_wi/core/router/route_names.dart';
import 'package:yoon_wi/core/theme/app_text_styles.dart';
import 'package:yoon_wi/core/utils/plural.dart';
import 'package:yoon_wi/features/networks/domain/entities/transport_type.dart';
import 'package:yoon_wi/features/networks/presentation/bloc/lines_cubit.dart';
import 'package:yoon_wi/features/networks/presentation/widgets/line_tile.dart';
import 'package:yoon_wi/shared/widgets/breadcrumb.dart';
import 'package:yoon_wi/shared/widgets/empty_state.dart';
import 'package:yoon_wi/shared/widgets/loading_skeleton.dart';
import 'package:yoon_wi/shared/widgets/primary_button.dart';

class LinesPage extends StatelessWidget {
  const LinesPage({super.key, required this.typeName});

  final String typeName;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LinesCubit>()..load(typeName),
      child: Scaffold(
        appBar: AppBar(title: Text(typeName)),
        body: SafeArea(
          child: BlocBuilder<LinesCubit, LoadState<TransportType>>(
            builder: (context, state) {
              switch (state.status) {
                case LoadStatus.loading:
                  return ListView.separated(
                    padding: const EdgeInsets.all(24),
                    itemCount: 3,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, __) => const LoadingSkeleton(height: 64),
                  );
                case LoadStatus.failure:
                  return EmptyState(
                    title: 'Type de transport introuvable',
                    message: state.message ?? 'Une erreur est survenue.',
                    icon: Icons.error_outline,
                    actions: [
                      PrimaryButton(
                        label: 'Retour aux réseaux',
                        onPressed: () => context.go(RouteNames.networks),
                      ),
                    ],
                  );
                case LoadStatus.success:
                  final type = state.data!;
                  final breadcrumb = Breadcrumb(
                    items: [
                      BreadcrumbItem(
                        'Réseaux',
                        onTap: () => context.go(RouteNames.networks),
                      ),
                      BreadcrumbItem(type.name),
                    ],
                  );

                  if (type.lines.isEmpty) {
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
                            title: 'Aucune ligne disponible',
                            message:
                                'Les lignes de ce type de transport ne sont pas encore renseignées dans l’application.',
                            actions: [
                              PrimaryButton(
                                label: 'Retour aux réseaux',
                                onPressed:
                                    () => context.go(RouteNames.networks),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }

                  return ListView(
                    padding: const EdgeInsets.all(24),
                    children: [
                      breadcrumb,
                      const SizedBox(height: 8),
                      Text(
                        plural(type.lines.length, 'ligne'),
                        style: AppTextStyles.bodyMuted,
                      ),
                      const SizedBox(height: 12),
                      for (final line in type.lines) ...[
                        LineTile(
                          line: line,
                          color: type.mode.color,
                          onTap:
                              () => context.go(
                                RouteNames.stopsOf(type.name, line.code),
                              ),
                        ),
                        const SizedBox(height: 12),
                      ],
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
