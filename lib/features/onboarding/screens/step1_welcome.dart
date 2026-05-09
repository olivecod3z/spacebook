import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spacebook/features/onboarding/widgets/dotted_background.dart';
import 'package:spacebook/shared/navigation/app_router.dart';
import '../../../core/constants/app_colors.dart';
import 'onboarding_screen.dart';

class Step1Welcome extends ConsumerWidget {
  const Step1Welcome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DottedBackground(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                // Outer circle — fades at bottom
                ShaderMask(
                  shaderCallback: (rect) {
                    return const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white,
                        Colors.white,
                        Colors.transparent,
                      ],
                      stops: [0.0, 0.45, 0.75],
                    ).createShader(rect);
                  },
                  blendMode: BlendMode.dstIn,
                  child: Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFFE4E5E7).withOpacity(0.48),
                          const Color(0xFFF7F8F8).withOpacity(0.0),
                          const Color(0xFFE4E5E7).withOpacity(0.0),
                        ],
                        stops: const [0.0, 1.0, 1.0],
                      ),
                      border: Border.all(
                        color: const Color(0xFFE2E4E9),
                        width: 1,
                      ),
                    ),
                  ),
                ),

                // Inner circle — no fade, fully visible
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(
                      color: const Color(0xFFE2E4E9),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/logo2.png',
                      width: 34,
                      height: 34,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Welcome To SpaceBook',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 12),
            const Text(
              'Turn your space into a revenue stream. List your studio, office or venue \nand start earning from the creative community in Nigeria.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14, color: AppColors.textSecondary, height: 1.6),
            ),
            const SizedBox(height: 36),
            SizedBox(
              width: 220,
              height: 48,
              child: ElevatedButton(
                onPressed: () => ref.read(obStepProvider.notifier).state = 1,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Let's Get You Started  →",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 15)),
                  ],
                ),
              ),
            ),
            // DEV ONLY
            TextButton(
              onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                AppRouter.dashboard,
                (_) => false,
              ),
              child: const Text('→ Skip to Dashboard',
                  style: TextStyle(fontSize: 12, color: AppColors.textHint)),
            ),
          ],
        ),
      ),
    );
  }
}
