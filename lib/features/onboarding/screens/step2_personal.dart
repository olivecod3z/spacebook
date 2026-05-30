import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/auth_provider.dart';
import '../../../features/auth/screens/verify_email_screen.dart';
import 'onboarding_screen.dart';

class Step2Personal extends ConsumerStatefulWidget {
  const Step2Personal({super.key});

  @override
  ConsumerState<Step2Personal> createState() => _Step2PersonalState();
}

class _Step2PersonalState extends ConsumerState<Step2Personal> {
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscure = true;
  bool _submitted = false;
  String? _emailError;

  bool get _hasLength =>
      _passwordCtrl.text.length >= 8 && _passwordCtrl.text.length <= 20;
  bool get _hasUpper => _passwordCtrl.text.contains(RegExp(r'[A-Z]'));
  bool get _hasLower => _passwordCtrl.text.contains(RegExp(r'[a-z]'));
  bool get _hasNumber => _passwordCtrl.text.contains(RegExp(r'[0-9]'));
  bool get _hasSymbol =>
      _passwordCtrl.text.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'));
  bool get _passwordValid =>
      _hasLength && _hasUpper && _hasLower && _hasNumber && _hasSymbol;

  @override
  void initState() {
    super.initState();
    _passwordCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    setState(() {
      _submitted = true;
      _emailError = null;
    });

    if (_firstNameCtrl.text.isEmpty ||
        _lastNameCtrl.text.isEmpty ||
        _emailCtrl.text.isEmpty ||
        _passwordCtrl.text.isEmpty ||
        !_passwordValid) {
      return;
    }

    final fullName =
        '${_firstNameCtrl.text.trim()} ${_lastNameCtrl.text.trim()}';

    try {
      final success = await ref.read(authNotifierProvider.notifier).signUp(
            email: _emailCtrl.text.trim(),
            password: _passwordCtrl.text.trim(),
            fullName: fullName,
            phone: _phoneCtrl.text.trim(),
          );

      if (!mounted) return;
      if (success) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => VerifyEmailScreen(
              email: _emailCtrl.text.trim(),
              password: _passwordCtrl.text.trim(), // add this
              onConfirmed: () {
                if (!mounted) return;
                Navigator.of(context).pop();
                ref.read(obStepProvider.notifier).state = 2;
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      debugPrint('SIGNUP ERROR: ${e.toString()}');
      final err = e.toString().toLowerCase();
      if (err.contains('already registered') ||
          err.contains('already exists') ||
          err.contains('duplicate')) {
        setState(() => _emailError = 'This email is already in use.');
      } else if (err.contains('phone')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('This phone number is already registered.'),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else if (err.contains('network') || err.contains('fetch')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
                'Network error. Check your connection and try again.'),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Something went wrong. Please try again.'),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authNotifierProvider).isLoading;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 80,
        vertical: 32,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  ShaderMask(
                    shaderCallback: (rect) {
                      return const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white,
                          Colors.white,
                          Colors.transparent
                        ],
                        stops: [0.0, 0.45, 0.75],
                      ).createShader(rect);
                    },
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
                          color: const Color(0xFFE2E4E9),
                          width: 1,
                        ),
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
                        color: const Color(0xFFE2E4E9),
                        width: 1,
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.person_outline,
                        color: AppColors.textPrimary,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              const Text(
                'Tell Us About Yourself',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'This information would be shown on your public profile.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 28),
              _field('First Name', 'Enter name', _firstNameCtrl),
              const SizedBox(height: 14),
              _field('Last Name', 'Enter name', _lastNameCtrl),
              const SizedBox(height: 14),
              _field(
                  'Booking Contact', 'Enter booking contact number', _phoneCtrl,
                  type: TextInputType.phone),
              const SizedBox(height: 14),
              _field('Email Address', 'Enter your email address', _emailCtrl,
                  type: TextInputType.emailAddress, externalError: _emailError),
              const SizedBox(height: 4),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "We'd use this to send booking notifications",
                  style:
                      TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
              ),
              const SizedBox(height: 14),
              _field('Password', 'Create a password', _passwordCtrl,
                  obscure: _obscure,
                  suffix: IconButton(
                    icon: Icon(
                      _obscure ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.textHint,
                      size: 18,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  )),
              if (_passwordCtrl.text.isNotEmpty) ...[
                const SizedBox(height: 10),
                _PasswordConditions(
                  hasLength: _hasLength,
                  hasUpper: _hasUpper,
                  hasLower: _hasLower,
                  hasNumber: _hasNumber,
                  hasSymbol: _hasSymbol,
                ),
              ],
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () =>
                        ref.read(obStepProvider.notifier).state = 0,
                    icon: const Icon(Icons.arrow_back, size: 16),
                    label: const Text('Back'),
                    style: TextButton.styleFrom(
                        foregroundColor: AppColors.textSecondary),
                  ),
                  SizedBox(
                    height: 44,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _continue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white))
                          : const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Continue',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600)),
                                SizedBox(width: 6),
                                Text('→',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600)),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(
    String label,
    String hint,
    TextEditingController ctrl, {
    TextInputType type = TextInputType.text,
    bool obscure = false,
    Widget? suffix,
    String? externalError,
  }) {
    final isEmpty = _submitted && ctrl.text.isEmpty;
    final hasError = isEmpty || externalError != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: hasError ? Colors.red : AppColors.textPrimary)),
        const SizedBox(height: 6),
        TextFormField(
          controller: ctrl,
          keyboardType: type,
          obscureText: obscure,
          onChanged: (_) => setState(() {
            if (externalError != null) _emailError = null;
          }),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 13),
            suffixIcon: suffix,
            filled: true,
            fillColor: hasError ? const Color(0xFFFFF5F5) : AppColors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  BorderSide(color: hasError ? Colors.red : AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  BorderSide(color: hasError ? Colors.red : AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                  color: hasError ? Colors.red : AppColors.primary, width: 1.5),
            ),
          ),
        ),
        if (isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text('$label is required',
                style: const TextStyle(fontSize: 11, color: Colors.red)),
          ),
        if (!isEmpty && externalError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(externalError,
                style: const TextStyle(fontSize: 11, color: Colors.red)),
          ),
      ],
    );
  }
}

class _PasswordConditions extends StatelessWidget {
  final bool hasLength;
  final bool hasUpper;
  final bool hasLower;
  final bool hasNumber;
  final bool hasSymbol;

  const _PasswordConditions({
    required this.hasLength,
    required this.hasUpper,
    required this.hasLower,
    required this.hasNumber,
    required this.hasSymbol,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E4E9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _condition('8–20 characters', hasLength),
          const SizedBox(height: 6),
          _condition('At least one uppercase letter (A–Z)', hasUpper),
          const SizedBox(height: 6),
          _condition('At least one lowercase letter (a–z)', hasLower),
          const SizedBox(height: 6),
          _condition('At least one number (0–9)', hasNumber),
          const SizedBox(height: 6),
          _condition('At least one symbol (!@#\$%^&*...)', hasSymbol),
        ],
      ),
    );
  }

  Widget _condition(String label, bool met) {
    return Row(
      children: [
        Icon(
          met ? Icons.check_circle : Icons.radio_button_unchecked,
          size: 14,
          color: met ? const Color(0xFF17803D) : const Color(0xFF868C98),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: met ? const Color(0xFF17803D) : const Color(0xFF868C98),
          ),
        ),
      ],
    );
  }
}
