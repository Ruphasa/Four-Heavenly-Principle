import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pentagram/utils/app_colors.dart';
import 'package:pentagram/utils/responsive_helper.dart';
import 'package:pentagram/models/broadcast_message.dart';
import 'package:pentagram/pages/broadcast/broadcast_create.dart';
import 'package:pentagram/providers/app_providers.dart';
import 'package:pentagram/providers/firestore_providers.dart';
import 'package:pentagram/widgets/broadcast/broadcast_message_card.dart';
import 'package:pentagram/widgets/broadcast/broadcast_header.dart';
import 'package:pentagram/widgets/broadcast/broadcast_tab_bar.dart';
import 'package:pentagram/widgets/broadcast/broadcast_stat_item.dart';
import 'package:pentagram/widgets/common/sliver_app_bar_delegate.dart';

class BroadcastPage extends ConsumerStatefulWidget {
  const BroadcastPage({super.key});

  @override
  ConsumerState<BroadcastPage> createState() => _BroadcastPageState();
}

class _BroadcastPageState extends ConsumerState<BroadcastPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  bool _isHeaderVisible = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() => setState(() {}));
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 100 && _isHeaderVisible) {
      setState(() => _isHeaderVisible = false);
    } else if (_scrollController.offset <= 100 && !_isHeaderVisible) {
      setState(() => _isHeaderVisible = true);
    }
  }

  List<BroadcastMessage> _filterMessages(List<BroadcastMessage> messages) {
    return _tabController.index == 1
        ? messages.where((m) => m.isUrgent).toList()
        : messages;
  }

  Map<String, int> _computeStats(List<BroadcastMessage> messages) {
    final now = DateTime.now();
    int urgent = 0;
    int today = 0;
    for (final m in messages) {
      if (m.isUrgent) urgent++;
      if (m.sentDate.year == now.year &&
          m.sentDate.month == now.month &&
          m.sentDate.day == now.day) {
        today++;
      }
    }
    return {
      'total': messages.length,
      'sent': messages.length,
      'urgent': urgent,
      'today': today,
    };
  }

  void _showStatistics() {
    final responsive = context.responsive;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(responsive.borderRadius(24)),
            topRight: Radius.circular(responsive.borderRadius(24)),
          ),
        ),
        padding: EdgeInsets.all(responsive.padding(24)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: responsive.spacing(24)),
            Text(
              'Statistik Broadcast',
              style: TextStyle(
                fontSize: responsive.fontSize(20),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: responsive.spacing(16)),
            BroadcastStatItem(
                label: 'Total Pesan Terkirim', value: '45', icon: Icons.send),
            BroadcastStatItem(
                label: 'Pesan Urgent',
                value: '12',
                icon: Icons.priority_high),
            BroadcastStatItem(
                label: 'Total Penerima', value: '342', icon: Icons.people),
            BroadcastStatItem(
                label: 'Tingkat Baca', value: '87%', icon: Icons.visibility),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final asyncMessages = ref.watch(broadcastMessagesStreamProvider);
    final responsive = context.responsive;

    ref.listen(broadcastControllerProvider, (previous, next) {
      final error = next.error;
      if (error != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: asyncMessages.when(
          data: (messages) {
            final filtered = _filterMessages(messages);
            final stats = _computeStats(messages);

            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                // Header
                SliverAppBar(
                  expandedHeight: responsive.isCompact ? 250 : 280,
                  floating: false,
                  pinned: true,
                  backgroundColor: AppColors.primary,
                  flexibleSpace: FlexibleSpaceBar(
                    background: BroadcastHeader(
                      totalMessages: stats['total']!,
                      sentMessages: stats['sent']!,
                      urgentMessages: stats['urgent']!,
                      todayMessages: stats['today']!,
                      onInfoPressed: _showStatistics,
                    ),
                  ),
                ),

                // Tab Bar
                SliverPersistentHeader(
                  pinned: true,
                  delegate: SliverAppBarDelegate(
                    minHeight: responsive.isCompact ? 60 : 70,
                    maxHeight: responsive.isCompact ? 60 : 70,
                    child: Container(
                      color: const Color(0xFFF5F6FA),
                      padding: EdgeInsets.only(top: responsive.padding(10)),
                      child: BroadcastTabBar(controller: _tabController),
                    ),
                  ),
                ),

                // Messages List Label
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      responsive.padding(20),
                      responsive.padding(20),
                      responsive.padding(20),
                      responsive.padding(16),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Daftar Pesan',
                          style: TextStyle(
                            fontSize: responsive.fontSize(18),
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(width: responsive.spacing(8)),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: responsive.padding(10),
                            vertical: responsive.padding(4),
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(
                                responsive.borderRadius(12)),
                          ),
                          child: Text(
                            '${filtered.length}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: responsive.fontSize(12),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Messages List
                filtered.isEmpty
                    ? SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.campaign_outlined,
                                size: responsive.iconSize(80),
                                color: Colors.grey[300],
                              ),
                              SizedBox(height: responsive.spacing(16)),
                              Text(
                                'Belum ada broadcast',
                                style: TextStyle(
                                  fontSize: responsive.fontSize(16),
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : SliverPadding(
                        padding: EdgeInsets.fromLTRB(
                          responsive.padding(20),
                          0,
                          responsive.padding(20),
                          100,
                        ),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => BroadcastMessageCard(
                              message: filtered[index],
                            ),
                            childCount: filtered.length,
                          ),
                        ),
                      ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(child: Text('Error: $e')),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const BroadcastCreatePage(),
            ),
          );
          if (result == true) {
            await ref.read(broadcastControllerProvider.notifier).refresh();
          }
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Buat Broadcast'),
      ),
    );
  }
}
