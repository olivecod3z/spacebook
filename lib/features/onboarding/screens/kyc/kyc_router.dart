import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'kyc_step1_identity.dart';
import 'kyc_step2_location.dart';
import 'kyc_step3_payment.dart';

final kycStepProvider = StateProvider<int>((_) => 0);

class KycRouter extends ConsumerWidget {
  const KycRouter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final step = ref.watch(kycStepProvider);

    return switch (step) {
      0 => const KycStep1Identity(),
      1 => const KycStep2Location(),
      2 => const KycStep3Payment(),
      _ => const KycStep1Identity(),
    };
  }
}
