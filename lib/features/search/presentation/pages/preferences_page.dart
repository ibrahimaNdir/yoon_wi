import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yoon_wi/core/constants/transport_mode.dart';
import 'package:yoon_wi/core/di/injection_container.dart';
import 'package:yoon_wi/core/theme/app_colors.dart';
import 'package:yoon_wi/core/theme/app_text_styles.dart';
import 'package:yoon_wi/features/search/domain/entities/search_preferences.dart';
import 'package:yoon_wi/features/search/presentation/bloc/search_form_cubit.dart';
import 'package:yoon_wi/features/search/presentation/search_labels.dart';
import 'package:yoon_wi/shared/widgets/primary_button.dart';

class PreferencesPage extends StatefulWidget {
  const PreferencesPage({super.key});

  @override
  State<PreferencesPage> createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  static const _selectable = [
    TransportMode.ter,
    TransportMode.brt,
    TransportMode.tata,
    TransportMode.ddd,
  ];

  late SearchPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _prefs = sl<SearchFormCubit>().state.preferences;
  }

  void _toggle(TransportMode mode, bool selected) {
    final modes = {..._prefs.modes};
    selected ? modes.add(mode) : modes.remove(mode);
    setState(() => _prefs = _prefs.copyWith(modes: modes));
  }

  @override
  Widget build(BuildContext context) {
    final noMode = _prefs.modes.isEmpty;
    return Scaffold(
      appBar: AppBar(title: const Text('Préférences de trajet')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  Text(
                    'Priorité',
                    style: AppTextStyles.h2.copyWith(fontSize: 16),
                  ),
                  for (final priority in RoutePriority.values)
                    RadioListTile<RoutePriority>(
                      contentPadding: EdgeInsets.zero,
                      title: Text(priorityLongLabel(priority)),
                      value: priority,
                      groupValue: _prefs.priority,
                      onChanged:
                          (v) => setState(
                            () => _prefs = _prefs.copyWith(priority: v),
                          ),
                    ),
                  const SizedBox(height: 12),
                  Text(
                    'Réseaux à utiliser',
                    style: AppTextStyles.h2.copyWith(fontSize: 16),
                  ),
                  for (final mode in _selectable)
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.trailing,
                      title: Text(mode.label),
                      value: _prefs.modes.contains(mode),
                      onChanged: (v) => _toggle(mode, v ?? false),
                    ),
                  if (noMode)
                    Text(
                      'Choisissez au moins un réseau.',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.danger,
                      ),
                    ),
                  const SizedBox(height: 12),
                  Text(
                    'Marche maximale : ${_prefs.maxWalkMinutes} min',
                    style: AppTextStyles.h2.copyWith(fontSize: 16),
                  ),
                  Slider(
                    min: 2,
                    max: 20,
                    divisions: 18,
                    value: _prefs.maxWalkMinutes.toDouble(),
                    label: '${_prefs.maxWalkMinutes} min',
                    onChanged:
                        (v) => setState(
                          () =>
                              _prefs = _prefs.copyWith(
                                maxWalkMinutes: v.round(),
                              ),
                        ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: PrimaryButton(
                label: 'Appliquer',
                onPressed:
                    noMode
                        ? null
                        : () {
                          sl<SearchFormCubit>().setPreferences(_prefs);
                          context.pop();
                        },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
