import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import 'my_spaces_screen.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _selectedIndex = 1;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _navItems = const [
    _NavItem(icon: Icons.grid_view_outlined, label: 'Overview'),
    _NavItem(icon: Icons.home_work_outlined, label: 'My Spaces'),
    _NavItem(icon: Icons.bar_chart_outlined, label: 'Earnings'),
    _NavItem(icon: Icons.analytics_outlined, label: 'Analytics'),
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: isMobile
          ? Drawer(
              child: _SidebarContent(
                selectedIndex: _selectedIndex,
                navItems: _navItems,
                onItemTap: (i) {
                  setState(() => _selectedIndex = i);
                  _scaffoldKey.currentState?.closeDrawer();
                },
              ),
            )
          : null,
      body: isMobile
          ? Column(
              children: [
                _buildTopBar(isMobile: true),
                Expanded(child: _buildBody()),
              ],
            )
          : Row(
              children: [
                // Sidebar — full height
                _SidebarContent(
                  selectedIndex: _selectedIndex,
                  navItems: _navItems,
                  onItemTap: (i) => setState(() => _selectedIndex = i),
                ),
                // Right side — top bar + content
                Expanded(
                  child: Column(
                    children: [
                      _buildTopBar(isMobile: false),
                      Expanded(child: _buildBody()),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildTopBar({required bool isMobile}) {
    return Container(
      height: 56,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          if (isMobile) ...[
            GestureDetector(
              onTap: () => _scaffoldKey.currentState?.openDrawer(),
              child: const Icon(Icons.menu,
                  color: AppColors.textPrimary, size: 22),
            ),
            const SizedBox(width: 12),
            const Text('SPACEBOOK',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: AppColors.primary,
                    letterSpacing: 0.5)),
          ],
          const Spacer(),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.settings_outlined,
                size: 18, color: AppColors.textSecondary),
          ),
          const SizedBox(width: 8),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.notifications_outlined,
                size: 18, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 1:
        return const MySpacesScreen();
      default:
        return const Center(
          child: Text('Coming soon',
              style: TextStyle(color: AppColors.textSecondary)),
        );
    }
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}

class _SidebarContent extends StatelessWidget {
  final int selectedIndex;
  final List<_NavItem> navItems;
  final ValueChanged<int> onItemTap;

  const _SidebarContent({
    required this.selectedIndex,
    required this.navItems,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        children: [
          // Logo
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Image.asset('assets/images/logo2.png', width: 40, height: 40),
                const SizedBox(width: 8),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('SPACEBOOK',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: AppColors.textPrimary,
                              letterSpacing: 0.5)),
                      Text('Admin management',
                          style: TextStyle(
                              fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(Icons.keyboard_arrow_down,
                      size: 16, color: AppColors.textSecondary),
                )
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Nav items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: List.generate(navItems.length, (i) {
                final item = navItems[i];
                final isActive = selectedIndex == i;
                return _SidebarItem(
                  icon: item.icon,
                  label: item.label,
                  isActive: isActive,
                  badge: item.label == 'Analytics' ? 'On V2.1' : null,
                  hasArrow: item.label == 'My Spaces',
                  onTap: () => onItemTap(i),
                );
              }),
            ),
          ),

          const Divider(color: AppColors.border, height: 1),

          // Support + Logout
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Column(
              children: [
                _SidebarItem(
                  icon: Icons.headset_mic_outlined,
                  label: 'Support',
                  isActive: false,
                  onTap: () {},
                ),
                _SidebarItem(
                  icon: Icons.logout,
                  label: 'Log Out',
                  isActive: false,
                  isDestructive: true,
                  onTap: () {},
                ),
              ],
            ),
          ),

          // User profile
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child: const Icon(Icons.person,
                      size: 18, color: AppColors.primary),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Daniel Ebube',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary)),
                      Text('daniel21@gmail.com',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 11, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                const Icon(Icons.verified, size: 16, color: AppColors.primary),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool isDestructive;
  final bool hasArrow;
  final String? badge;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.isDestructive = false,
    this.hasArrow = false,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive
        ? Colors.red
        : isActive
            ? AppColors.primary
            : AppColors.textSecondary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withOpacity(0.06)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 10),
            Expanded(
              child: Text(label,
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                          isActive ? FontWeight.w600 : FontWeight.normal,
                      color: color)),
            ),
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(badge!,
                    style: const TextStyle(
                        fontSize: 10, color: AppColors.textSecondary)),
              ),
            if (hasArrow)
              const Icon(Icons.chevron_right,
                  size: 16, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
