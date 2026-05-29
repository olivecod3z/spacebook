import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/app_colors.dart';
import 'dashboard_screen.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  int _activeTab = 0;

  final _tabs = [
    _Tab(icon: Icons.person_outline, label: 'Profile'),
    _Tab(icon: Icons.notifications_outlined, label: 'Notifications'),
    _Tab(icon: Icons.shield_outlined, label: 'Security'),
    _Tab(icon: Icons.credit_card_outlined, label: 'Billing'),
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final profile = ref.watch(currentProfileProvider);

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => ref.read(dashboardIndexProvider.notifier).state = 1,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.arrow_back_ios,
                    size: 16, color: AppColors.textSecondary),
                SizedBox(width: 6),
                Text('Back',
                    style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text('Settings',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          const Text('Manage your account preferences and settings',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF6F8FA),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(3),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  mainAxisSize: MainAxisSize.min, children: _buildTabItems()),
            ),
          ),
          const SizedBox(height: 24),
          _buildTabContent(isMobile, profile.value),
        ],
      ),
    );
  }

  List<Widget> _buildTabItems() {
    return List.generate(_tabs.length, (i) {
      final isActive = _activeTab == i;
      return GestureDetector(
        onTap: () => setState(() => _activeTab = i),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_tabs[i].icon,
                  size: 16,
                  color: isActive
                      ? AppColors.textPrimary
                      : AppColors.textSecondary),
              const SizedBox(width: 8),
              Text(_tabs[i].label,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                      color: isActive
                          ? AppColors.textPrimary
                          : AppColors.textSecondary)),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildTabContent(bool isMobile, Map<String, dynamic>? profile) {
    switch (_activeTab) {
      case 0:
        return _ProfileTab(profile: profile);
      case 1:
        return _NotificationsTab();
      case 2:
        return _SecurityTab();
      case 3:
        return _BillingTab(profile: profile);
      default:
        return const SizedBox();
    }
  }
}

// ── Profile Tab ───────────────────────────────────────────────────────────────
class _ProfileTab extends StatefulWidget {
  final Map<String, dynamic>? profile;
  const _ProfileTab({this.profile});

  @override
  State<_ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<_ProfileTab> {
  bool _editing = false;
  late TextEditingController _firstNameCtrl;
  late TextEditingController _lastNameCtrl;
  late TextEditingController _emailCtrl;

  @override
  void initState() {
    super.initState();
    final fullName = widget.profile?['full_name'] ?? '';
    final parts = fullName.split(' ');
    _firstNameCtrl =
        TextEditingController(text: parts.isNotEmpty ? parts.first : '');
    _lastNameCtrl = TextEditingController(
        text: parts.length > 1 ? parts.sublist(1).join(' ') : '');
    _emailCtrl = TextEditingController(text: widget.profile?['email'] ?? '');
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

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
          const Text('Profile Information',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 24),
          _label('First Name'),
          const SizedBox(height: 6),
          _readOnlyField(_firstNameCtrl, 'First name', enabled: _editing),
          const SizedBox(height: 16),
          _label('Last Name'),
          const SizedBox(height: 6),
          _readOnlyField(_lastNameCtrl, 'Last name', enabled: _editing),
          const SizedBox(height: 16),
          _label('Email'),
          const SizedBox(height: 6),
          _readOnlyField(_emailCtrl, 'Email', enabled: false),
          const SizedBox(height: 16),
          _label('Verification Status'),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Verified',
                    style:
                        TextStyle(fontSize: 14, color: AppColors.textPrimary)),
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: AppColors.accent),
                  child: const Icon(Icons.check, size: 14, color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => setState(() => _editing = !_editing),
                child: Row(
                  children: [
                    Text('Edit Details',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: _editing
                                ? AppColors.primary
                                : AppColors.textPrimary)),
                    const SizedBox(width: 6),
                    Icon(Icons.edit_outlined,
                        size: 16,
                        color: _editing
                            ? AppColors.primary
                            : AppColors.textSecondary),
                  ],
                ),
              ),
              SizedBox(
                height: 44,
                child: ElevatedButton(
                  onPressed: () => setState(() => _editing = false),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                  ),
                  child: const Text('Save Changes',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _readOnlyField(TextEditingController ctrl, String hint,
      {bool enabled = false}) {
    return TextField(
      controller: ctrl,
      enabled: enabled,
      style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 14, color: AppColors.textHint),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.border)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.border)),
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.border)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
      ),
    );
  }

  Widget _label(String text) => Text(text,
      style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary));
}

