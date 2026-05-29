import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import 'dashboard_screen.dart';

class EarningsScreen extends ConsumerStatefulWidget {
  const EarningsScreen({super.key});

  @override
  ConsumerState<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends ConsumerState<EarningsScreen> {
  bool _hasData = false;

  final _transactions = [
    _Transaction('daniel21@gmail.com', 'St Maximus Content House', '₦5,000',
        'Completed', '2025-06-06'),
    _Transaction('daniel21@gmail.com', 'St Maximus Content House', '₦5,000',
        'Completed', '2025-06-06'),
    _Transaction('daniel21@gmail.com', 'St Maximus Content House', '₦5,000',
        'Cancelled', '2025-06-06'),
    _Transaction('daniel21@gmail.com', 'St Maximus Content House', '₦5,000',
        'Confirmed', '2025-06-06'),
  ];

  final _monthlyEarnings = {
    'January': '₦15,000',
    'February': '₦15,000',
    'March': '₦15,000',
    'April': '₦15,000',
    'May': '₦15,000',
    'June': '₦15,000',
    'July': '₦15,000',
    'August': '₦15,000',
    'September': '₦15,000',
    'October': '₦15,000',
    'November': '₦15,000',
    'December': '₦15,000',
  };

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isMobile ? _buildMobileTopBar() : _buildDesktopTopBar(),
          const SizedBox(height: 12),

          // DEV toggle
          Row(
            children: [
              Switch(
                value: _hasData,
                onChanged: (v) => setState(() => _hasData = v),
                activeColor: const Color.fromARGB(255, 255, 17, 0),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Stat cards
          if (isMobile)
            Column(children: [
              _EarningsCard(
                  label: 'Net Earnings',
                  value: _hasData ? '₦60,000' : '₦0.00',
                  sub:
                      _hasData ? '+25% from last month' : '+0% from last month',
                  subColor: AppColors.accent),
              const SizedBox(height: 12),
              _EarningsCard(
                  label: 'Average Per Booking',
                  value: _hasData ? '₦5,000' : '₦0.00',
                  sub: 'This month'),
              const SizedBox(height: 12),
              _EarningsCard(
                  label: 'Occupancy Rate',
                  value: _hasData ? '75%' : '0%',
                  sub:
                      _hasData ? '+12% from last month' : '+0% from last month',
                  subColor: AppColors.accent),
            ])
          else
            Row(children: [
              _EarningsCard(
                  label: 'Net Earnings',
                  value: _hasData ? '₦60,000' : '₦0.00',
                  sub:
                      _hasData ? '+25% from last month' : '+0% from last month',
                  subColor: AppColors.accent),
              const SizedBox(width: 16),
              _EarningsCard(
                  label: 'Average Per Booking',
                  value: _hasData ? '₦5,000' : '₦0.00',
                  sub: 'This month'),
              const SizedBox(width: 16),
              _EarningsCard(
                  label: 'Occupancy Rate',
                  value: _hasData ? '75%' : '0%',
                  sub:
                      _hasData ? '+12% from last month' : '+0% from last month',
                  subColor: AppColors.accent),
            ]),

          const SizedBox(height: 24),

          if (_hasData) ...[
            _buildRecentTransactions(isMobile),
            const SizedBox(height: 20),
            isMobile
                ? Column(children: [
                    _buildEarningsOverview(),
                    const SizedBox(height: 16),
                    _buildPayoutInfo(),
                  ])
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildEarningsOverview()),
                      const SizedBox(width: 16),
                      Expanded(child: _buildPayoutInfo()),
                    ],
                  ),
          ] else
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Image.asset(
                    'assets/images/earning_empty_state_img.png',
                    width: isMobile ? 140 : 320,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.account_balance_wallet_outlined,
                      size: isMobile ? 60 : 80,
                      color: AppColors.border,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'No earning metrics to see yet',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: isMobile ? 15 : 18,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions(bool isMobile) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Text('Recent transaction',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary)),
          ),
          const SizedBox(height: 16),

