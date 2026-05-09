import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

Widget obBottomBar({
  required VoidCallback onBack,
  required VoidCallback onContinue,
  String continueLabel = 'Continue',
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      TextButton.icon(
        onPressed: onBack,
        icon: const Icon(Icons.arrow_back, size: 16),
        label: const Text('Back'),
        style: TextButton.styleFrom(foregroundColor: AppColors.textSecondary),
      ),
      ElevatedButton(
        onPressed: onContinue,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
        child: Text(
          continueLabel,
          style: const TextStyle(fontWeight: FontWeight.w600),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
    ],
  );
}