// ── Notifications Tab ─────────────────────────────────────────────────────────
class _NotificationsTab extends StatefulWidget {
  @override
  State<_NotificationsTab> createState() => _NotificationsTabState();
}

class _NotificationsTabState extends State<_NotificationsTab> {
  final Map<String, bool> _prefs = {
    'New Booking Requests': true,
    'Booking Confirmation': true,
    'Payment Update': true,
    'Marketing Emails': false,
  };

  final Map<String, String> _subtitles = {
    'New Booking Requests': 'Get notified when someone request to book',
    'Booking Confirmation': 'Receive confirmation when bookings are confirmed',
    'Payment Update': 'Get notified when someone request to book',
    'Marketing Emails': 'Receive tips and promotional offers',
  };

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
          const Text('Notification Preferences',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          ..._prefs.entries.map((e) => Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: const BoxDecoration(
                    border:
                        Border(bottom: BorderSide(color: AppColors.border))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(e.key,
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textPrimary)),
                          const SizedBox(height: 4),
                          Text(_subtitles[e.key]!,
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    Radio<bool>(
                      value: true,
                      groupValue: e.value ? true : null,
                      onChanged: (_) =>
                          setState(() => _prefs[e.key] = !e.value),
                      activeColor: AppColors.primary,
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

// ── Security Tab ──────────────────────────────────────────────────────────────
class _SecurityTab extends StatefulWidget {
  @override
  State<_SecurityTab> createState() => _SecurityTabState();
}

class _SecurityTabState extends State<_SecurityTab> {
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

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
          const Text('Security',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 24),
          _label('Current Password'),
          const SizedBox(height: 6),
          _passwordField(
              _currentCtrl,
              'Enter your current password',
              _obscureCurrent,
              () => setState(() => _obscureCurrent = !_obscureCurrent)),
          const SizedBox(height: 16),
          _label('New Password'),
          const SizedBox(height: 6),
          _passwordField(_newCtrl, 'Enter your new password', _obscureNew,
              () => setState(() => _obscureNew = !_obscureNew)),
          const SizedBox(height: 16),
          _label('Confirm New Password'),
          const SizedBox(height: 6),
          _passwordField(
              _confirmCtrl,
              'Confirm your new password',
              _obscureConfirm,
              () => setState(() => _obscureConfirm = !_obscureConfirm)),
          const SizedBox(height: 24),
          SizedBox(
            height: 44,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 24),
              ),
              child: const Text('Update Password',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _passwordField(TextEditingController ctrl, String hint, bool obscure,
      VoidCallback toggle) {
    return TextField(
      controller: ctrl,
      obscureText: obscure,
      style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 14, color: AppColors.textHint),
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility_off : Icons.visibility,
              size: 18, color: AppColors.textHint),
          onPressed: toggle,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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

  Widget _label(String text) => Text(text,
      style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary));
}

// ── Billing Tab ───────────────────────────────────────────────────────────────
class _BillingTab extends StatefulWidget {
  final Map<String, dynamic>? profile;
  const _BillingTab({this.profile});

  @override
  State<_BillingTab> createState() => _BillingTabState();
}

class _BillingTabState extends State<_BillingTab> {
  bool _showAddNew = false;
  Map<String, dynamic>? _kyc;
  bool _loadingKyc = true;
  final _holderCtrl = TextEditingController();
  final _accountCtrl = TextEditingController();
  String? _bank;
  String? _schedule;

  static const _banks = [
    'Access Bank',
    'Citibank Nigeria',
    'Ecobank Nigeria',
    'Fidelity Bank',
    'First Bank of Nigeria',
    'First City Monument Bank (FCMB)',
    'Globus Bank',
    'Guaranty Trust Bank (GTBank)',
    'Heritage Bank',
    'Jaiz Bank',
    'Keystone Bank',
    'Kuda Bank',
    'Lotus Bank',
    'Moniepoint Microfinance Bank',
    'OPay Digital Services',
    'PalmPay',
    'Parallex Bank',
    'Polaris Bank',
    'Premium Trust Bank',
    'Providus Bank',
    'Rand Merchant Bank',
    'Stanbic IBTC Bank',
    'Standard Chartered Bank',
    'Sterling Bank',
    'SunTrust Bank',
    'Taj Bank',
    'Titan Trust Bank',
    'Union Bank of Nigeria',
    'United Bank for Africa (UBA)',
    'Unity Bank',
    'VFD Microfinance Bank',
    'Wema Bank',
    'Zenith Bank',
    'Carbon (One Finance)',
    'FairMoney Microfinance Bank',
    'Paga',
    'Rubies Bank',
    'Sparkle Microfinance Bank',
    'Accion Microfinance Bank',
    'AB Microfinance Bank',
    'LAPO Microfinance Bank',
    'Renmoney Microfinance Bank',
    'Covenant Microfinance Bank',
    'Mint Finex MFB',
    'Eyowo',
    'Limelight Bank',
    'Intellifin Microfinance Bank',
  ];

  static const _schedules = ['Daily', 'Weekly', 'Bi-weekly', 'Monthly'];

  @override
  void initState() {
    super.initState();
    _loadKyc();
  }

  Future<void> _loadKyc() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;
      final response = await Supabase.instance.client
          .from('kyc_verifications')
          .select()
          .eq('owner_id', user.id)
          .maybeSingle();
      setState(() {
        _kyc = response;
        _loadingKyc = false;
      });
    } catch (e) {
      setState(() => _loadingKyc = false);
    }
  }

  @override
  void dispose() {
    _holderCtrl.dispose();
    _accountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final name =
        _kyc?['account_holder_name'] ?? widget.profile?['full_name'] ?? '—';
    final bank = _kyc?['bank_name'] ?? '—';
    final accountNumber = _kyc?['account_number'];
    final maskedAccount = accountNumber != null &&
            accountNumber.toString().length >= 4
        ? '........${accountNumber.toString().substring(accountNumber.toString().length - 4)}'
        : 'Not set';
    final schedule = _kyc?['payout_schedule'] ?? '—';

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: _loadingKyc
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Billing Information',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary)),
                    const SizedBox(height: 24),
                    _label('Account Name'),
                    const SizedBox(height: 6),
                    _readOnlyBox(name),
                    const SizedBox(height: 16),
                    _label('Bank Name'),
                    const SizedBox(height: 6),
                    _readOnlyBox(bank),
                    const SizedBox(height: 16),
                    _label('Payout Schedule'),
                    const SizedBox(height: 6),
                    _readOnlyBox(schedule),
                    const SizedBox(height: 16),
                    _label('Bank Account'),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(maskedAccount,
                              style: const TextStyle(
                                  fontSize: 14, color: AppColors.textPrimary)),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: const Text('Primary',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () =>
                            setState(() => _showAddNew = !_showAddNew),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                        ),
                        child: const Text('Add a New Payment Details',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500)),
                      ),
                    ),
                  ],
                ),
        ),
        if (_showAddNew) ...[
          const SizedBox(height: 16),
          Container(
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
                const Text('Add a New Payment Information',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 24),
                _label('Account Holder Name'),
                const SizedBox(height: 6),
                _textField(_holderCtrl, 'Enter account name'),
                const SizedBox(height: 16),
                _label('Account Number'),
                const SizedBox(height: 6),
                _textField(_accountCtrl, 'Enter account number',
                    type: TextInputType.number),
                const SizedBox(height: 16),
                _label('Bank'),
                const SizedBox(height: 6),
                _dropdown('Choose bank', _bank, _banks,
                    (v) => setState(() => _bank = v)),
                const SizedBox(height: 16),
                _label('Payout Schedule'),
                const SizedBox(height: 6),
                _dropdown('Choose a day to receive your money', _schedule,
                    _schedules, (v) => setState(() => _schedule = v)),
                const SizedBox(height: 24),
                SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                    ),
                    child: const Text('Add New Account',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _readOnlyBox(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(text,
          style: const TextStyle(fontSize: 14, color: AppColors.textPrimary)),
    );
  }

  Widget _textField(TextEditingController ctrl, String hint,
      {TextInputType? type}) {
    return TextField(
      controller: ctrl,
      keyboardType: type,
      style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 14, color: AppColors.textHint),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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

  Widget _dropdown(String hint, String? value, List<String> items,
      ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      hint: Text(hint,
          style: const TextStyle(fontSize: 14, color: AppColors.textHint)),
      icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textHint),
      style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
              value: e, child: Text(e, style: const TextStyle(fontSize: 14))))
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget _label(String text) => Text(text,
      style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary));
}

class _Tab {
  final IconData icon;
  final String label;
  const _Tab({required this.icon, required this.label});
}