          // Header — desktop only
          if (!isMobile)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: const BoxDecoration(
                color: Color(0xFFF9FAFB),
                border: Border(
                  top: BorderSide(color: AppColors.border),
                  bottom: BorderSide(color: AppColors.border),
                ),
              ),
              child: Row(children: [
                const SizedBox(width: 28),
                Expanded(flex: 3, child: _headerText('Customer email')),
                Expanded(flex: 3, child: _headerText('Space')),
                Expanded(flex: 2, child: _headerText('Amount')),
                Expanded(flex: 2, child: _headerText('Status')),
                Expanded(flex: 2, child: _headerText('Date')),
              ]),
            ),

          ..._transactions.map((t) => _buildRow(t, isMobile)),
          if (isMobile) const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _headerText(String text) => Text(text,
      style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary));

  Widget _buildRow(_Transaction t, bool isMobile) {
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
                Expanded(
                  child: Text(t.email,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary),
                      overflow: TextOverflow.ellipsis),
                ),
                const SizedBox(width: 8),
                _StatusBadge(t.status),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(t.space,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textPrimary)),
                Text(t.amount,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
              ],
            ),
            const SizedBox(height: 4),
            Text(t.date,
                style:
                    const TextStyle(fontSize: 11, color: AppColors.textHint)),
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
            child: Text(t.email,
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textPrimary))),
        Expanded(
            flex: 3,
            child: Text(t.space,
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textPrimary))),
        Expanded(
            flex: 2,
            child: Text(t.amount,
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textPrimary))),
        Expanded(flex: 2, child: _StatusBadge(t.status)),
        Expanded(
            flex: 2,
            child: Text(t.date,
                style: const TextStyle(
                    fontSize: 13, color: AppColors.textSecondary))),
      ]),
    );
  }

  Widget _buildEarningsOverview() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Earnings Overview',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          const Text('Monthly earnings',
              style: TextStyle(fontSize: 16, color: AppColors.textHint)),
          const SizedBox(height: 16),
          ..._monthlyEarnings.entries.map((e) => Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppColors.border)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(e.key,
                        style: const TextStyle(
                            fontSize: 13, color: AppColors.textSecondary)),
                    Text(e.value,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary)),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildPayoutInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Payout Information',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          const Text('How and when you receive your earnings',
              style: TextStyle(fontSize: 16, color: AppColors.textHint)),
          const SizedBox(height: 16),

          // Available Balance
          Container(
            width: double.infinity,
            height: 136,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Available Balance',
                        style: TextStyle(
                            fontSize: 13, color: AppColors.textSecondary)),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text('Ready For Payout',
                          style: TextStyle(
                              fontSize: 11,
                              color: AppColors.accent,
                              fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text('₦60,000',
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                const Text('From 6 completed bookings',
                    style: TextStyle(
                        fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Payout Schedule
          Container(
            width: double.infinity,
            height: 100,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Payout Schedule',
                    style: TextStyle(
                        fontSize: 13, color: AppColors.textSecondary)),
                SizedBox(height: 8),
                Text('Weekly on Fridays',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Next Payout
          Container(
            width: double.infinity,
            height: 100,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Next Payout',
                    style: TextStyle(
                        fontSize: 13, color: AppColors.textSecondary)),
                SizedBox(height: 8),
                Text('Dec 22, 2024',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
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
              Text('Earnings',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
              SizedBox(height: 4),
              Text(
                  'Keep track of your money and how your spaces are performing',
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
        const Text('Earnings',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
        const SizedBox(height: 4),
        const Text(
            'Keep track of your money and how your spaces are performing',
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
class _Transaction {
  final String email;
  final String space;
  final String amount;
  final String status;
  final String date;
  _Transaction(this.email, this.space, this.amount, this.status, this.date);
}

// ── Widgets ───────────────────────────────────────────────────────────────────
class _EarningsCard extends StatelessWidget {
  final String label;
  final String value;
  final String sub;
  final Color? subColor;

  const _EarningsCard({
    required this.label,
    required this.value,
    required this.sub,
    this.subColor,
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
            style: TextStyle(
                fontSize: 12,
                color: subColor ?? AppColors.textSecondary,
                fontWeight:
                    subColor != null ? FontWeight.w500 : FontWeight.normal)),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge(this.status);

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color text;
    Color border;

    switch (status) {
      case 'Completed':
        bg = const Color(0xFFDCFCE7);
        text = const Color(0xFF166534);
        border = const Color(0xFF166534);
        break;
      case 'Cancelled':
        bg = const Color(0xFFFFE4E6);
        text = const Color(0xFF9F1239);
        border = const Color(0xFF9F1239);
        break;
      case 'Confirmed':
        bg = const Color(0xFFDCFCE7);
        text = const Color(0xFF166534);
        border = const Color(0xFF166534);
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
