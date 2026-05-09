import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/ob_bottom_bar.dart';
import '../../../core/constants/app_colors.dart';
import '../providers/space_form_provider.dart';
import 'onboarding_screen.dart';

class Step3cPricing extends ConsumerStatefulWidget {
  const Step3cPricing({super.key});

  @override
  ConsumerState<Step3cPricing> createState() => _Step3cPricingState();
}

class _Step3cPricingState extends ConsumerState<Step3cPricing>
    with SingleTickerProviderStateMixin {
  final _rateCtrl = TextEditingController();
  final _minHoursCtrl = TextEditingController();
  final List<String> _selectedDays = [];
  String? _availableFrom;
  String? _availableUntil;
  bool _submitted = false;
  late AnimationController _animCtrl;
  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;

  final List<String> _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  final List<String> _times = [
    '12:00 AM',
    '1:00 AM',
    '2:00 AM',
    '3:00 AM',
    '4:00 AM',
    '5:00 AM',
    '6:00 AM',
    '7:00 AM',
    '8:00 AM',
    '9:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '1:00 PM',
    '2:00 PM',
    '3:00 PM',
    '4:00 PM',
    '5:00 PM',
    '6:00 PM',
    '7:00 PM',
    '8:00 PM',
    '9:00 PM',
    '10:00 PM',
    '11:00 PM',
  ];

  @override
  void initState() {
    super.initState();
    final saved = ref.read(spaceFormProvider);
    _rateCtrl.text = saved.hourlyRate;
    _minHoursCtrl.text = saved.minHours;
    _selectedDays.addAll(saved.availableDays);
    _availableFrom = saved.availableFrom;
    _availableUntil = saved.availableUntil;
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
    _rateCtrl.dispose();
    _minHoursCtrl.dispose();
    _animCtrl.dispose();
    super.dispose();
  }

  void _continue() {
    setState(() => _submitted = true);
    if (_rateCtrl.text.isEmpty || _selectedDays.isEmpty) return;
    ref.read(spaceFormProvider.notifier).update((s) => s.copyWith(
          hourlyRate: _rateCtrl.text.trim(),
          minHours: _minHoursCtrl.text.trim(),
          availableDays: List.from(_selectedDays),
          availableFrom: _availableFrom,
          availableUntil: _availableUntil,
        ));
    ref.read(obStepProvider.notifier).state = 5;
  }

  @override
  Widget build(BuildContext context) {
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
                          child: const Icon(Icons.home_outlined,
                              color: Color(0xFF383838), size: 24),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Center(
                      child: Text('Tell Us About Your Space',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary))),
                  const SizedBox(height: 4),
                  const Center(
                      child: Text('Set your rate',
                          style: TextStyle(
                              fontSize: 13, color: AppColors.textSecondary))),
                  const SizedBox(height: 28),
                  const Text('Pricing & Availability',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 16),
                  _label('Hourly Rate'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _rateCtrl,
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Enter hourly rate',
                      hintStyle:
                          const TextStyle(color: AppColors.textHint, fontSize: 13),
                      filled: true,
                      fillColor: _submitted && _rateCtrl.text.isEmpty
                          ? const Color(0xFFFFF5F5)
                          : Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 13),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: _submitted && _rateCtrl.text.isEmpty
                                  ? Colors.red
                                  : AppColors.border)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: _submitted && _rateCtrl.text.isEmpty
                                  ? Colors.red
                                  : AppColors.border)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                              color: _submitted && _rateCtrl.text.isEmpty
                                  ? Colors.red
                                  : AppColors.primary,
                              width: 1.5)),
                    ),
                  ),
                  if (_submitted && _rateCtrl.text.isEmpty)
                    _errorText('Hourly rate is required'),
                  const SizedBox(height: 16),
                  _label('Minimum Hours'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _minHoursCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Enter minimum hours',
                      hintStyle:
                          const TextStyle(color: AppColors.textHint, fontSize: 13),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 13),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppColors.border)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppColors.border)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: AppColors.primary, width: 1.5)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _label('Available Days'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 12,
                    runSpacing: 10,
                    children: _days.map((day) {
                      final selected = _selectedDays.contains(day);
                      return GestureDetector(
                        onTap: () => setState(() {
                          if (selected) {
                            _selectedDays.remove(day);
                          } else {
                            _selectedDays.add(day);
                          }
                        }),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                    color: selected
                                        ? AppColors.primary
                                        : const Color(0xFFD1D5DB),
                                    width: 1.5),
                                color: selected
                                    ? AppColors.primary
                                    : Colors.transparent,
                              ),
                              child: selected
                                  ? const Icon(Icons.check,
                                      size: 11, color: Colors.white)
                                  : null,
                            ),
                            const SizedBox(width: 6),
                            Text(day,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: selected
                                        ? AppColors.primary
                                        : AppColors.textSecondary)),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  if (_submitted && _selectedDays.isEmpty)
                    _errorText('Please select at least one day'),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label('Available From'),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              initialValue: _availableFrom,
                              hint: const Text('Choose time',
                                  style: TextStyle(
                                      color: AppColors.textHint, fontSize: 13)),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 13),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide:
                                        const BorderSide(color: AppColors.border)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide:
                                        const BorderSide(color: AppColors.border)),
                              ),
                              items: _times
                                  .map((t) => DropdownMenuItem(
                                      value: t,
                                      child: Text(t,
                                          style:
                                              const TextStyle(fontSize: 13))))
                                  .toList(),
                              onChanged: (v) =>
                                  setState(() => _availableFrom = v),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label('Available Until'),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              initialValue: _availableUntil,
                              hint: const Text('Choose time',
                                  style: TextStyle(
                                      color: AppColors.textHint, fontSize: 13)),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 13),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide:
                                        const BorderSide(color: AppColors.border)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide:
                                        const BorderSide(color: AppColors.border)),
                              ),
                              items: _times
                                  .map((t) => DropdownMenuItem(
                                      value: t,
                                      child: Text(t,
                                          style:
                                              const TextStyle(fontSize: 13))))
                                  .toList(),
                              onChanged: (v) =>
                                  setState(() => _availableUntil = v),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  obBottomBar(
                    onBack: () => ref.read(obStepProvider.notifier).state = 3,
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
