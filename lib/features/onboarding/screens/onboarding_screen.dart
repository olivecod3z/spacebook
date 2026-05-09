import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spacebook/features/onboarding/screens/kyc/kyc_router.dart';
import 'package:spacebook/features/onboarding/screens/step3a_basic.dart';
import 'package:spacebook/features/onboarding/screens/step3b_location.dart';
import 'package:spacebook/features/onboarding/screens/step3c_pricing.dart';
import 'package:spacebook/features/onboarding/screens/step3d_amenities.dart';
import '../../../core/constants/app_colors.dart';
import '../widgets/ob_sidebar.dart';
import 'step1_welcome.dart';
import 'step2_personal.dart';

final obStepProvider = StateProvider<int>((ref) => 0);

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final step = ref.watch(obStepProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Scaffold(
      backgroundColor: Colors.white,
      body:
          isMobile ? _buildMobileLayout(step, ref) : _buildDesktopLayout(step),
    );
  }

  Widget _buildDesktopLayout(int step) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Floating sidebar
        Padding(
          padding: const EdgeInsets.all(7),
          child: ObSidebar(currentStep: step),
        ),
        // Right content — no background, dots show through from scaffold
        Expanded(child: _buildStep(step)),
      ],
    );
  }

  Widget _buildMobileLayout(int step, WidgetRef ref) {
    final steps = [
      'Welcome',
      'Personal Information',
      'Space Details',
      'KYC Verification',
    ];

    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Image.asset('assets/images/logo.png', width: 24, height: 24),
              const SizedBox(width: 6),
              const Text(
                'SPACEBOOK',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                  fontSize: 13,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        Container(
          color: Colors.white,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: List.generate(steps.length, (index) {
                final isDone = step > index;
                final isActive = step == index;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (isDone || isActive)
                              ? AppColors.primary
                              : Colors.transparent,
                          border: Border.all(
                            color: (isDone || isActive)
                                ? AppColors.primary
                                : const Color(0xFFD1D5DB),
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: isDone
                              ? const Icon(Icons.check,
                                  color: Colors.white, size: 12)
                              : Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: isActive
                                        ? Colors.white
                                        : AppColors.textSecondary,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        steps[index],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight:
                              isActive ? FontWeight.w600 : FontWeight.normal,
                          color: (isDone || isActive)
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                        ),
                      ),
                      if (index < steps.length - 1)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Container(
                            width: 20,
                            height: 1,
                            color: const Color(0xFFE2E4E9),
                          ),
                        ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
        Expanded(child: _buildStep(step)),
      ],
    );
  }

  Widget _buildStep(int step) {
    switch (step) {
      case 0:
        return const Step1Welcome();
      case 1:
        return const Step2Personal();
      case 2:
        return const Step3aBasic();
      case 3:
        return const Step3bLocation();
      case 4:
        return const Step3cPricing();
      case 5:
        return const Step3dAmenities();
      case 6:
        return const KycRouter();
      default:
        return const Step1Welcome();
    }
  }
}
