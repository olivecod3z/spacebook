import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';

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
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + buttons
          isMobile ? _buildMobileTopBar() : _buildDesktopTopBar(),
          const SizedBox(height: 24),

          // Stats cards
          if (isMobile)
            Column(children: [
              _StatCard(label: 'Total Spaces', value: '0', sub: '2 live'),
              const SizedBox(height: 12),
              _StatCard(label: 'Total Booking', value: '0', sub: 'This month'),
              const SizedBox(height: 12),
              _StatCard(
                  label: 'Average Booking Duration',
                  value: '0',
                  sub: 'Per Booking This month'),
            ])
          else
            Row(children: [
              _StatCard(label: 'Total Spaces', value: '0', sub: '2 live'),
              const SizedBox(width: 16),
              _StatCard(label: 'Total Booking', value: '0', sub: 'This month'),
              const SizedBox(width: 16),
              _StatCard(
                  label: 'Average Booking Duration',
                  value: '0',
                  sub: 'Per Booking This month'),
            ]),
          const SizedBox(height: 24),

          // Tabs + Search
          if (isMobile)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTabs(),
                const SizedBox(height: 12),
                _buildSearch(),
              ],
            )
          else
            Row(children: [
              _buildTabs(),
              const Spacer(),
              const SizedBox(width: 16),
              SizedBox(width: 520, child: _buildSearch()),
            ]),

          const SizedBox(height: 48),

          // Empty state
          Center(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/empty_state_img2.png',
                  scale: 2,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.home_work_outlined,
                    size: isMobile ? 60 : 307,
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
            onPressed: () {},
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
            onPressed: () {},
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
                onPressed: () {},
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
                onPressed: () {},
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
                          offset: const Offset(0, 1),
                        )
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

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String sub;

  const _StatCard({
    required this.label,
    required this.value,
    required this.sub,
  });

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
              border: Border.all(color: AppColors.border),
            ),
            child: _cardContent(),
          )
        : Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
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
