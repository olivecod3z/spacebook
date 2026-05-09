import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/ob_bottom_bar.dart';
import '../../../core/constants/app_colors.dart';
import '../providers/space_form_provider.dart';
import 'onboarding_screen.dart';

class Step3aBasic extends ConsumerStatefulWidget {
  const Step3aBasic({super.key});

  @override
  ConsumerState<Step3aBasic> createState() => _Step3aBasicState();
}

class _Step3aBasicState extends ConsumerState<Step3aBasic>
    with SingleTickerProviderStateMixin {
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String? _spaceType;
  String? _capacity;
  bool _submitted = false;
  late AnimationController _animCtrl;
  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;

  final List<String> _spaceTypes = [
    'Content House',
    'Podcast Studio',
    'Streaming Studio',
    'Photo Studio',
  ];

  final List<String> _capacities = [
    '1-5 guests',
    '6-10 guests',
    '11-20 guests',
    '21-50 guests',
    '50+ guests',
  ];

  @override
  void initState() {
    super.initState();
    final saved = ref.read(spaceFormProvider);
    _nameCtrl.text = saved.spaceName;
    _descCtrl.text = saved.description;
    _spaceType = saved.spaceType;
    _capacity = saved.capacity;
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut),
    );
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _animCtrl.dispose();
    super.dispose();
  }

  void _continue() {
    setState(() => _submitted = true);
    if (_nameCtrl.text.isEmpty || _spaceType == null || _capacity == null) {
      return;
    }
    ref.read(spaceFormProvider.notifier).update((s) => s.copyWith(
          spaceName: _nameCtrl.text.trim(),
          spaceType: _spaceType,
          description: _descCtrl.text.trim(),
          capacity: _capacity,
        ));
    ref.read(obStepProvider.notifier).state = 3;
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
            horizontal: isMobile ? 24 : 80,
            vertical: 32,
          ),
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
                    child: Text(
                      'Tell Us About Your Space',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Center(
                    child: Text(
                      'Provide details about your space to attract guests.',
                      style: TextStyle(
                          fontSize: 13, color: AppColors.textSecondary),
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text('Basic Information',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 16),
                  _label('Space Name'),
                  const SizedBox(height: 6),
                  _textField(
                    ctrl: _nameCtrl,
                    hint: "e.g Judi's studio",
                    isEmpty: _submitted && _nameCtrl.text.isEmpty,
                    onChanged: (_) => setState(() {}),
                  ),
                  if (_submitted && _nameCtrl.text.isEmpty)
                    _errorText('Space Name is required'),
                  const SizedBox(height: 16),
                  _label('Space Type'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 12,
                    runSpacing: 10,
                    children: _spaceTypes.map((type) {
                      final selected = _spaceType == type;
                      return GestureDetector(
                        onTap: () => setState(() => _spaceType = type),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: selected
                                      ? AppColors.primary
                                      : const Color(0xFFD1D5DB),
                                  width: 1.5,
                                ),
                              ),
                              child: selected
                                  ? Center(
                                      child: Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.primary),
                                      ),
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 6),
                            Text(type,
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
                  if (_submitted && _spaceType == null)
                    _errorText('Please select a space type'),
                  const SizedBox(height: 16),
                  _label('Description'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _descCtrl,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText:
                          'Describe your space, what makes it unique, and what\'s it best for',
                      hintStyle: const TextStyle(
                          color: AppColors.textHint, fontSize: 13),
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
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                              color: AppColors.primary, width: 1.5)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _label('Space Capacity'),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    initialValue: _capacity,
                    hint: const Text('Select maximum number of guest',
                        style:
                            TextStyle(color: AppColors.textHint, fontSize: 13)),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 13),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                            color: _submitted && _capacity == null
                                ? Colors.red
                                : AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                            color: _submitted && _capacity == null
                                ? Colors.red
                                : AppColors.border),
                      ),
                    ),
                    items: _capacities
                        .map((c) => DropdownMenuItem(
                            value: c,
                            child:
                                Text(c, style: const TextStyle(fontSize: 13))))
                        .toList(),
                    onChanged: (v) => setState(() => _capacity = v),
                  ),
                  if (_submitted && _capacity == null)
                    _errorText('Please select a capacity'),
                  const SizedBox(height: 32),
                  obBottomBar(
                    onBack: () => ref.read(obStepProvider.notifier).state = 1,
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

  Widget _textField({
    required TextEditingController ctrl,
    required String hint,
    required bool isEmpty,
    Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: ctrl,
      onChanged: onChanged,
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
