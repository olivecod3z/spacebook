import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spacebook/features/dashboard/screens/dashboard_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/app_colors.dart';

final mySpacesProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final user = Supabase.instance.client.auth.currentUser;
  if (user == null) return [];

  final response = await Supabase.instance.client
      .from('spaces')
      .select()
      .eq('owner_id', user.id)
      .order('created_at', ascending: false);

  return List<Map<String, dynamic>>.from(response);
});

class MySpacesScreen extends ConsumerStatefulWidget {
  const MySpacesScreen({super.key});

  @override
  ConsumerState<MySpacesScreen> createState() => _MySpacesScreenState();
}

class _MySpacesScreenState extends ConsumerState<MySpacesScreen> {
  String _activeTab = 'All Spaces';
  final _searchCtrl = TextEditingController();
  final _tabs = ['All Spaces', 'Active', 'Paused', 'Draft'];

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.refresh(mySpacesProvider));
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _goToEdit(String spaceId) {
    ref.read(editSpaceIdProvider.notifier).state = spaceId;
    ref.read(dashboardIndexProvider.notifier).state = 6;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final spacesAsync = ref.watch(mySpacesProvider);

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isMobile ? _buildMobileTopBar() : _buildDesktopTopBar(),
          const SizedBox(height: 24),
          spacesAsync.when(
            data: (spaces) {
              final total = spaces.length;
              final active =
                  spaces.where((s) => s['status'] == 'active').length;
              return isMobile
                  ? Column(children: [
                      _StatCard(
                          label: 'Total Spaces',
                          value: '$total',
                          sub: '$active live'),
                      const SizedBox(height: 12),
                      _StatCard(
                          label: 'Total Booking',
                          value: '0',
                          sub: 'This month'),
                      const SizedBox(height: 12),
                      _StatCard(
                          label: 'Average Booking Duration',
                          value: '0',
                          sub: 'Per Booking This month'),
                    ])
                  : Row(children: [
                      _StatCard(
                          label: 'Total Spaces',
                          value: '$total',
                          sub: '$active live'),
                      const SizedBox(width: 16),
                      _StatCard(
                          label: 'Total Booking',
                          value: '0',
                          sub: 'This month'),
                      const SizedBox(width: 16),
                      _StatCard(
                          label: 'Average Booking Duration',
                          value: '0',
                          sub: 'Per Booking This month'),
                    ]);
            },
            loading: () => isMobile
                ? Column(children: [
                    _StatCard(label: 'Total Spaces', value: '...', sub: ''),
                    const SizedBox(height: 12),
                    _StatCard(label: 'Total Booking', value: '...', sub: ''),
                    const SizedBox(height: 12),
                    _StatCard(
                        label: 'Average Booking Duration',
                        value: '...',
                        sub: ''),
                  ])
                : Row(children: [
                    _StatCard(label: 'Total Spaces', value: '...', sub: ''),
                    const SizedBox(width: 16),
                    _StatCard(label: 'Total Booking', value: '...', sub: ''),
                    const SizedBox(width: 16),
                    _StatCard(
                        label: 'Average Booking Duration',
                        value: '...',
                        sub: ''),
                  ]),
            error: (_, __) => const SizedBox(),
          ),
          const SizedBox(height: 24),
          if (isMobile)
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _buildTabs(),
              const SizedBox(height: 12),
              _buildSearch(),
            ])
          else
            Row(children: [
              _buildTabs(),
              const Spacer(),
              SizedBox(width: 520, child: _buildSearch()),
            ]),
          const SizedBox(height: 24),
          spacesAsync.when(
            data: (spaces) {
              final filtered = _activeTab == 'All Spaces'
                  ? spaces
                  : spaces
                      .where((s) =>
                          s['status']?.toString().toLowerCase() ==
                          _activeTab.toLowerCase())
                      .toList();

              final query = _searchCtrl.text.toLowerCase();
              final searched = query.isEmpty
                  ? filtered
                  : filtered
                      .where((s) =>
                          (s['title'] ?? '').toLowerCase().contains(query))
                      .toList();

              if (searched.isEmpty) {
                return Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      Image.asset(
                        'assets/images/empty_state_img2.png',
                        scale: 2,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.home_work_outlined,
                          size: isMobile ? 60 : 200,
                          color: AppColors.border,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Create your first studio and start\ntaking bookings',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: isMobile ? 15 : 18,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                            height: 1.5),
                      ),
                    ],
                  ),
                );
              }

              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: searched
                    .map((space) => SizedBox(
                          width: isMobile ? double.infinity : 384,
                          child: _SpaceCard(
                            space: space,
                            onEdit: () => _goToEdit(space['id'] as String),
                          ),
                        ))
                    .toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(
              child: Text('Failed to load spaces: $e',
                  style: const TextStyle(color: Colors.red)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopTopBar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('My Spaces',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
              SizedBox(height: 4),
              Text('Manage your studios, availability and bookings',
                  style:
                      TextStyle(fontSize: 14, color: AppColors.textSecondary)),
            ],
          ),
        ),
        SizedBox(
          width: 185,
          height: 50,
          child: OutlinedButton(
            onPressed: () {
              final spaces = ref.read(mySpacesProvider).value;
              if (spaces != null && spaces.isNotEmpty) {
                ref.read(editSpaceIdProvider.notifier).state =
                    spaces.first['id'] as String;
              }
              ref.read(dashboardIndexProvider.notifier).state = 6;
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textPrimary,
              side: const BorderSide(color: AppColors.border),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Edit Space Details',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 185,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: () =>
                ref.read(dashboardIndexProvider.notifier).state = 5,
            icon: const Icon(Icons.add, size: 16),
            label: const Text('List New Space',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileTopBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('My Spaces',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
        const SizedBox(height: 4),
        const Text('Manage your studios, availability and bookings',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  final spaces = ref.read(mySpacesProvider).value;
                  if (spaces != null && spaces.isNotEmpty) {
                    ref.read(editSpaceIdProvider.notifier).state =
                        spaces.first['id'] as String;
                  }
                  ref.read(dashboardIndexProvider.notifier).state = 6;
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                child: const Text('Edit Space Details',
                    style: TextStyle(fontSize: 12)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () =>
                    ref.read(dashboardIndexProvider.notifier).state = 5,
                icon: const Icon(Icons.add, size: 14),
                label: const Text('List New Space',
                    style: TextStyle(fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _tabs.map((tab) {
          final isActive = _activeTab == tab;
          return GestureDetector(
            onTap: () => setState(() => _activeTab = tab),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
              decoration: BoxDecoration(
                color: isActive ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: isActive ? Border.all(color: AppColors.border) : null,
                boxShadow: isActive
                    ? [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 4,
                            offset: const Offset(0, 1))
                      ]
                    : null,
              ),
              child: Text(tab,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                      color: isActive
                          ? AppColors.textPrimary
                          : AppColors.textSecondary)),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSearch() {
    return SizedBox(
      height: 50,
      child: TextField(
        controller: _searchCtrl,
        onChanged: (_) => setState(() {}),
        style: const TextStyle(fontSize: 13),
        decoration: InputDecoration(
          hintText: 'Search Space...',
          hintStyle: const TextStyle(fontSize: 13, color: AppColors.textHint),
          prefixIcon:
              const Icon(Icons.search, size: 18, color: AppColors.textHint),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: AppColors.primary, width: 1.5)),
        ),
      ),
    );
  }
}

class _SpaceCard extends ConsumerStatefulWidget {
  final Map<String, dynamic> space;
  final VoidCallback onEdit;
  const _SpaceCard({required this.space, required this.onEdit});

  @override
  ConsumerState<_SpaceCard> createState() => _SpaceCardState();
}

class _SpaceCardState extends ConsumerState<_SpaceCard> {
  bool _showStatusSub = false;

  void _showMenu(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu(
      context: context,
      position: position,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      items: [
        PopupMenuItem(
          padding: EdgeInsets.zero,
          child: StatefulBuilder(
            builder: (ctx, setSubState) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () =>
                      setSubState(() => _showStatusSub = !_showStatusSub),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Status',
                            style: TextStyle(
                                fontSize: 14, color: AppColors.textPrimary)),
                        Icon(Icons.chevron_right,
                            size: 16, color: AppColors.textSecondary),
                      ],
                    ),
                  ),
                ),
                if (_showStatusSub) ...[
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                    child: Row(children: [
                      Radio<String>(
                          value: 'active',
                          groupValue: widget.space['status'],
                          onChanged: (_) {},
                          activeColor: AppColors.primary),
                      const Text('Active', style: TextStyle(fontSize: 13)),
                    ]),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                    child: Row(children: [
                      Radio<String>(
                          value: 'paused',
                          groupValue: widget.space['status'],
                          onChanged: (_) {},
                          activeColor: AppColors.primary),
                      const Text('Paused', style: TextStyle(fontSize: 13)),
                    ]),
                  ),
                ],
                const Divider(height: 1, color: AppColors.border),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    widget.onEdit();
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Text('Edit Space',
                        style: TextStyle(
                            fontSize: 14, color: AppColors.textPrimary)),
                  ),
                ),
                const Divider(height: 1, color: AppColors.border),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Text('Delete Space',
                        style: TextStyle(fontSize: 14, color: Colors.red)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final status = widget.space['status'] ?? 'draft';
    final isActive = status == 'active';
    final photos = widget.space['photos'] as List?;
    final photoUrl =
        (photos != null && photos.isNotEmpty) ? photos[0] as String : null;
    final price = widget.space['hourly_rate'];
    final city = widget.space['city'] ?? '';
    final state = widget.space['state'] ?? '';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            height: 203,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: photoUrl != null
                      ? Image.network(photoUrl,
                          width: double.infinity,
                          height: 203,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _placeholderImage())
                      : _placeholderImage(),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isActive
                          ? const Color(0xFFDCFCE7)
                          : const Color(0xFFFEF9C3),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: isActive
                              ? const Color(0xFF166534)
                              : const Color(0xFF854D0E)),
                    ),
                    child: Text(
                      isActive ? 'Active. Bookable' : 'Paused. Not Bookable',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: isActive
                              ? const Color(0xFF166534)
                              : const Color(0xFF854D0E)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(widget.space['title'] ?? '',
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary),
                          overflow: TextOverflow.ellipsis),
                    ),
                    Builder(
                      builder: (ctx) => GestureDetector(
                        onTap: () => _showMenu(ctx),
                        child: const Icon(Icons.more_vert,
                            size: 18, color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(widget.space['space_type'] ?? '',
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.textSecondary)),
                const SizedBox(height: 6),
                Row(children: [
                  const Icon(Icons.location_on_outlined,
                      size: 14, color: AppColors.textHint),
                  const SizedBox(width: 4),
                  Text('$city, $state',
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textSecondary)),
                ]),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: '₦${price ?? 0}',
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary)),
                        const TextSpan(
                            text: ' /hour',
                            style: TextStyle(
                                fontSize: 12, color: AppColors.textSecondary)),
                      ]),
                    ),
                    Row(children: [
                      const Icon(Icons.calendar_today_outlined,
                          size: 13, color: AppColors.textHint),
                      const SizedBox(width: 4),
                      const Text('0 booking today',
                          style: TextStyle(
                              fontSize: 12, color: AppColors.textSecondary)),
                    ]),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      height: 203,
      color: const Color(0xFFF3F4F6),
      child: const Center(
          child: Icon(Icons.home_work_outlined,
              size: 40, color: AppColors.border)),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String sub;

  const _StatCard(
      {required this.label, required this.value, required this.sub});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return isMobile
        ? Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border)),
            child: _cardContent(),
          )
        : Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border)),
              child: _cardContent(),
            ),
          );
  }

  Widget _cardContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
                const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        const SizedBox(height: 12),
        Text(value,
            style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
        const SizedBox(height: 4),
        Text(sub,
            style:
                const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }
}
