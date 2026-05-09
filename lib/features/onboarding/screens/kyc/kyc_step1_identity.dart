import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:spacebook/core/constants/app_colors.dart';
import 'package:spacebook/features/onboarding/providers/kyc_form_provider.dart';
import 'package:spacebook/features/onboarding/screens/kyc/kyc_router.dart';
import 'package:spacebook/features/onboarding/screens/onboarding_screen.dart';
import 'package:spacebook/features/onboarding/widgets/ob_bottom_bar.dart';

class KycStep1Identity extends ConsumerStatefulWidget {
  const KycStep1Identity({super.key});

  @override
  ConsumerState<KycStep1Identity> createState() => _KycStep1IdentityState();
}

class _KycStep1IdentityState extends ConsumerState<KycStep1Identity>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;
  late TextEditingController _idNumberCtrl;
  bool _submitted = false;

  static const _idTypes = [
    "Driver's License",
    'National ID (NIN)',
    'International Passport',
    "Voter's Card",
  ];

  @override
  void initState() {
    super.initState();
    final saved = ref.read(kycFormProvider);
    _idNumberCtrl = TextEditingController(text: saved.idNumber);
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
    _idNumberCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['svg', 'png', 'jpg', 'gif'],
      withData: true,
    );
    if (result != null && result.files.first.bytes != null) {
      ref.read(kycFormProvider.notifier).updateIdentity(
            idFileBytes: result.files.first.bytes,
            idFileName: result.files.first.name,
          );
    }
  }

  void _continue() {
    setState(() => _submitted = true);
    final form = ref.read(kycFormProvider);
    if (form.idType == null ||
        _idNumberCtrl.text.isEmpty ||
        form.idFileBytes == null) return;
    ref
        .read(kycFormProvider.notifier)
        .updateIdentity(idNumber: _idNumberCtrl.text);
    ref.read(kycStepProvider.notifier).state = 1;
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

                  const Text('Account Verification',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  const Text('Upload a government-issued photo ID',
                      style: TextStyle(
                          fontSize: 13, color: AppColors.textSecondary)),
                  const SizedBox(height: 20),

                  _label('ID Type'),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: form.idType,
                    hint: const Text('e.g Drivers License',
                        style:
                            TextStyle(color: AppColors.textHint, fontSize: 13)),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: _submitted && form.idType == null
                          ? const Color(0xFFFFF5F5)
                          : Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 13),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: _submitted && form.idType == null
                                  ? Colors.red
                                  : AppColors.border)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: _submitted && form.idType == null
                                  ? Colors.red
                                  : AppColors.border)),
                    ),
                    items: _idTypes
                        .map((e) => DropdownMenuItem(
                            value: e,
                            child:
                                Text(e, style: const TextStyle(fontSize: 13))))
                        .toList(),
                    onChanged: (v) => ref
                        .read(kycFormProvider.notifier)
                        .updateIdentity(idType: v),
                  ),
                  if (_submitted && form.idType == null)
                    _errorText('Please select an ID type'),
                  const SizedBox(height: 16),

                  _label('ID Number'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _idNumberCtrl,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Enter your ID number',
                      hintStyle: const TextStyle(
                          color: AppColors.textHint, fontSize: 13),
                      filled: true,
                      fillColor: _submitted && _idNumberCtrl.text.isEmpty
                          ? const Color(0xFFFFF5F5)
                          : Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 13),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: _submitted && _idNumberCtrl.text.isEmpty
                                  ? Colors.red
                                  : AppColors.border)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: _submitted && _idNumberCtrl.text.isEmpty
                                  ? Colors.red
                                  : AppColors.border)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: _submitted && _idNumberCtrl.text.isEmpty
                                  ? Colors.red
                                  : AppColors.primary,
                              width: 1.5)),
                    ),
                  ),
                  if (_submitted && _idNumberCtrl.text.isEmpty)
                    _errorText('ID Number is required'),
                  const SizedBox(height: 16),

                  GestureDetector(
                    onTap: _pickFile,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _submitted && form.idFileBytes == null
                              ? Colors.red
                              : const Color(0xFFE2E4E9),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            form.idFileBytes != null
                                ? Icons.check_circle_outline
                                : Icons.cloud_upload_outlined,
                            size: 32,
                            color: form.idFileBytes != null
                                ? AppColors.accent
                                : AppColors.textHint,
                          ),
                          const SizedBox(height: 8),
                          if (form.idFileBytes != null &&
                              form.idFileName != null)
                            Text(form.idFileName!,
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.accent,
                                    fontWeight: FontWeight.w500))
                          else ...[
                            RichText(
                              text: const TextSpan(children: [
                                TextSpan(
                                    text: 'Click to upload',
                                    style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500)),
                                TextSpan(
                                    text: ' or drag and drop',
                                    style: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 13)),
                              ]),
                            ),
                            const SizedBox(height: 4),
                            const Text('SVG, PNG, JPG or GIF',
                                style: TextStyle(
                                    fontSize: 11, color: AppColors.textHint)),
                          ],
                        ],
                      ),
                    ),
                  ),
                  if (_submitted && form.idFileBytes == null)
                    _errorText('Please upload your ID document'),

                  const SizedBox(height: 32),
                  obBottomBar(
                    onBack: () => ref.read(obStepProvider.notifier).state = 5,
                    onContinue: _continue,
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
}
