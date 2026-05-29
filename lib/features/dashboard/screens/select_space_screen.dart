import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/constants/app_colors.dart';
import 'dashboard_screen.dart';

// Provider to pass selected space ID to edit screen
final selectedSpaceIdProvider = StateProvider<String?>((ref) => null);

class SelectSpaceScreen extends ConsumerWidget {
  const SelectSpaceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchSpaces(),
      builder: (context, snapshot) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(isMobile ? 16 : 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Select a Space to Edit',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 4),
              const Text('Choose which space you want to edit',
                  style:
                      TextStyle(fontSize: 14, color: AppColors.textSecondary)),
              const SizedBox(height: 28),
              if (snapshot.connectionState == ConnectionState.waiting)
                const Center(child: CircularProgressIndicator())
              else if (snapshot.hasError)
                Center(
                  child: Text('Failed to load spaces: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red)),
                )
              else if (!snapshot.hasData || snapshot.data!.isEmpty)
                const Center(
                  child: Text('No spaces found.',
                      style: TextStyle(color: AppColors.textSecondary)),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) {
                    final space = snapshot.data![i];
                    return _SpaceListTile(
                      space: space,
                      onEdit: () {
                        ref.read(selectedSpaceIdProvider.notifier).state =
                            space['id'] as String;
                        ref.read(dashboardIndexProvider.notifier).state = 8;
                      },
                      onDelete: () async {
                        await Supabase.instance.client
                            .from('spaces')
                            .delete()
                            .eq('id', space['id']);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Space deleted'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          ref.read(dashboardIndexProvider.notifier).state = 1;
                        }
                      },
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Future<List<Map<String, dynamic>>> _fetchSpaces() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return [];
    final response = await Supabase.instance.client
        .from('spaces')
        .select()
        .eq('owner_id', userId)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }
}

class _SpaceListTile extends StatelessWidget {
  final Map<String, dynamic> space;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _SpaceListTile({
    required this.space,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final status = space['status'] ?? 'draft';
    final isActive = status == 'active';
    final photos = space['photos'] as List?;
    final photoUrl =
        (photos != null && photos.isNotEmpty) ? photos[0] as String : null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: photoUrl != null
                ? Image.network(photoUrl,
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholder())
                : _placeholder(),
          ),
          const SizedBox(width: 16),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(space['title'] ?? '',
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Text(space['space_type'] ?? '',
                    style: const TextStyle(
                        fontSize: 13, color: AppColors.textSecondary)),
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isActive
                        ? const Color(0xFFDCFCE7)
                        : const Color(0xFFFEF9C3),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isActive
                          ? const Color(0xFF166534)
                          : const Color(0xFF854D0E),
                    ),
                  ),
                  child: Text(
                    isActive ? 'Active' : 'Paused',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: isActive
                            ? const Color(0xFF166534)
                            : const Color(0xFF854D0E)),
                  ),
                ),
              ],
            ),
          ),

          // 3-dot menu
          Builder(
            builder: (ctx) => GestureDetector(
              onTap: () => _showMenu(ctx),
              child: const Icon(Icons.more_vert,
                  size: 20, color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

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
      items: <PopupMenuEntry>[
        PopupMenuItem(
          padding: EdgeInsets.zero,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
              onEdit();
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(Icons.edit_outlined,
                      size: 16, color: AppColors.textPrimary),
                  SizedBox(width: 10),
                  Text('Edit Space',
                      style: TextStyle(
                          fontSize: 14, color: AppColors.textPrimary)),
                ],
              ),
            ),
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          padding: EdgeInsets.zero,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
              onDelete();
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(Icons.delete_outline, size: 16, color: Colors.red),
                  SizedBox(width: 10),
                  Text('Delete Space',
                      style: TextStyle(fontSize: 14, color: Colors.red)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _placeholder() {
    return Container(
      width: 64,
      height: 64,
      color: const Color(0xFFF3F4F6),
      child: const Center(
        child:
            Icon(Icons.home_work_outlined, size: 28, color: AppColors.border),
      ),
    );
  }
}
