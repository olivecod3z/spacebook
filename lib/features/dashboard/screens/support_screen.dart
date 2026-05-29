import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spacebook/features/dashboard/screens/dashboard_screen.dart';
import '../../../core/constants/app_colors.dart';

class SupportScreen extends ConsumerWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── BACK BUTTON — paste at top of Column in build() ──
          GestureDetector(
            onTap: () => ref.read(dashboardIndexProvider.notifier).state = 1,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.arrow_back_ios,
                    size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                const Text('Back',
                    style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text('Support',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          const Text('Start a chat with our support team if you need help',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
          const SizedBox(height: 80),

          // Illustration + CTA
          Center(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/support_empty_img.png',
                  width: isMobile ? 180 : 260,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.headset_mic_outlined,
                    size: isMobile ? 80 : 120,
                    color: AppColors.border,
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  'Reach out to our support team\nanytime and we\'ll you sort things out',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: isMobile ? 15 : 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                      height: 1.6),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: launch WhatsApp URL
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                    ),
                    child: const Text('Chat With Us On Whatsapp',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
