import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yoon_wi/core/di/injection_container.dart';
import 'package:yoon_wi/core/theme/app_colors.dart';
import 'package:yoon_wi/core/theme/app_text_styles.dart';
import 'package:yoon_wi/features/search/domain/entities/trip_time.dart';
import 'package:yoon_wi/features/search/presentation/bloc/search_form_cubit.dart';
import 'package:yoon_wi/shared/widgets/primary_button.dart';

class TimePickerPage extends StatefulWidget {
  const TimePickerPage({super.key});

  @override
  State<TimePickerPage> createState() => _TimePickerPageState();
}

class _TimePickerPageState extends State<TimePickerPage> {
  late TimeMode _mode;
  late bool _tomorrow;
  late int _minutes;

  @override
  void initState() {
    super.initState();
    final current = sl<SearchFormCubit>().state.time;
    final now = TimeOfDay.now();
    _mode = current.mode;
    _tomorrow = current.tomorrow;
    _minutes =
        current.mode == TimeMode.now
            ? now.hour * 60 + now.minute
            : current.minutes;
  }

  Future<void> _pickClock() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _minutes ~/ 60, minute: _minutes % 60),
      builder:
          (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          ),
    );
    if (picked != null) {
      setState(() => _minutes = picked.hour * 60 + picked.minute);
    }
  }

  @override
  Widget build(BuildContext context) {
    final clock = TripTime(minutes: _minutes).clock;
    return Scaffold(
      appBar: AppBar(title: const Text('Heure du trajet')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  RadioListTile<TimeMode>(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Partir maintenant'),
                    value: TimeMode.now,
                    groupValue: _mode,
                    onChanged: (v) => setState(() => _mode = v!),
                  ),
                  RadioListTile<TimeMode>(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Partir à'),
                    value: TimeMode.departAt,
                    groupValue: _mode,
                    onChanged: (v) => setState(() => _mode = v!),
                  ),
                  RadioListTile<TimeMode>(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Arriver avant'),
                    value: TimeMode.arriveBy,
                    groupValue: _mode,
                    onChanged: (v) => setState(() => _mode = v!),
                  ),
                  if (_mode != TimeMode.now) ...[
                    const SizedBox(height: 12),
                    DropdownButtonFormField<bool>(
                      value: _tomorrow,
                      decoration: const InputDecoration(labelText: 'Jour'),
                      items: const [
                        DropdownMenuItem(
                          value: false,
                          child: Text('Aujourd’hui'),
                        ),
                        DropdownMenuItem(value: true, child: Text('Demain')),
                      ],
                      onChanged: (v) => setState(() => _tomorrow = v!),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: _pickClock,
                      icon: const Icon(Icons.schedule),
                      label: Text('Heure : $clock'),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.line),
                    ),
                    child: const Text(
                      'Aux heures de pointe, la durée du trajet est plus longue : la fourchette de temps en tient compte.',
                      style: AppTextStyles.bodyMuted,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: PrimaryButton(
                label: 'Valider',
                onPressed: () {
                  sl<SearchFormCubit>().setTime(
                    _mode == TimeMode.now
                        ? const TripTime()
                        : TripTime(
                          mode: _mode,
                          minutes: _minutes,
                          tomorrow: _tomorrow,
                        ),
                  );
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
