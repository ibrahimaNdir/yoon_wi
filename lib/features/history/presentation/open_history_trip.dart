import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:yoon_wi/core/di/injection_container.dart';
import 'package:yoon_wi/core/router/route_names.dart';
import 'package:yoon_wi/features/history/domain/entities/trip_history_entry.dart';
import 'package:yoon_wi/features/search/presentation/bloc/search_form_cubit.dart';
import 'package:yoon_wi/features/search/presentation/bloc/search_form_state.dart';

/// Remet les deux lieux dans la recherche et relance le calcul.
void openHistoryTrip(BuildContext context, TripHistoryEntry entry) {
  final form = sl<SearchFormCubit>();
  form.setPlace(SearchField.from, entry.from);
  form.setPlace(SearchField.to, entry.to);
  context.push(RouteNames.results);
}
