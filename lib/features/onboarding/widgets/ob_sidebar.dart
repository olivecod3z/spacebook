import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class ObSidebar extends StatelessWidget {
  final int currentStep;

  const ObSidebar({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      height: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset('assets/images/logo.png', width: 24, height: 24),
              const SizedBox(width: 6),
              const Text(
                'SPACEBOOK',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  fontSize: 20,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          _SidebarItem(
            number: 1,
            label: 'Welcome',
            state: _itemState(0, currentStep),
          ),
          const SizedBox(height: 20),
          _SidebarItem(
            number: 2,
            label: 'Personal Information',
            state: _itemState(1, currentStep),
          ),
          const SizedBox(height: 20),
          _SidebarItem(
            number: 3,
            label: 'Space Details',
            state: _itemState(2, currentStep),
            hasArrow: currentStep >= 2 && currentStep <= 5,
          ),
          const SizedBox(height: 20),
          _SidebarItem(
            number: 4,
            label: 'KYC Verification',
            state: _itemState(6, currentStep),
          ),
          
        ],
      ),
    );
  }

  _ItemState _itemState(int itemStep, int current) {
    if (current > itemStep) return _ItemState.done;
    if (current == itemStep) return _ItemState.active;
    return _ItemState.idle;
  }
}

enum _ItemState { idle, active, done }

class _SidebarItem extends StatelessWidget {
  final int number;
  final String label;
  final _ItemState state;
  final bool hasArrow;

  const _SidebarItem({
    required this.number,
    required this.label,
    required this.state,
    this.hasArrow = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDone = state == _ItemState.done;
    final isActive = state == _ItemState.active;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: isActive
          ? BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  spreadRadius: 0,
                  offset: const Offset(0, 2),
                ),
              ],
            )
          : const BoxDecoration(color: Colors.transparent),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDone
                  ? const Color(0xFF17803D) // green when done
                  : isActive
                      ? AppColors.primary // blue when active
                      : Colors.white, // empty when idle
              border: Border.all(
                color: isDone
                    ? const Color(0xFF17803D)
                    : isActive
                        ? AppColors.primary
                        : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Center(
              child: isDone
                  ? const Icon(Icons.check, color: Colors.white, size: 13)
                  : Text(
                      '$number',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color:
                            isActive ? Colors.white : AppColors.textSecondary,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: (isDone || isActive)
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
              ),
            ),
          ),
          if (isActive)
            const Icon(Icons.chevron_right, size: 16, color: Color(0xFF525866)),
        ],
      ),
    );
  }
}
