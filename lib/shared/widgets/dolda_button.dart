import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class DoldaButton extends StatelessWidget {
  const DoldaButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.variant = DoldaButtonVariant.primary,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final DoldaButtonVariant variant;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: switch (variant) {
        DoldaButtonVariant.primary => ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            child: _buildChild(),
          ),
        DoldaButtonVariant.outline => OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _buildChild(),
          ),
        DoldaButtonVariant.text => TextButton(
            onPressed: isLoading ? null : onPressed,
            child: _buildChild(),
          ),
      },
    );
  }

  Widget _buildChild() {
    if (isLoading) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }
    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 16)),
        ],
      );
    }
    return Text(label, style: const TextStyle(fontSize: 16));
  }
}

enum DoldaButtonVariant { primary, outline, text }
