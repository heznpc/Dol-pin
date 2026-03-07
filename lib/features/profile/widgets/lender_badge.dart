import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class LenderBadge extends StatelessWidget {
  const LenderBadge({super.key, required this.grade});
  final String grade;

  @override
  Widget build(BuildContext context) {
    final (color, icon, label) = switch (grade) {
      'power' => (AppColors.primary, Icons.workspace_premium, 'Power Lender'),
      'regular' => (AppColors.accent, Icons.verified, 'Regular Lender'),
      _ => (AppColors.textHint, Icons.person_outline, 'New Member'),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
