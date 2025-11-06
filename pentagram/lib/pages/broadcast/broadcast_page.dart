import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pentagram/utils/app_colors.dart';
import 'package:pentagram/utils/responsive_helper.dart';
import 'package:pentagram/services/broadcast_service.dart';
import 'package:pentagram/models/broadcast_message.dart';
import 'package:pentagram/pages/broadcast/broadcast_create.dart';
import 'package:pentagram/pages/broadcast/broadcast_detail.dart';
import 'package:pentagram/providers/app_providers.dart';

class BroadcastPage extends ConsumerStatefulWidget {
  const BroadcastPage({super.key});

  @override
  ConsumerState<BroadcastPage> createState() => _BroadcastPageState();
}

class _BroadcastPageState extends ConsumerState<BroadcastPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  List<BroadcastMessage> _filteredMessages = [];
  bool _isHeaderVisible = true;

  BroadcastService get _broadcastService => ref.read(broadcastServiceProvider);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _filteredMessages = _getFilteredMessages();
      });
    });
    _scrollController.addListener(_onScroll);
    _loadMessages();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

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

  void _loadMessages() {
    setState(() {
      _filteredMessages = _getFilteredMessages();
    });
  }

  List<BroadcastMessage> _getFilteredMessages() {
    switch (_tabController.index) {
      case 0: // Semua
        return _broadcastService.getAllMessages();
      case 1: // Urgent
        return _broadcastService.getUrgentMessages();
      case 2: // Terkirim
        return _broadcastService.getSentMessages();
      default:
        return _broadcastService.getAllMessages();
    }
  }

  @override
  Widget build(BuildContext context) {
    final stats = _broadcastService.getBroadcastStatistics();
    final responsive = context.responsive;

    // Listen for controller errors to surface to UI (inside build)
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
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Header
            SliverAppBar(
              expandedHeight: responsive.isCompact ? 250 : 280,
              floating: false,
              pinned: true,
              backgroundColor: AppColors.primary,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary,
                        AppColors.primary.withOpacity(0.8),
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.all(responsive.padding(20)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(responsive.padding(8)),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(responsive.borderRadius(12)),
                                    ),
                                    child: Icon(
                                      Icons.campaign,
                                      color: Colors.white,
                                      size: responsive.iconSize(24),
                                    ),
                                  ),
                                  SizedBox(width: responsive.spacing(12)),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Total Broadcast',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.9),
                                          fontSize: responsive.fontSize(12),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        '${stats['totalMessages']}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: responsive.fontSize(24),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              IconButton(
                                onPressed: () {
                                  _showStatistics();
                                },
                                icon: const Icon(Icons.info_outline),
                                color: Colors.white,
                                iconSize: responsive.iconSize(28),
                              ),
                            ],
                          ),
                          SizedBox(height: responsive.spacing(20)),
                          Text(
                            'Broadcast Pesan',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: responsive.fontSize(28),
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                          ),
                          SizedBox(height: responsive.spacing(8)),
                          Text(
                            'Kirim pengumuman dan informasi ke warga RT',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: responsive.fontSize(15),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: responsive.spacing(24)),
                          // Stats Cards
                          Row(
                            children: [
                              Expanded(
                                child: _buildMiniStatCard(
                                  'Terkirim',
                                  stats['sent'],
                                  Icons.check_circle,
                                  responsive,
                                ),
                              ),
                              SizedBox(width: responsive.spacing(12)),
                              Expanded(
                                child: _buildMiniStatCard(
                                  'Urgent',
                                  stats['urgent'],
                                  Icons.priority_high,
                                  responsive,
                                ),
                              ),
                              SizedBox(width: responsive.spacing(12)),
                              Expanded(
                                child: _buildMiniStatCard(
                                  'Hari Ini',
                                  stats['today'],
                                  Icons.today,
                                  responsive,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Tab Bar
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                minHeight: responsive.isCompact ? 60 : 70,
                maxHeight: responsive.isCompact ? 60 : 70,
                child: Container(
                  color: const Color(0xFFF5F6FA),
                  padding: EdgeInsets.only(top: responsive.padding(10)),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: responsive.padding(20)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(responsive.borderRadius(12)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: responsive.elevation(15),
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(responsive.padding(4)),
                      child: TabBar(
                        controller: _tabController,
                        indicator: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(responsive.borderRadius(10)),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.3),
                              blurRadius: responsive.elevation(8),
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.grey[600],
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: responsive.fontSize(14),
                          letterSpacing: 0.3,
                        ),
                        unselectedLabelStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: responsive.fontSize(14),
                          letterSpacing: 0.2,
                        ),
                        labelPadding: EdgeInsets.symmetric(
                          horizontal: responsive.padding(8),
                          vertical: responsive.padding(12),
                        ),
                        tabs: const [
                          Tab(text: 'Semua'),
                          Tab(text: 'Urgent'),
                          Tab(text: 'Terkirim'),
                        ],
                        dividerColor: Colors.transparent,
                      ),
                    ),
                  ),
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
                        borderRadius: BorderRadius.circular(responsive.borderRadius(12)),
                      ),
                      child: Text(
                        '${_filteredMessages.length}',
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
            _filteredMessages.isEmpty
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
                        (context, index) {
                          final message = _filteredMessages[index];
                          return _buildMessageCard(message, responsive);
                        },
                        childCount: _filteredMessages.length,
                      ),
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButton: AnimatedScale(
        scale: _isHeaderVisible ? 1.0 : 0.9,
        duration: const Duration(milliseconds: 200),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(responsive.borderRadius(20)),
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.4),
                blurRadius: responsive.elevation(15),
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: FloatingActionButton.extended(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BroadcastCreatePage(),
                ),
              );
              if (result == true) {
                // Trigger controller refresh (no-op for sync service but keeps pattern consistent)
                await ref.read(broadcastControllerProvider.notifier).refresh();
                _loadMessages();
              }
            },
            backgroundColor: Colors.transparent,
            elevation: 0,
            icon: Icon(Icons.add_rounded, size: responsive.iconSize(28)),
            label: Text(
              'Buat Broadcast',
              style: TextStyle(
                fontSize: responsive.fontSize(16),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMiniStatCard(String label, int value, IconData icon, ResponsiveHelper responsive) {
    return Container(
      padding: EdgeInsets.all(responsive.padding(12)),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(responsive.borderRadius(12)),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: responsive.iconSize(20)),
          SizedBox(height: responsive.spacing(4)),
          Text(
            '$value',
            style: TextStyle(
              color: Colors.white,
              fontSize: responsive.fontSize(18),
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: responsive.fontSize(10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageCard(BroadcastMessage message, ResponsiveHelper responsive) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BroadcastDetailPage(message: message),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: responsive.spacing(12)),
        padding: EdgeInsets.all(responsive.padding(16)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(responsive.borderRadius(16)),
          border: message.isUrgent
              ? Border.all(color: Colors.red, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: responsive.elevation(10),
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(responsive.padding(8)),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(message.category).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(responsive.borderRadius(8)),
                  ),
                  child: Icon(
                    _getCategoryIcon(message.category),
                    color: _getCategoryColor(message.category),
                    size: responsive.iconSize(20),
                  ),
                ),
                SizedBox(width: responsive.spacing(12)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              message.title,
                              style: TextStyle(
                                fontSize: responsive.fontSize(16),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (message.isUrgent)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: responsive.padding(8),
                                vertical: responsive.padding(4),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(responsive.borderRadius(6)),
                              ),
                              child: Text(
                                'URGENT',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: responsive.fontSize(10),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: responsive.spacing(4)),
                      Text(
                        message.category,
                        style: TextStyle(
                          fontSize: responsive.fontSize(12),
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: responsive.spacing(12)),
            Text(
              message.content,
              style: TextStyle(
                fontSize: responsive.fontSize(14),
                color: Colors.grey[800],
                height: 1.5,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: responsive.spacing(12)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.person, size: responsive.iconSize(14), color: Colors.grey[600]),
                    SizedBox(width: responsive.spacing(4)),
                    Text(
                      message.sender,
                      style: TextStyle(
                        fontSize: responsive.fontSize(12),
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.schedule, size: responsive.iconSize(14), color: Colors.grey[600]),
                    SizedBox(width: responsive.spacing(4)),
                    Text(
                      _formatDate(message.sentDate),
                      style: TextStyle(
                        fontSize: responsive.fontSize(12),
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: responsive.spacing(8)),
            Row(
              children: [
                Icon(Icons.people, size: responsive.iconSize(14), color: Colors.grey[600]),
                SizedBox(width: responsive.spacing(4)),
                Text(
                  '${message.recipientCount} penerima',
                  style: TextStyle(
                    fontSize: responsive.fontSize(12),
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(width: responsive.spacing(16)),
                Icon(Icons.check_circle, size: responsive.iconSize(14), color: Colors.green),
                SizedBox(width: responsive.spacing(4)),
                Text(
                  '${message.readCount} dibaca',
                  style: TextStyle(
                    fontSize: responsive.fontSize(12),
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Kegiatan':
        return const Color(0xFF42A5F5);
      case 'Informasi Umum':
        return const Color(0xFF66BB6A);
      case 'Iuran':
        return const Color(0xFFFFB74D);
      case 'Keamanan':
        return const Color(0xFFEF5350);
      case 'Kesehatan':
        return const Color(0xFFAB47BC);
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Kegiatan':
        return Icons.event;
      case 'Informasi Umum':
        return Icons.info;
      case 'Iuran':
        return Icons.payment;
      case 'Keamanan':
        return Icons.security;
      case 'Kesehatan':
        return Icons.medical_services;
      default:
        return Icons.message;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Hari ini ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Kemarin';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari lalu';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: responsive.responsive<double>(mobile: 40, tablet: 50),
                height: responsive.responsive<double>(mobile: 4, tablet: 5),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(responsive.borderRadius(2)),
                ),
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
            _buildStatItem('Total Pesan Terkirim', '45', Icons.send, responsive),
            _buildStatItem('Pesan Urgent', '12', Icons.priority_high, responsive),
            _buildStatItem('Total Penerima', '342', Icons.people, responsive),
            _buildStatItem('Tingkat Baca', '87%', Icons.visibility, responsive),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, ResponsiveHelper responsive) {
    return Container(
      margin: EdgeInsets.only(bottom: responsive.spacing(12)),
      padding: EdgeInsets.all(responsive.padding(16)),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(responsive.borderRadius(12)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(responsive.padding(10)),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(responsive.borderRadius(10)),
            ),
            child: Icon(icon, color: AppColors.primary, size: responsive.iconSize(24)),
          ),
          SizedBox(width: responsive.spacing(16)),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: responsive.fontSize(14),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: responsive.fontSize(20),
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}