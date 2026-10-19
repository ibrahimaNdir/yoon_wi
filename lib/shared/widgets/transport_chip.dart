import 'package:flutter/material.dart';
import 'package:yoon_wi/core/constants/transport_mode.dart';
import 'package:yoon_wi/core/theme/app_text_styles.dart';

class TransportChip extends StatelessWidget {
  const TransportChip(this.mode, {super.key, this.label});

  final TransportMode mode;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final text = label ?? mode.label;
    return Semantics(
      label: 'Transport : $text',
      child: ExcludeSemantics(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: mode.color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(text, style: AppTextStyles.chip),
        ),
      ),
    );
  }
}
