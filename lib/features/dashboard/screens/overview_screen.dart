import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import 'dashboard_screen.dart';

class OverviewScreen extends ConsumerStatefulWidget {
  const OverviewScreen({super.key});

  @override
  ConsumerState<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends ConsumerState<OverviewScreen> {
  bool _hasData = false;
  String _activeTab = 'All Bookings';
  final _searchCtrl = TextEditingController();
  final _tabs = ['All Bookings', 'Pending', 'Confirmed', 'Completed'];

  final _bookings = [
    _Booking('danielebube79@gmai...', 'St Maximus Content House',
        'Content House', '10AM - 1:30PM', '16th January', 'Confirmed'),
    _Booking('danielebube79@gmai...', 'St Maximus Content House',
        'Content House', '10AM - 1:30PM', '16th January', 'Pending'),
    _Booking('danielebube79@gmai...', 'St Maximus Content House',
        'Content House', '10AM - 1:30PM', '16th January', 'Confirmed'),
    _Booking('danielebube79@gmai...', 'St Maximus Content House',
        'Content House', '10AM - 1:30PM', '16th January', 'Pending'),
    _Booking('danielebube79@gmai...', 'St Maximus Content House',
        'Content House', '10AM - 1:30PM', '16th January', 'Confirmed'),
    _Booking('danielebube79@gmai...', 'St Maximus Content House',
        'Content House', '10AM - 1:30PM', '16th January', 'Pending'),
  ];

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
          isMobile ? _buildMobileTopBar() : _buildDesktopTopBar(),
          const SizedBox(height: 16),

          // DEV toggle
          Row(
            children: [
              Switch(
                value: _hasData,
                onChanged: (v) => setState(() => _hasData = v),
                activeColor: Colors.orange,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Stat cards
          if (isMobile)
            Column(children: [
              _StatCard(
                  icon: Icons.account_balance_wallet_outlined,
                  label: 'Total Earnings',
                  value: _hasData ? '₦50,000.00' : '₦0',
                  sub: 'This month'),
              const SizedBox(height: 12),
              _StatCard(
                  icon: Icons.calendar_today_outlined,
                  label: 'Active Booking',
                  value: _hasData ? '2' : '0',
                  sub: 'This month'),
              const SizedBox(height: 12),
              _StatCard(
                  icon: Icons.remove_red_eye_outlined,
                  label: 'Space Views',
                  value: _hasData ? '33' : '0',
                  sub: 'This month'),
              const SizedBox(height: 12),
              _StatCard(
                  icon: Icons.star_border,
                  label: 'Average Rating',
                  value: _hasData ? '4.7' : '0.0',
                  sub: _hasData ? 'From 6 reviews' : 'From 0 reviews'),
            ])
          else
            Row(children: [
              _StatCard(
                  icon: Icons.account_balance_wallet_outlined,
                  label: 'Total Earnings',
                  value: _hasData ? '₦50,000.00' : '₦0',
                  sub: 'This month'),
              const SizedBox(width: 16),
              _StatCard(
                  icon: Icons.calendar_today_outlined,
                  label: 'Active Booking',
                  value: _hasData ? '2' : '0',
                  sub: 'This month'),
              const SizedBox(width: 16),
              _StatCard(
                  icon: Icons.remove_red_eye_outlined,
                  label: 'Space Views',
                  value: _hasData ? '33' : '0',
                  sub: 'This month'),
              const SizedBox(width: 16),
              _StatCard(
                  icon: Icons.star_border,
                  label: 'Average Rating',
                  value: _hasData ? '4.7' : '0.0',
                  sub: _hasData ? 'From 6 reviews' : 'From 0 reviews'),
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
              SizedBox(width: 520, child: _buildSearch()),
            ]),
          const SizedBox(height: 20),

          // Recent Booking Requests
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Recent Booking Requests',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary)),
                      TextButton(
                        onPressed: () {},
                        child: const Text('View All',
                            style: TextStyle(
                                fontSize: 14,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),

                // Table header
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF9FAFB),
                    border: Border(
                      top: BorderSide(color: AppColors.border),
                      bottom: BorderSide(color: AppColors.border),
                    ),
                  ),
                  child: Row(children: [
                    const SizedBox(width: 28),
                    Expanded(flex: 3, child: _headerText('From')),
                    if (!isMobile) ...[
                      Expanded(flex: 3, child: _headerText('Space Name')),
                      Expanded(flex: 2, child: _headerText('Space Type')),
                      Expanded(flex: 2, child: _headerText('Time')),
                      Expanded(flex: 2, child: _headerText('Date')),
                    ],
                    Expanded(flex: 2, child: _headerText('Status')),
                    const SizedBox(width: 24),
                  ]),
                ),

                if (_hasData)
                  ..._bookings.map((b) => _buildBookingRow(b, isMobile))
                else
                  Column(
                    children: [
                      const SizedBox(height: 40),
                      Center(
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/empty_state_img2.png',
                              width: isMobile ? 140 : 180,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.inbox_outlined,
                                size: isMobile ? 60 : 80,
                                color: AppColors.border,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text('Nothing to see here',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingRow(_Booking b, bool isMobile) {
    if (isMobile) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 16,
                      backgroundColor: Color(0xFFE5E7EB),
                      child: Icon(Icons.person,
                          size: 16, color: AppColors.textSecondary),
                    ),
                    const SizedBox(width: 8),
                    Text(b.from,
                        style: const TextStyle(
                            fontSize: 13, color: AppColors.textPrimary)),
                  ],
                ),
                _BookingStatusBadge(b.status),
              ],
            ),
            const SizedBox(height: 8),
            Text(b.spaceName,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(b.time,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary)),
                Text(b.date,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(children: [
        SizedBox(
          width: 16,
          height: 16,
          child: Checkbox(
            value: false,
            onChanged: (_) {},
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
            side: const BorderSide(color: AppColors.border),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 3,
          child: Row(
            children: [
              const CircleAvatar(
                radius: 16,
                backgroundColor: Color(0xFFE5E7EB),
                child: Icon(Icons.person,
                    size: 16, color: AppColors.textSecondary),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(b.from,
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.textPrimary),
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
        ),
        Expanded(
            flex: 3,
            child: Text(b.spaceName,
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textPrimary))),
        Expanded(
            flex: 2,
            child: Text(b.spaceType,
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textPrimary))),
        Expanded(
            flex: 2,
            child: Text(b.time,
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textSecondary))),
        Expanded(
            flex: 2,
            child: Text(b.date,
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textSecondary))),
        Expanded(flex: 2, child: _BookingStatusBadge(b.status)),
        SizedBox(
          width: 24,
          child: IconButton(
            icon: const Icon(Icons.more_vert,
                size: 16, color: AppColors.textSecondary),
            onPressed: () {},
            padding: EdgeInsets.zero,
          ),
        ),
      ]),
    );
  }

  Widget _buildTabs() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _tabs.map((tab) {
          final isActive = _activeTab == tab;
          return GestureDetector(
            onTap: () => setState(() => _activeTab = tab),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
      height: 40,
      child: TextField(
        controller: _searchCtrl,
        style: const TextStyle(fontSize: 13),
        decoration: InputDecoration(
          hintText: 'Search Space, bookings...',
          hintStyle: const TextStyle(fontSize: 13, color: AppColors.textHint),
          prefixIcon:
              const Icon(Icons.search, size: 18, color: AppColors.textHint),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
    );
  }

  Widget _headerText(String text) => Text(text,
      style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary));

  Widget _buildDesktopTopBar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Overview',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
              SizedBox(height: 4),
              Text(
                  'Manage your spaces, bookings and earnings all in one place.',
                  style:
                      TextStyle(fontSize: 14, color: AppColors.textSecondary)),
            ],
          ),
        ),
        SizedBox(
          width: 185,
          height: 50,
          child: OutlinedButton(
            onPressed: () =>
                ref.read(dashboardIndexProvider.notifier).state = 8,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textPrimary,
              side: const BorderSide(color: AppColors.border),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Edit Space Details',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
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
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
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
        const Text('Overview',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
        const SizedBox(height: 4),
        const Text(
            'Manage your spaces, bookings and earnings all in one place.',
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
}

// ── Models ────────────────────────────────────────────────────────────────────
class _Booking {
  final String from;
  final String spaceName;
  final String spaceType;
  final String time;
  final String date;
  final String status;
  _Booking(this.from, this.spaceName, this.spaceType, this.time, this.date,
      this.status);
}

// ── Widgets ───────────────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String sub;

  const _StatCard({
    required this.icon,
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
            child: _content(),
          )
        : Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: _content(),
            ),
          );
  }

  Widget _content() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: AppColors.textSecondary),
            const SizedBox(width: 6),
            Text(label,
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textSecondary)),
          ],
        ),
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

class _BookingStatusBadge extends StatelessWidget {
  final String status;
  const _BookingStatusBadge(this.status);

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color text;
    Color border;

    switch (status) {
      case 'Confirmed':
        bg = const Color(0xFFDCFCE7);
        text = const Color(0xFF166534);
        border = const Color(0xFF166534);
        break;
      case 'Pending':
        bg = const Color(0xFFFEF9C3);
        text = const Color(0xFF854D0E);
        border = const Color(0xFF854D0E);
        break;
      case 'Completed':
        bg = const Color(0xFFDBEAFE);
        text = const Color(0xFF1E40AF);
        border = const Color(0xFF1E40AF);
        break;
      default:
        bg = const Color(0xFFF3F4F6);
        text = AppColors.textSecondary;
        border = AppColors.border;
    }

    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: border),
        ),
        child: Text(status,
            style: TextStyle(
                fontSize: 12, color: text, fontWeight: FontWeight.w500)),
      ),
    );
  }
}
