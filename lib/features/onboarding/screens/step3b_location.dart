import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/ob_bottom_bar.dart';
import '../../../core/constants/app_colors.dart';
import '../providers/space_form_provider.dart';
import 'onboarding_screen.dart';

const _apiKey = 'AIzaSyC-UCfp6YOjmfSzUM6Yvp5ceDAth94_vMU';

class Step3bLocation extends ConsumerStatefulWidget {
  const Step3bLocation({super.key});

  @override
  ConsumerState<Step3bLocation> createState() => _Step3bLocationState();
}

class _Step3bLocationState extends ConsumerState<Step3bLocation>
    with SingleTickerProviderStateMixin {
  final _streetCtrl = TextEditingController();
  final _zipCtrl = TextEditingController();
  String? _city;
  String? _state;
  bool _submitted = false;
  bool _showSuggestions = false;
  List<Map<String, String>> _suggestions = [];
  late AnimationController _animCtrl;
  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;

  final List<String> _cities = [
    'Aba',
    'Abeokuta',
    'Abuja',
    'Ado-Ekiti',
    'Akure',
    'Asaba',
    'Awka',
    'Bauchi',
    'Benin City',
    'Birnin Kebbi',
    'Calabar',
    'Damaturu',
    'Dutse',
    'Enugu',
    'Gombe',
    'Gusau',
    'Ibadan',
    'Ilorin',
    'Jalingo',
    'Jos',
    'Kaduna',
    'Kano',
    'Katsina',
    'Lafia',
    'Lagos',
    'Lokoja',
    'Maiduguri',
    'Makurdi',
    'Minna',
    'Nnewi',
    'Ogbomosho',
    'Onitsha',
    'Osogbo',
    'Owerri',
    'Port Harcourt',
    'Sokoto',
    'Umuahia',
    'Uyo',
    'Warri',
    'Yenagoa',
    'Yola',
    'Zaria',
  ];

  final List<String> _states = [
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
    final saved = ref.read(spaceFormProvider);
    _streetCtrl.text = saved.streetAddress;
    _zipCtrl.text = saved.zipCode;
    _city = saved.city;
    _state = saved.state;
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
    _streetCtrl.dispose();
    _zipCtrl.dispose();
    _animCtrl.dispose();
    super.dispose();
  }

  void _onStreetChanged(String value) {
    setState(() {});
    if (value.length < 3) {
      setState(() {
        _suggestions = [];
        _showSuggestions = false;
      });
      return;
    }
    _fetchSuggestions(value);
  }

  Future<void> _fetchSuggestions(String input) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://dwpfctewgvhsjazmvwbn.supabase.co/functions/v1/places-autocomplete'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer sb_publishable_WhZHY2-d0YpsrnH4ASJQuQ_1M7rSL1d',
        },
        body: json.encode({'input': input}),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final predictions = data['predictions'] as List;
        final list = predictions
            .map((p) => {
                  'description': p['description'] as String,
                  'place_id': p['place_id'] as String,
                })
            .toList();

        setState(() {
          _suggestions = list;
          _showSuggestions = list.isNotEmpty;
        });
      }
    } catch (e) {
      setState(() {
        _suggestions = [];
        _showSuggestions = false;
      });
    }
  }

  void _selectSuggestion(String description) {
    _streetCtrl.text = description;
    setState(() {
      _showSuggestions = false;
      _suggestions = [];
    });
  }

  void _continue() {
    setState(() => _submitted = true);
    if (_streetCtrl.text.isEmpty || _city == null || _state == null) return;
    ref.read(spaceFormProvider.notifier).update((s) => s.copyWith(
          streetAddress: _streetCtrl.text.trim(),
          city: _city,
          state: _state,
          zipCode: _zipCtrl.text.trim(),
        ));
    ref.read(obStepProvider.notifier).state = 4;
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
                  Center(
                      child: Text('Tell Us About Your Space',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary))),
                  const SizedBox(height: 4),
                  Center(
                      child: Text('Where is your space located?',
                          style: TextStyle(
                              fontSize: 13, color: AppColors.textSecondary))),
                  const SizedBox(height: 28),
                  Text('Location',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 16),
                  _label('Street Address'),
                  const SizedBox(height: 6),
                  Column(
                    children: [
                      TextFormField(
                        controller: _streetCtrl,
                        onChanged: _onStreetChanged,
                        decoration: InputDecoration(
                          hintText: 'Search or enter street address',
                          hintStyle: TextStyle(
                              color: AppColors.textHint, fontSize: 13),
                          prefixIcon: Icon(Icons.location_on_outlined,
                              color: AppColors.textHint, size: 18),
                          filled: true,
                          fillColor: _submitted && _streetCtrl.text.isEmpty
                              ? const Color(0xFFFFF5F5)
                              : Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 13),
                          border: OutlineInputBorder(
                            borderRadius: _showSuggestions
                                ? const BorderRadius.vertical(
                                    top: Radius.circular(8))
                                : BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: _submitted && _streetCtrl.text.isEmpty
                                  ? Colors.red
                                  : AppColors.border,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: _showSuggestions
                                ? const BorderRadius.vertical(
                                    top: Radius.circular(8))
                                : BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: _submitted && _streetCtrl.text.isEmpty
                                  ? Colors.red
                                  : AppColors.border,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: _showSuggestions
                                ? const BorderRadius.vertical(
                                    top: Radius.circular(8))
                                : BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: _submitted && _streetCtrl.text.isEmpty
                                  ? Colors.red
                                  : AppColors.primary,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                      if (_showSuggestions)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(8)),
                            border: Border.all(color: AppColors.border),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: _suggestions.map((s) {
                              return InkWell(
                                onTap: () =>
                                    _selectSuggestion(s['description']!),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 12),
                                  child: Row(
                                    children: [
                                      Icon(Icons.location_on_outlined,
                                          size: 16, color: AppColors.textHint),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          s['description']!,
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: AppColors.textPrimary),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                    ],
                  ),
                  if (_submitted && _streetCtrl.text.isEmpty)
                    _errorText('Street address is required'),
                  const SizedBox(height: 16),
                  _label('City'),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: _city,
                    hint: Text('Select city',
                        style:
                            TextStyle(color: AppColors.textHint, fontSize: 13)),
                    decoration: _dropdownDecoration(
                        hasError: _submitted && _city == null),
                    items: _cities
                        .map((c) => DropdownMenuItem(
                            value: c,
                            child:
                                Text(c, style: const TextStyle(fontSize: 13))))
                        .toList(),
                    onChanged: (v) => setState(() => _city = v),
                  ),
                  if (_submitted && _city == null)
                    _errorText('Please select a city'),
                  const SizedBox(height: 16),
                  _label('State'),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: _state,
                    hint: Text('Select State',
                        style:
                            TextStyle(color: AppColors.textHint, fontSize: 13)),
                    decoration: _dropdownDecoration(
                        hasError: _submitted && _state == null),
                    items: _states
                        .map((s) => DropdownMenuItem(
                            value: s,
                            child:
                                Text(s, style: const TextStyle(fontSize: 13))))
                        .toList(),
                    onChanged: (v) => setState(() => _state = v),
                  ),
                  if (_submitted && _state == null)
                    _errorText('Please select a state'),
                  const SizedBox(height: 16),
                  _label('ZIP Code'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _zipCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Enter ZIP code',
                      hintStyle:
                          TextStyle(color: AppColors.textHint, fontSize: 13),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 13),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: AppColors.border)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: AppColors.border)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              BorderSide(color: AppColors.primary, width: 1.5)),
                    ),
                  ),
                  const SizedBox(height: 32),
                  obBottomBar(
                    onBack: () => ref.read(obStepProvider.notifier).state = 2,
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
      style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary));

  Widget _errorText(String msg) => Padding(
      padding: const EdgeInsets.only(top: 4),
      child:
          Text(msg, style: const TextStyle(fontSize: 11, color: Colors.red)));

  InputDecoration _dropdownDecoration({required bool hasError}) {
    return InputDecoration(
      filled: true,
      fillColor: hasError ? const Color(0xFFFFF5F5) : Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              BorderSide(color: hasError ? Colors.red : AppColors.border)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              BorderSide(color: hasError ? Colors.red : AppColors.border)),
    );
  }
}
