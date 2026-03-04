import 'package:curiosity_flutter/core/design/design.dart';
import 'package:flutter/material.dart';

class ParticipantsWidget extends StatelessWidget {
  const ParticipantsWidget(this.count, {super.key});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          CustomIcon(
            Icons.people_outline,
            size: 20,
          ),
          width.m,
          Expanded(
            child: CustomText(
              'Participantes',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.start,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: colors.green.withValues(alpha: .2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: CustomText(
              '$count',
              color: colors.green.withValues(alpha: .8),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
