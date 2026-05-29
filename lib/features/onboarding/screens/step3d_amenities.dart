import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spacebook/features/onboarding/providers/space_repo_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/ob_bottom_bar.dart';
import '../../../core/constants/app_colors.dart';
import '../providers/space_form_provider.dart';
import 'onboarding_screen.dart';

class Step3dAmenities extends ConsumerStatefulWidget {
  const Step3dAmenities({super.key});

  @override
  ConsumerState<Step3dAmenities> createState() => _Step3dAmenitiesState();
}

class _Step3dAmenitiesState extends ConsumerState<Step3dAmenities>
    with SingleTickerProviderStateMixin {
  final List<String> _selectedAmenities = [];
  final _rulesCtrl = TextEditingController();
  final List<XFile> _images = [];
  late AnimationController _animCtrl;
  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;
  bool _isPublishing = false;

  final List<String> _amenities = [
    'AC',
    'WiFi',
    'Parking Space',
    'Natural Light',
    'Power Supply',
    'Cameras',
    'Mics',
    'Soundproof',
  ];

  @override
  void initState() {
    super.initState();
    final saved = ref.read(spaceFormProvider);
    _selectedAmenities.addAll(saved.amenities);
    _rulesCtrl.text = saved.spaceRules;
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
    _rulesCtrl.dispose();
    _animCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage();
    if (picked.isNotEmpty) {
      setState(() {
        _images.clear();
        _images.addAll(picked.take(5)); // max 5 photos
      });
    }
  }

  Future<List<String>> _uploadImages(String spaceId) async {
    final client = Supabase.instance.client;
    final List<String> urls = [];

    for (int i = 0; i < _images.length; i++) {
      final bytes = await _images[i].readAsBytes();
      final fileName = '$spaceId/photo_$i.jpg';

      await client.storage.from('space-photos').uploadBinary(
            fileName,
            bytes,
            fileOptions: const FileOptions(
              contentType: 'image/jpeg',
              upsert: true,
            ),
          );

      final url = client.storage.from('space-photos').getPublicUrl(fileName);
      urls.add(url);
    }

    return urls;
  }

  Future<void> _publish() async {
    if (_isPublishing) return;
    setState(() => _isPublishing = true);

    ref.read(spaceFormProvider.notifier).update((s) => s.copyWith(
          amenities: List.from(_selectedAmenities),
          spaceRules: _rulesCtrl.text.trim(),
        ));

    final form = ref.read(spaceFormProvider);

    try {
      // Always create a new space
      final spaceId = await ref.read(spaceRepositoryProvider).createSpace(
            title: form.spaceName,
            spaceType: form.spaceType ?? '',
            description: form.description,
            capacity: form.capacity ?? '0',
            streetAddress: form.streetAddress,
            city: form.city ?? '',
            state: form.state ?? '',
            zipCode: form.zipCode,
            hourlyRate: double.tryParse(form.hourlyRate) ?? 0,
            minimumHours: int.tryParse(form.minHours) ?? 1,
            availableDays: form.availableDays,
            availableFrom: form.availableFrom ?? '',
            availableUntil: form.availableUntil ?? '',
            amenities: List.from(_selectedAmenities),
            rules: _rulesCtrl.text.trim(),
            status: 'draft',
          );

      // Upload photos and update space with URLs
      if (_images.isNotEmpty) {
        final photoUrls = await _uploadImages(spaceId);
        await ref.read(spaceRepositoryProvider).updateSpace(
          spaceId: spaceId,
          updates: {'photos': photoUrls},
        );
      }

      if (mounted) {
        ref.read(obStepProvider.notifier).state = 6;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save space: ${e.toString()}'),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isPublishing = false);
    }
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
                      child: Text(
                          'What does your space offer and set your rules',
                          style: TextStyle(
                              fontSize: 13, color: AppColors.textSecondary))),
                  const SizedBox(height: 28),
                  const Text('Amenities & Features',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 16),
                  _label('What Does Your Space Offer'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _amenities.map((amenity) {
                      final selected = _selectedAmenities.contains(amenity);
                      return GestureDetector(
                        onTap: () => setState(() {
                          if (selected) {
                            _selectedAmenities.remove(amenity);
                          } else {
                            _selectedAmenities.add(amenity);
                          }
                        }),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.primary.withOpacity(0.08)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: selected
                                    ? AppColors.primary
                                    : const Color(0xFFE2E4E9),
                                width: 1),
                          ),
                          child: Text(amenity,
                              style: TextStyle(
                                  fontSize: 13,
                                  color: selected
                                      ? AppColors.primary
                                      : AppColors.textSecondary,
                                  fontWeight: selected
                                      ? FontWeight.w500
                                      : FontWeight.normal)),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  _label('Space Rules'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _rulesCtrl,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Set your space rules..',
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
                  _label(
                      'Upload High-Quality Images Of Your Space (maximum 5 photos)'),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: _pickImages,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE2E4E9)),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.cloud_upload_outlined,
                              size: 32, color: AppColors.textHint),
                          const SizedBox(height: 8),
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
                          if (_images.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 80,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: _images.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(width: 8),
                                itemBuilder: (context, index) {
                                  return Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: FutureBuilder<List<int>>(
                                          future: _images[index]
                                              .readAsBytes()
                                              .then((b) => b.toList()),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return Image.memory(
                                                Uint8List.fromList(
                                                    snapshot.data!),
                                                width: 80,
                                                height: 80,
                                                fit: BoxFit.cover,
                                              );
                                            }
                                            return Container(
                                              width: 80,
                                              height: 80,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFF4F5F7),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: const Icon(
                                                  Icons.image_outlined,
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
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: const Text('Cover',
                                                style: TextStyle(
                                                    fontSize: 9,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ),
                                        ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text('${_images.length} photo(s) selected',
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  obBottomBar(
                    onBack: () => ref.read(obStepProvider.notifier).state = 4,
                    onContinue: _isPublishing ? () {} : _publish,
                    continueLabel:
                        _isPublishing ? 'Publishing...' : 'Publish Your Space',
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
}
