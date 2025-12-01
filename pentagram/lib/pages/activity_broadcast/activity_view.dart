import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pentagram/models/activity.dart';
import 'package:pentagram/pages/activity_broadcast/components/activity_card.dart';
import 'package:pentagram/pages/activity_broadcast/components/activity_tab_bar.dart';
import 'package:pentagram/pages/activity_broadcast/components/no_activities.dart';
import 'package:pentagram/pages/activity_broadcast/components/activity_header.dart';
import 'package:pentagram/pages/activity_broadcast/activity_add.dart';
import 'package:pentagram/utils/app_colors.dart';
import 'package:pentagram/utils/sliver_app_bar_delegate.dart';
import 'package:pentagram/widgets/activity/activity_filter_dialog.dart';
import 'package:pentagram/widgets/activity/category_activities_dialog.dart';
import 'package:pentagram/providers/firestore_providers.dart';

class ActivityView extends ConsumerStatefulWidget {
  const ActivityView({super.key});

  @override
  ConsumerState<ActivityView> createState() => _ActivityViewState();
}

class _ActivityViewState extends ConsumerState<ActivityView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  bool _isHeaderVisible = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    _tabController.addListener(() {
      setState(() {});
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Handle scroll to hide/show header
  void _onScroll() {
    if (_scrollController.offset > 100 && _isHeaderVisible) {
      setState(() {
        _isHeaderVisible = false;
      });
    } else if (_scrollController.offset <= 100 && !_isHeaderVisible) {
      setState(() {
        _isHeaderVisible = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final activitiesAsync = ref.watch(activitiesStreamProvider);
    final activities = activitiesAsync.asData?.value ?? const <Activity>[];
    final filteredActivities = _getFilteredActivities(activities);
    final totalActivities = activities.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Header Section (Collapsible)
            SliverAppBar(
              expandedHeight: 320,
              floating: false,
              pinned: true,
              backgroundColor: AppColors.primary,
              flexibleSpace: FlexibleSpaceBar(
                background: ActivityHeader(
                  totalActivities: totalActivities,
                  onFilterTap: () => _showFilterDialog(activities),
                ),
              ),
            ),

            // Tab Bar (Sticky)
            SliverPersistentHeader(
              pinned: true,
              delegate: SliverAppBarDelegate(
                minHeight: 70,
                maxHeight: 70,
                child: Container(
                  color: const Color(0xFFF5F6FA),
                  padding: const EdgeInsets.only(top: 10),
                  child: ActivityTabBar(tabController: _tabController),
                ),
              ),
            ),

            // Current Task Label
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                child: Row(
                  children: [
                    const Text(
                      'Daftar Kegiatan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${filteredActivities.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            activitiesAsync.when(
              data: (data) {
                final currentFiltered = _getFilteredActivities(data);
                if (currentFiltered.isEmpty) {
                  return const SliverFillRemaining(
                    hasScrollBody: false,
                    child: NoActivities(),
                  );
                }
                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final activity = currentFiltered[index];
                        return ActivityCard(
                          activity: activity,
                          number: index + 1,
                        );
                      },
                      childCount: currentFiltered.length,
                    ),
                  ),
                );
              },
              loading: () => const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text('Gagal memuat kegiatan: $e'),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ActivityAdd(),
          ),
        ),
        child: const Icon(Icons.add, color: AppColors.textOnPrimary),
      ),
    );
  }

  /// Show filter dialog
  void _showFilterDialog(List<Activity> activities) {
    if (activities.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Belum ada data kegiatan untuk difilter.')),
      );
      return;
    }

    final categories = _buildCategorySummary(activities);
    ActivityFilterDialog.show(
      context,
      categories: categories,
      onCategorySelected: (category) =>
          _showCategoryActivities(category, activities),
    );
  }

  /// Show activities by category
  void _showCategoryActivities(String category, List<Activity> activities) {
    final categoryActivities = activities
        .where((activity) => activity.kategori == category)
        .toList()
      ..sort((a, b) => a.tanggal.compareTo(b.tanggal));
    CategoryActivitiesDialog.show(
      context,
      category: category,
      activities: categoryActivities,
    );
  }

  List<Activity> _getFilteredActivities(List<Activity> activities) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final todayEnd = today.add(const Duration(days: 1));

    List<Activity> result;
    switch (_tabController.index) {
      case 0:
        result = activities
            .where((activity) => activity.tanggal.isBefore(today))
            .toList()
          ..sort((a, b) => b.tanggal.compareTo(a.tanggal));
        break;
      case 1:
        result = activities
            .where((activity) =>
                !activity.tanggal.isBefore(today) &&
                activity.tanggal.isBefore(todayEnd))
            .toList()
          ..sort((a, b) => a.tanggal.compareTo(b.tanggal));
        break;
      case 2:
        result = activities
            .where((activity) => !activity.tanggal.isBefore(todayEnd))
            .toList()
          ..sort((a, b) => a.tanggal.compareTo(b.tanggal));
        break;
      default:
        result = List<Activity>.from(activities)
          ..sort((a, b) => a.tanggal.compareTo(b.tanggal));
    }
    return result;
  }

  List<ActivityCategorySummary> _buildCategorySummary(
    List<Activity> activities,
  ) {
    final map = <String, int>{};
    for (final activity in activities) {
      map[activity.kategori] = (map[activity.kategori] ?? 0) + 1;
    }
    final items = map.entries
        .map((entry) => ActivityCategorySummary(entry.key, entry.value))
        .toList()
      ..sort((a, b) => b.count.compareTo(a.count));
    return items;
  }
}