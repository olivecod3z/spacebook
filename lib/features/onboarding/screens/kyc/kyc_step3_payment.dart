import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spacebook/core/constants/app_colors.dart';
import 'package:spacebook/features/onboarding/providers/kyc_form_provider.dart';
import 'package:spacebook/features/onboarding/screens/kyc/kyc_router.dart';
import 'package:spacebook/features/onboarding/widgets/ob_bottom_bar.dart';
import 'package:spacebook/shared/navigation/app_router.dart';

class KycStep3Payment extends ConsumerStatefulWidget {
  const KycStep3Payment({super.key});

  @override
  ConsumerState<KycStep3Payment> createState() => _KycStep3PaymentState();
}

class _KycStep3PaymentState extends ConsumerState<KycStep3Payment>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;
  late TextEditingController _nameCtrl;
  late TextEditingController _accountCtrl;
  bool _submitted = false;

  static const _banks = [
    'Access Bank',
    'First Bank',
    'GTBank',
    'UBA',
    'Zenith Bank',
    'Ecobank',
    'Fidelity Bank',
    'FCMB',
    'Stanbic IBTC',
    'Sterling Bank',
    'Union Bank',
    'Wema Bank',
    'Polaris Bank',
    'Keystone Bank',
  ];

  static const _schedules = ['Daily', 'Weekly', 'Bi-weekly', 'Monthly'];

  @override
  void initState() {
    super.initState();
    final saved = ref.read(kycFormProvider);
    _nameCtrl = TextEditingController(text: saved.accountHolderName);
    _accountCtrl = TextEditingController(text: saved.accountNumber);
    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));
    _fadeAnim = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _nameCtrl.dispose();
    _accountCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() => _submitted = true);
    final form = ref.read(kycFormProvider);
    if (_nameCtrl.text.isEmpty ||
        _accountCtrl.text.isEmpty ||
        form.bank == null ||
        form.payoutSchedule == null) return;
    ref.read(kycFormProvider.notifier).updatePayment(
          accountHolderName: _nameCtrl.text,
          accountNumber: _accountCtrl.text,
        );
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRouter.dashboard,
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(kycFormProvider);
    final isMobile = MediaQuery.of(context).size.width < 768;

    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 24 : 80, vertical: 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon header
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ShaderMask(
                          shaderCallback: (rect) => const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white,
                              Colors.white,
                              Colors.transparent
                            ],
                            stops: [0.0, 0.45, 0.75],
                          ).createShader(rect),
                          blendMode: BlendMode.dstIn,
                          child: Container(
                            width: 88,
                            height: 88,
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
                                  color: const Color(0xFFE2E4E9), width: 1),
                            ),
                          ),
                        ),
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(
                                color: const Color(0xFFE2E4E9), width: 1),
                          ),
                          child: const Icon(Icons.shield_outlined,
                              color: Color(0xFF383838), size: 24),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text('Account Verification',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary)),
                  ),
                  const SizedBox(height: 4),
                  const Center(
                    child: Text(
                      'Complete your verification to unlock all features\nand build trust with guests.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          height: 1.5),
                    ),
                  ),
                  const SizedBox(height: 28),

                  const Text('Payment Verification',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  const Text('Add your bank details for payouts',
                      style: TextStyle(
                          fontSize: 13, color: AppColors.textSecondary)),
                  const SizedBox(height: 20),

                  _label('Account Holder Name'),
                  const SizedBox(height: 6),
                  _textField(
                    ctrl: _nameCtrl,
                    hint: 'Enter account name',
                    isEmpty: _submitted && _nameCtrl.text.isEmpty,
                    onChanged: (_) => setState(() {}),
                  ),
                  if (_submitted && _nameCtrl.text.isEmpty)
                    _errorText('Account holder name is required'),
                  const SizedBox(height: 16),

                  _label('Account Number'),
                  const SizedBox(height: 6),
                  _textField(
                    ctrl: _accountCtrl,
                    hint: 'Enter account number',
                    isEmpty: _submitted && _accountCtrl.text.isEmpty,
                    onChanged: (_) => setState(() {}),
                    type: TextInputType.number,
                  ),
                  if (_submitted && _accountCtrl.text.isEmpty)
                    _errorText('Account number is required'),
                  const SizedBox(height: 16),

                  _label('Bank'),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: form.bank,
                    hint: const Text('Choose bank',
                        style:
                            TextStyle(color: AppColors.textHint, fontSize: 13)),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: _submitted && form.bank == null
                          ? const Color(0xFFFFF5F5)
                          : Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 13),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: _submitted && form.bank == null
                                  ? Colors.red
                                  : AppColors.border)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: _submitted && form.bank == null
                                  ? Colors.red
                                  : AppColors.border)),
                    ),
                    items: _banks
                        .map((e) => DropdownMenuItem(
                            value: e,
                            child:
                                Text(e, style: const TextStyle(fontSize: 13))))
                        .toList(),
                    onChanged: (v) => ref
                        .read(kycFormProvider.notifier)
                        .updatePayment(bank: v),
                  ),
                  if (_submitted && form.bank == null)
                    _errorText('Please select a bank'),
                  const SizedBox(height: 16),

                  _label('Payout Schedule'),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: form.payoutSchedule,
                    hint: const Text('Choose a day to receive your money',
                        style:
                            TextStyle(color: AppColors.textHint, fontSize: 13)),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: _submitted && form.payoutSchedule == null
                          ? const Color(0xFFFFF5F5)
                          : Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 13),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: _submitted && form.payoutSchedule == null
                                  ? Colors.red
                                  : AppColors.border)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: _submitted && form.payoutSchedule == null
                                  ? Colors.red
                                  : AppColors.border)),
                    ),
                    items: _schedules
                        .map((e) => DropdownMenuItem(
                            value: e,
                            child:
                                Text(e, style: const TextStyle(fontSize: 13))))
                        .toList(),
                    onChanged: (v) => ref
                        .read(kycFormProvider.notifier)
                        .updatePayment(payoutSchedule: v),
                  ),
                  if (_submitted && form.payoutSchedule == null)
                    _errorText('Please select a payout schedule'),

                  const SizedBox(height: 32),
                  obBottomBar(
                    onBack: () => ref.read(kycStepProvider.notifier).state = 1,
                    onContinue: _submit,
                    continueLabel: 'Submit',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Text(text,
      style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary));

  Widget _errorText(String msg) => Padding(
      padding: const EdgeInsets.only(top: 4),
      child:
          Text(msg, style: const TextStyle(fontSize: 11, color: Colors.red)));

  Widget _textField({
    required TextEditingController ctrl,
    required String hint,
    required bool isEmpty,
    required Function(String) onChanged,
    TextInputType type = TextInputType.text,
  }) {
    return TextFormField(
      controller: ctrl,
      onChanged: onChanged,
      keyboardType: type,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 13),
        filled: true,
        fillColor: isEmpty ? const Color(0xFFFFF5F5) : Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:
                BorderSide(color: isEmpty ? Colors.red : AppColors.border)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:
                BorderSide(color: isEmpty ? Colors.red : AppColors.border)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
                color: isEmpty ? Colors.red : AppColors.primary, width: 1.5)),
      ),
    );
  }
}
