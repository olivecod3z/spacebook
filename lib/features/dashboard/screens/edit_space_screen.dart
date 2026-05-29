import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spacebook/features/dashboard/screens/dashboard_screen.dart';
import 'package:spacebook/features/dashboard/screens/my_spaces_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/app_colors.dart';
import 'package:image_picker/image_picker.dart';

class EditSpaceScreen extends ConsumerStatefulWidget {
  final String? spaceId;
  const EditSpaceScreen({super.key, this.spaceId});

  @override
  ConsumerState<EditSpaceScreen> createState() => _EditSpaceScreenState();
}

class _EditSpaceScreenState extends ConsumerState<EditSpaceScreen>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<Offset>> _slideAnims;
  late List<Animation<double>> _fadeAnims;

  final _spaceNameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _hourlyRateCtrl = TextEditingController();
  final _minHoursCtrl = TextEditingController();
  final _spaceRulesCtrl = TextEditingController();
  final _streetCtrl = TextEditingController();
  final _zipCtrl = TextEditingController();

  String? _spaceType;
  String? _capacity;
  String? _city;
  String? _state;
  String? _availableFrom;
  String? _availableUntil;
  final List<String> _selectedAmenities = [];
  final List<String> _selectedDays = [];

  // Photo state
  List<String> _existingPhotoUrls = [];
  final List<XFile> _newImages = [];
  bool _isLoading = false;

  static const _spaceTypes = [
    'Content House',
    'Podcast Studio',
    'Streaming Studio',
    'Photo Studio',
  ];

  static const _capacities = [
    '1-5 guests',
    '6-10 guests',
    '11-20 guests',
    '21-50 guests',
    '50+ guests',
  ];

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

  static const _amenities = [
    'AC',
    'WiFi',
    'Parking Space',
    'Natural Light',
    'Power Supply',
    'Cameras',
    'Mics',
    'Soundproof',
  ];

  static const _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  static const _times = [
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
    '12:00 AM',
  ];

  final _scrollCtrl = ScrollController();
  final List<GlobalKey> _sectionKeys = List.generate(4, (_) => GlobalKey());
  final List<bool> _sectionVisible = [false, false, false, false];

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      4,
      (i) => AnimationController(
          vsync: this, duration: const Duration(milliseconds: 500)),
    );
    _slideAnims = _controllers
        .map((c) => Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
            .animate(CurvedAnimation(parent: c, curve: Curves.easeOut)))
        .toList();
    _fadeAnims = _controllers
        .map((c) => Tween<double>(begin: 0, end: 1)
            .animate(CurvedAnimation(parent: c, curve: Curves.easeOut)))
        .toList();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controllers[0].forward();
      setState(() => _sectionVisible[0] = true);
      _scrollCtrl.addListener(_onScroll);
      if (widget.spaceId != null) _loadSpace(widget.spaceId!);
    });
  }

  Future<void> _loadSpace(String spaceId) async {
    try {
      final response = await Supabase.instance.client
          .from('spaces')
          .select()
          .eq('id', spaceId)
          .single();

      setState(() {
        _spaceNameCtrl.text = response['title'] ?? '';
        _descCtrl.text = response['description'] ?? '';
        _hourlyRateCtrl.text = response['hourly_rate']?.toString() ?? '';
        _minHoursCtrl.text = response['minimum_hours']?.toString() ?? '';
        _spaceRulesCtrl.text = response['rules'] ?? '';
        _streetCtrl.text = response['street_address'] ?? '';
        _zipCtrl.text = response['zip_code'] ?? '';
        _spaceType = response['space_type'];
        _city = response['city'];
        _state = response['state'];
        _availableFrom = response['available_from'];
        _availableUntil = response['available_until'];

        final days = response['available_days'] as List?;
        if (days != null) {
          _selectedDays.clear();
          _selectedDays.addAll(days.map((e) => e.toString()));
        }

        final amenities = response['amenities'] as List?;
        if (amenities != null) {
          _selectedAmenities.clear();
          _selectedAmenities.addAll(amenities.map((e) => e.toString()));
        }

        // Load existing photos
        final photos = response['photos'] as List?;
        if (photos != null) {
          _existingPhotoUrls = photos.map((e) => e.toString()).toList();
        }

        final cap = response['capacity'];
        if (cap != null) {
          if (cap <= 5)
            _capacity = '1-5 guests';
          else if (cap <= 10)
            _capacity = '6-10 guests';
          else if (cap <= 20)
            _capacity = '11-20 guests';
          else if (cap <= 50)
            _capacity = '21-50 guests';
          else
            _capacity = '50+ guests';
        }
      });
    } catch (e) {
      debugPrint('Failed to load space: $e');
    }
  }

  Future<void> _pickImages() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
      withData: true,
    );
    if (result != null) {
      setState(() {
        _newImages.clear();
        _newImages.addAll(
          result.files
              .where((f) => f.bytes != null)
              .take(5)
              .map((f) => XFile.fromData(f.bytes!, name: f.name)),
        );
        // Clear existing photos preview when new ones are selected
        _existingPhotoUrls = [];
      });
    }
  }

  Future<List<String>> _uploadImages(String spaceId) async {
    final client = Supabase.instance.client;
    final List<String> urls = [];
    for (int i = 0; i < _newImages.length; i++) {
      try {
        final bytes = await _newImages[i].readAsBytes();
        final ext = _newImages[i].name.split('.').last.toLowerCase();
        final contentType = ext == 'png' ? 'image/png' : 'image/jpeg';
        final fileName = '$spaceId/photo_$i.$ext';
        await client.storage.from('space-photos').uploadBinary(
              fileName,
              bytes,
              fileOptions: FileOptions(contentType: contentType, upsert: true),
            );
        urls.add(client.storage.from('space-photos').getPublicUrl(fileName));
      } catch (e) {
        debugPrint('Photo upload error: $e');
      }
    }
    return urls;
  }

  void _onScroll() {
    for (int i = 1; i < 4; i++) {
      if (_sectionVisible[i]) continue;
      final ctx = _sectionKeys[i].currentContext;
      if (ctx == null) continue;
      final box = ctx.findRenderObject() as RenderBox?;
      if (box == null) continue;
      final pos = box.localToGlobal(Offset.zero);
      final screenH = MediaQuery.of(context).size.height;
      if (pos.dy < screenH * 0.92) {
        setState(() => _sectionVisible[i] = true);
        _controllers[i].forward();
      }
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    _spaceNameCtrl.dispose();
    _descCtrl.dispose();
    _hourlyRateCtrl.dispose();
    _minHoursCtrl.dispose();
    _spaceRulesCtrl.dispose();
    _streetCtrl.dispose();
    _zipCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return SingleChildScrollView(
      controller: _scrollCtrl,
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
          const Text('Edit Your Space Details',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          const Text('Provide details about your space',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
          const SizedBox(height: 28),
          _AnimatedSection(
              key: _sectionKeys[0],
              slideAnim: _slideAnims[0],
              fadeAnim: _fadeAnims[0],
              child: _buildBasicInfo()),
          const SizedBox(height: 20),
          _AnimatedSection(
              key: _sectionKeys[1],
              slideAnim: _slideAnims[1],
              fadeAnim: _fadeAnims[1],
              child: _buildLocation()),
          const SizedBox(height: 20),
          _AnimatedSection(
              key: _sectionKeys[2],
              slideAnim: _slideAnims[2],
              fadeAnim: _fadeAnims[2],
              child: _buildPricing(isMobile)),
          const SizedBox(height: 20),
          _AnimatedSection(
              key: _sectionKeys[3],
              slideAnim: _slideAnims[3],
              fadeAnim: _fadeAnims[3],
              child: _buildAmenities()),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Future<void> _saveChanges() async {
    if (widget.spaceId == null) return;
    setState(() => _isLoading = true);

    try {
      // Upload new photos if selected
      List<String>? photoUrls;
      if (_newImages.isNotEmpty) {
        photoUrls = await _uploadImages(widget.spaceId!);
      }

      final updates = {
        'title': _spaceNameCtrl.text.trim(),
        'description': _descCtrl.text.trim(),
        'space_type': _spaceType,
        'street_address': _streetCtrl.text.trim(),
        'city': _city,
        'state': _state,
        'zip_code': _zipCtrl.text.trim(),
        'hourly_rate': double.tryParse(_hourlyRateCtrl.text) ?? 0,
        'minimum_hours': int.tryParse(_minHoursCtrl.text) ?? 1,
        'available_days': _selectedDays,
        'available_from': _availableFrom,
        'available_until': _availableUntil,
        'amenities': _selectedAmenities,
        'rules': _spaceRulesCtrl.text.trim(),
        if (photoUrls != null) 'photos': photoUrls,
      };

      await Supabase.instance.client
          .from('spaces')
          .update(updates)
          .eq('id', widget.spaceId!);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Space updated successfully'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ));
        ref.read(dashboardIndexProvider.notifier).state = 1;
        ref.invalidate(mySpacesProvider);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to update: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildBasicInfo() {
    return _SectionCard(
      title: 'Basic Information',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label('Space Name'),
          const SizedBox(height: 6),
          _textField(controller: _spaceNameCtrl, hint: "e.g Judi's studio"),
          const SizedBox(height: 20),
          _label('Space Type'),
          const SizedBox(height: 10),
          Wrap(
            spacing: 24,
            runSpacing: 8,
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
                          color:
                              selected ? AppColors.primary : AppColors.border,
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
                                      color: AppColors.primary)))
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
          const SizedBox(height: 20),
          _label('Description'),
          const SizedBox(height: 6),
          TextFormField(
            controller: _descCtrl,
            maxLines: 5,
            style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
            decoration: _inputDec(
                "Describe your space, what makes it unique, and what's it best for"),
          ),
          const SizedBox(height: 20),
          _label('Space Capacity'),
          const SizedBox(height: 6),
          _dropdown(
              hint: 'Select maximum number of guest',
              value: _capacity,
              items: _capacities,
              onChanged: (v) => setState(() => _capacity = v)),
        ],
      ),
    );
  }

  Widget _buildLocation() {
    return _SectionCard(
      title: 'Location',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label('Street Address'),
          const SizedBox(height: 6),
          _textField(
              controller: _streetCtrl,
              hint: 'Street address',
              prefixIcon: Icons.location_on_outlined),
          const SizedBox(height: 20),
          _label('City'),
          const SizedBox(height: 6),
          _dropdown(
              hint: 'Select city',
              value: _city,
              items: _cities,
              onChanged: (v) => setState(() => _city = v)),
          const SizedBox(height: 20),
          _label('State'),
          const SizedBox(height: 6),
          _dropdown(
              hint: 'Select State',
              value: _state,
              items: _states,
              onChanged: (v) => setState(() => _state = v)),
          const SizedBox(height: 20),
          _label('ZIP Code'),
          const SizedBox(height: 6),
          _textField(controller: _zipCtrl, hint: 'Enter ZIP code'),
        ],
      ),
    );
  }

  Widget _buildPricing(bool isMobile) {
    return _SectionCard(
      title: 'Pricing & Availability',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label('Hourly Rate'),
          const SizedBox(height: 6),
          _textField(
              controller: _hourlyRateCtrl,
              hint: 'Enter hourly rate',
              keyboardType: TextInputType.number),
          const SizedBox(height: 20),
          _label('Minimum Hours'),
          const SizedBox(height: 6),
          _textField(
              controller: _minHoursCtrl,
              hint: 'Enter minimum hours',
              keyboardType: TextInputType.number),
          const SizedBox(height: 20),
          _label('Available Days'),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _days.map((day) {
              final selected = _selectedDays.contains(day);
              return GestureDetector(
                onTap: () => setState(() {
                  selected ? _selectedDays.remove(day) : _selectedDays.add(day);
                }),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color:
                                selected ? AppColors.primary : AppColors.border,
                            width: 1.5),
                        color: selected ? AppColors.primary : Colors.white,
                      ),
                      child: selected
                          ? const Icon(Icons.check,
                              size: 10, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(width: 6),
                    Text(day,
                        style: TextStyle(
                            fontSize: 13,
                            color: selected
                                ? AppColors.textPrimary
                                : AppColors.textSecondary)),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          isMobile
              ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _label('Available From'),
                  const SizedBox(height: 6),
                  _dropdown(
                      hint: 'Choose time',
                      value: _availableFrom,
                      items: _times,
                      onChanged: (v) => setState(() => _availableFrom = v)),
                  const SizedBox(height: 16),
                  _label('Available Until'),
                  const SizedBox(height: 6),
                  _dropdown(
                      hint: 'Choose time',
                      value: _availableUntil,
                      items: _times,
                      onChanged: (v) => setState(() => _availableUntil = v)),
                ])
              : Row(children: [
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        _label('Available From'),
                        const SizedBox(height: 6),
                        _dropdown(
                            hint: 'Choose time',
                            value: _availableFrom,
                            items: _times,
                            onChanged: (v) =>
                                setState(() => _availableFrom = v)),
                      ])),
                  const SizedBox(width: 16),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        _label('Available Until'),
                        const SizedBox(height: 6),
                        _dropdown(
                            hint: 'Choose time',
                            value: _availableUntil,
                            items: _times,
                            onChanged: (v) =>
                                setState(() => _availableUntil = v)),
                      ])),
                ]),
        ],
      ),
    );
  }

  Widget _buildAmenities() {
    return _SectionCard(
      title: 'Amenities & Features',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label('What Does Your Space Offer'),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _amenities.map((a) {
              final selected = _selectedAmenities.contains(a);
              return GestureDetector(
                onTap: () => setState(() {
                  selected
                      ? _selectedAmenities.remove(a)
                      : _selectedAmenities.add(a);
                }),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.primary.withOpacity(0.08)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: selected ? AppColors.primary : AppColors.border),
                  ),
                  child: Text(a,
                      style: TextStyle(
                          fontSize: 13,
                          color: selected
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          fontWeight:
                              selected ? FontWeight.w500 : FontWeight.normal)),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          _label('Space Rules'),
          const SizedBox(height: 6),
          TextFormField(
            controller: _spaceRulesCtrl,
            maxLines: 3,
            style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
            decoration: _inputDec('Set your space rules..'),
          ),
          const SizedBox(height: 20),
          _label('Space Photos (maximum 5 photos)'),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _pickImages,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  const Icon(Icons.cloud_upload_outlined,
                      size: 28, color: AppColors.textHint),
                  const SizedBox(height: 8),
                  RichText(
                    text: const TextSpan(children: [
                      TextSpan(
                          text: 'Click to replace photos',
                          style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 13,
                              fontWeight: FontWeight.w500)),
                      TextSpan(
                          text: ' or drag and drop',
                          style: TextStyle(
                              color: AppColors.textSecondary, fontSize: 13)),
                    ]),
                  ),
                  const SizedBox(height: 4),
                  const Text('SVG, PNG, JPG or GIF',
                      style:
                          TextStyle(fontSize: 11, color: AppColors.textHint)),

                  // Show existing photos
                  if (_existingPhotoUrls.isNotEmpty && _newImages.isEmpty) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 80,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _existingPhotoUrls.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  _existingPhotoUrls[index],
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF4F5F7),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(Icons.image_outlined,
                                        color: AppColors.textHint),
                                  ),
                                ),
                              ),
                              if (index == 0)
                                Positioned(
                                  bottom: 4,
                                  left: 4,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text('Cover',
                                        style: TextStyle(
                                            fontSize: 9,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('${_existingPhotoUrls.length} current photo(s)',
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textSecondary)),
                  ],

                  // Show new photos selected
                  if (_newImages.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 80,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _newImages.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: FutureBuilder<Uint8List>(
                                  future: _newImages[index].readAsBytes(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Image.memory(snapshot.data!,
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover);
                                    }
                                    return Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF4F5F7),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(Icons.image_outlined,
                                          color: AppColors.textHint),
                                    );
                                  },
                                ),
                              ),
                              if (index == 0)
                                Positioned(
                                  bottom: 4,
                                  left: 4,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text('Cover',
                                        style: TextStyle(
                                            fontSize: 9,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                        '${_newImages.length} new photo(s) selected — will replace current photos',
                        style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500)),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _isLoading ? null : _saveChanges,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Save Draft',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : const Text('Save Changes',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _label(String text) => Text(text,
      style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary));

  InputDecoration _inputDec(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 13, color: AppColors.textHint),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(14),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.border)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.border)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
      );

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    IconData? prefixIcon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 13, color: AppColors.textHint),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, size: 18, color: AppColors.textHint)
            : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.border)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.border)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
      ),
    );
  }

  Widget _dropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      hint: Text(hint,
          style: const TextStyle(fontSize: 13, color: AppColors.textHint)),
      icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textHint),
      style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.border)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.border)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
      ),
      items: items
          .map((e) => DropdownMenuItem(
              value: e, child: Text(e, style: const TextStyle(fontSize: 13))))
          .toList(),
      onChanged: onChanged,
    );
  }
}

class _AnimatedSection extends StatelessWidget {
  final Animation<Offset> slideAnim;
  final Animation<double> fadeAnim;
  final Widget child;

  const _AnimatedSection(
      {super.key,
      required this.slideAnim,
      required this.fadeAnim,
      required this.child});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
        opacity: fadeAnim,
        child: SlideTransition(position: slideAnim, child: child));
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}
