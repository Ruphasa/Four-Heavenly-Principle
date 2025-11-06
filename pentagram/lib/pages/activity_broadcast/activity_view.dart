import 'package:flutter/material.dart';
import 'package:pentagram/models/activity.dart';
import 'package:pentagram/services/activity_service.dart';
import 'package:pentagram/pages/activity_broadcast/components/activity_card.dart';
import 'package:pentagram/pages/activity_broadcast/components/activity_tab_bar.dart';
import 'package:pentagram/pages/activity_broadcast/components/no_activities.dart';
import 'package:pentagram/pages/activity_broadcast/components/activity_header.dart';
import 'package:pentagram/pages/activity_broadcast/activity_add.dart';
import 'package:pentagram/utils/app_colors.dart';
import 'package:pentagram/utils/sliver_app_bar_delegate.dart';
import 'package:pentagram/widgets/activity/activity_filter_dialog.dart';
import 'package:pentagram/widgets/activity/category_activities_dialog.dart';

class ActivityView extends StatefulWidget {
  const ActivityView({super.key});

  @override
  State<ActivityView> createState() => _ActivityViewState();
}

class _ActivityViewState extends State<ActivityView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ActivityService _activityService = ActivityService();
  final ScrollController _scrollController = ScrollController();
  
  List<Activity> _filteredActivities = [];
  bool _isHeaderVisible = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    _tabController.addListener(() {
      setState(() {
        _filteredActivities = _getFilteredActivities();
      });
    });
    _scrollController.addListener(_onScroll);
    _loadActivities();
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

  /// Load activities from service
  void _loadActivities() {
    setState(() {
      _filteredActivities = _getFilteredActivities();
    });
  }

  /// Get filtered activities based on selected tab
  List<Activity> _getFilteredActivities() {
    switch (_tabController.index) {
      case 0: // Selesai (Past)
        return _activityService.getPastActivities();
      case 1: // Hari Ini (Today)
        return _activityService.getTodayActivities();
      case 2: // Mendatang (Upcoming)
        return _activityService.getUpcomingActivities();
      default:
        return _activityService.getAllActivities();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 400;
    final totalActivities = _activityService.getTotalActivitiesCount();

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
                  onFilterTap: _showFilterDialog,
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
                        '${_filteredActivities.length}',
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

            // Activity List
            _filteredActivities.isEmpty
                ? const SliverFillRemaining(
                    hasScrollBody: false,
                    child: NoActivities(),
                  )
                : SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final activity = _filteredActivities[index];
                          return ActivityCard(
                            activity: activity,
                            number: index + 1,
                          );
                        },
                        childCount: _filteredActivities.length,
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
  void _showFilterDialog() {
    ActivityFilterDialog.show(
      context,
      activityService: _activityService,
      onCategorySelected: _showCategoryActivities,
    );
  }

  /// Show activities by category
  void _showCategoryActivities(String category) {
    final categoryActivities = _activityService.getActivitiesByCategory(category);
    CategoryActivitiesDialog.show(
      context,
      category: category,
      activities: categoryActivities,
    );
  }
}