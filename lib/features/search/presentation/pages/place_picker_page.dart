import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:yoon_wi/core/bloc/load_state.dart';
import 'package:yoon_wi/core/di/injection_container.dart';
import 'package:yoon_wi/core/theme/app_colors.dart';
import 'package:yoon_wi/core/theme/app_text_styles.dart';
import 'package:yoon_wi/core/utils/plural.dart';
import 'package:yoon_wi/features/search/domain/entities/place.dart';
import 'package:yoon_wi/features/search/presentation/bloc/place_search_cubit.dart';
import 'package:yoon_wi/features/search/presentation/bloc/search_form_cubit.dart';
import 'package:yoon_wi/features/search/presentation/bloc/search_form_state.dart';
import 'package:yoon_wi/shared/widgets/empty_state.dart';
import 'package:yoon_wi/shared/widgets/loading_skeleton.dart';

class PlacePickerPage extends StatefulWidget {
  const PlacePickerPage({super.key, required this.field, this.onPicked});

  final SearchField field;
  final ValueChanged<Place>? onPicked;

  @override
  State<PlacePickerPage> createState() => _PlacePickerPageState();
}

class _PlacePickerPageState extends State<PlacePickerPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFrom = widget.field == SearchField.from;
    return BlocProvider(
      create: (_) => sl<PlaceSearchCubit>()..search(''),
      child: Builder(
        builder:
            (context) => Scaffold(
              appBar: AppBar(
                title: Text(
                  widget.onPicked != null
                      ? 'Lieu favori'
                      : (isFrom ? 'Départ' : 'Arrivée'),
                ),
              ),
              body: SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                      child: TextField(
                        controller: _controller,
                        autofocus: true,
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          hintText:
                              isFrom ? 'D’où partez-vous ?' : 'Où allez-vous ?',
                          prefixIcon: const Icon(Icons.search),
                        ),
                        onChanged:
                            (value) =>
                                context.read<PlaceSearchCubit>().search(value),
                      ),
                    ),
                    Expanded(
                      child: BlocBuilder<
                        PlaceSearchCubit,
                        LoadState<List<Place>>
                      >(
                        builder: (context, state) {
                          switch (state.status) {
                            case LoadStatus.loading:
                              return ListView(
                                padding: const EdgeInsets.all(24),
                                children: const [
                                  LoadingSkeleton(height: 56),
                                  SizedBox(height: 12),
                                  LoadingSkeleton(height: 56),
                                ],
                              );
                            case LoadStatus.failure:
                              return EmptyState(
                                title: 'Lieux indisponibles',
                                message:
                                    state.message ?? 'Une erreur est survenue.',
                                icon: Icons.error_outline,
                              );
                            case LoadStatus.success:
                              final places = state.data!;
                              if (places.isEmpty) {
                                return const EmptyState(
                                  title: 'Aucun lieu trouvé',
                                  message:
                                      'Essayez un autre nom ou un repère connu, comme UCAD ou Petersen.',
                                  icon: Icons.search_off,
                                );
                              }
                              final query = _controller.text.trim();
                              return ListView(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                    child: Text(
                                      query.isEmpty
                                          ? 'Suggestions'
                                          : plural(places.length, 'résultat'),
                                      style: AppTextStyles.caption,
                                    ),
                                  ),
                                  for (final place in places)
                                    ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: const Icon(
                                        Icons.place_outlined,
                                        color: AppColors.primary,
                                      ),
                                      title: Text(
                                        place.name,
                                        style: AppTextStyles.body,
                                      ),
                                      subtitle: Text(
                                        place.zone,
                                        style: AppTextStyles.bodyMuted,
                                      ),
                                      onTap: () {
                                        sl<SearchFormCubit>().setPlace(
                                          widget.field,
                                          place,
                                        );
                                        context.pop();
                                      },
                                    ),
                                ],
                              );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}
