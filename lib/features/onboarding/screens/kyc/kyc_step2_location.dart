import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:spacebook/core/constants/app_colors.dart';
import 'package:spacebook/features/onboarding/providers/kyc_form_provider.dart';
import 'package:spacebook/features/onboarding/screens/kyc/kyc_router.dart';
import 'package:spacebook/features/onboarding/widgets/ob_bottom_bar.dart';

class KycStep2Location extends ConsumerStatefulWidget {
  const KycStep2Location({super.key});

  @override
  ConsumerState<KycStep2Location> createState() => _KycStep2LocationState();
}

class _KycStep2LocationState extends ConsumerState<KycStep2Location>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;
  late TextEditingController _streetCtrl;
  late TextEditingController _zipCtrl;
  bool _submitted = false;

  static const _cities = [
    'Lagos',
    'Abuja',
    'Port Harcourt',
    'Ibadan',
    'Kano',
    'Enugu',
    'Benin City',
    'Kaduna',
    'Warri',
    'Owerri',
  ];

  static const _states = [
    'Abia',
    'Adamawa',
    'Akwa Ibom',
    'Anambra',
    'Bauchi',
    'Bayelsa',
    'Benue',
    'Borno',
    'Cross River',
    'Delta',
    'Ebonyi',
    'Edo',
    'Ekiti',
    'Enugu',
    'FCT',
    'Gombe',
    'Imo',
    'Jigawa',
    'Kaduna',
    'Kano',
    'Katsina',
    'Kebbi',
    'Kogi',
    'Kwara',
    'Lagos',
    'Nasarawa',
    'Niger',
    'Ogun',
    'Ondo',
    'Osun',
    'Oyo',
    'Plateau',
    'Rivers',
    'Sokoto',
    'Taraba',
    'Yobe',
    'Zamfara',
  ];

  @override
  void initState() {
    super.initState();
    final saved = ref.read(kycFormProvider);
    _streetCtrl = TextEditingController(text: saved.streetAddress);
    _zipCtrl = TextEditingController(text: saved.zipCode);
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
    _streetCtrl.dispose();
    _zipCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg'],
      withData: true,
    );
    if (result != null && result.files.first.bytes != null) {
      ref.read(kycFormProvider.notifier).updateLocation(
            addressFileBytes: result.files.first.bytes,
            addressFileName: result.files.first.name,
          );
    }
  }

  void _continue() {
    setState(() => _submitted = true);
    final form = ref.read(kycFormProvider);
    if (_streetCtrl.text.isEmpty ||
        form.city == null ||
        form.state == null ||
        _zipCtrl.text.isEmpty ||
        form.addressFileBytes == null) return;
    ref.read(kycFormProvider.notifier).updateLocation(
          streetAddress: _streetCtrl.text,
          zipCode: _zipCtrl.text,
        );
    ref.read(kycStepProvider.notifier).state = 2;
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

                  // ── Updated section heading ──
                  const Text('Your Residential Address',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  const Text(
                    'This is where you live — not the address of your space. We use this to verify your identity.',
                    style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.5),
                  ),
                  const SizedBox(height: 20),

                  _label('Street Address'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _streetCtrl,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Enter your home street address',
                      hintStyle: const TextStyle(
                          color: AppColors.textHint, fontSize: 13),
                      prefixIcon: const Icon(Icons.location_on_outlined,
                          size: 18, color: AppColors.textHint),
                      filled: true,
                      fillColor: _submitted && _streetCtrl.text.isEmpty
                          ? const Color(0xFFFFF5F5)
                          : Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 13),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: _submitted && _streetCtrl.text.isEmpty
                                  ? Colors.red
                                  : AppColors.border)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: _submitted && _streetCtrl.text.isEmpty
                                  ? Colors.red
                                  : AppColors.border)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: _submitted && _streetCtrl.text.isEmpty
                                  ? Colors.red
                                  : AppColors.primary,
                              width: 1.5)),
                    ),
                  ),
                  if (_submitted && _streetCtrl.text.isEmpty)
                    _errorText('Street address is required'),
                  const SizedBox(height: 16),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label('City'),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              value: form.city,
                              hint: const Text('Select City',
                                  style: TextStyle(
                                      color: AppColors.textHint, fontSize: 13)),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: _submitted && form.city == null
                                    ? const Color(0xFFFFF5F5)
                                    : Colors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 13),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: _submitted && form.city == null
                                            ? Colors.red
                                            : AppColors.border)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: _submitted && form.city == null
                                            ? Colors.red
                                            : AppColors.border)),
                              ),
                              items: _cities
                                  .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e,
                                          style:
                                              const TextStyle(fontSize: 13))))
                                  .toList(),
                              onChanged: (v) => ref
                                  .read(kycFormProvider.notifier)
                                  .updateLocation(city: v),
                            ),
                            if (_submitted && form.city == null)
                              _errorText('Required'),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label('State'),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              value: form.state,
                              hint: const Text('Select State',
                                  style: TextStyle(
                                      color: AppColors.textHint, fontSize: 13)),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: _submitted && form.state == null
                                    ? const Color(0xFFFFF5F5)
                                    : Colors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 13),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: _submitted && form.state == null
                                            ? Colors.red
                                            : AppColors.border)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: _submitted && form.state == null
                                            ? Colors.red
                                            : AppColors.border)),
                              ),
                              items: _states
                                  .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e,
                                          style:
                                              const TextStyle(fontSize: 13))))
                                  .toList(),
                              onChanged: (v) => ref
                                  .read(kycFormProvider.notifier)
                                  .updateLocation(state: v),
                            ),
                            if (_submitted && form.state == null)
                              _errorText('Required'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _label('ZIP Code'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _zipCtrl,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Enter ZIP code',
                      hintStyle: const TextStyle(
                          color: AppColors.textHint, fontSize: 13),
                      filled: true,
                      fillColor: _submitted && _zipCtrl.text.isEmpty
                          ? const Color(0xFFFFF5F5)
                          : Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 13),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: _submitted && _zipCtrl.text.isEmpty
                                  ? Colors.red
                                  : AppColors.border)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: _submitted && _zipCtrl.text.isEmpty
                                  ? Colors.red
                                  : AppColors.border)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: _submitted && _zipCtrl.text.isEmpty
                                  ? Colors.red
                                  : AppColors.primary,
                              width: 1.5)),
                    ),
                  ),
                  if (_submitted && _zipCtrl.text.isEmpty)
                    _errorText('ZIP code is required'),
                  const SizedBox(height: 16),

                  const Text(
                      'Upload a Utility Bill or Bank Statement (less than 3 months old)',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: _pickFile,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _submitted && form.addressFileBytes == null
                              ? Colors.red
                              : const Color(0xFFE2E4E9),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            form.addressFileBytes != null
                                ? Icons.check_circle_outline
                                : Icons.cloud_upload_outlined,
                            size: 32,
                            color: form.addressFileBytes != null
                                ? AppColors.accent
                                : AppColors.textHint,
                          ),
                          const SizedBox(height: 8),
                          if (form.addressFileBytes != null &&
                              form.addressFileName != null)
                            Text(form.addressFileName!,
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
                  if (_submitted && form.addressFileBytes == null)
                    _errorText('Please upload a proof of address'),

                  const SizedBox(height: 32),
                  obBottomBar(
                    onBack: () => ref.read(kycStepProvider.notifier).state = 0,
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
