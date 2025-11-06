import 'package:pentagram/models/activity_log.dart';
import 'package:pentagram/repositories/activity_log_repository.dart';

/// Service for ActivityLog business logic
class ActivityLogService {
  // Singleton pattern
  static final ActivityLogService _instance = ActivityLogService._internal();
  factory ActivityLogService() => _instance;
  ActivityLogService._internal();

  final ActivityLogRepository _repository = ActivityLogRepository();

  /// Get all activity logs
  List<ActivityLog> getAllActivityLogs() {
    return _repository.findAll();
  }

  /// Get recent activity logs with limit
  List<ActivityLog> getRecentActivityLogs({int limit = 5}) {
    return _repository.findRecent(limit: limit);
  }

  /// Get logs by actor
  List<ActivityLog> getLogsByActor(String aktor) {
    return _repository.findByActor(aktor);
  }

  /// Get today's logs
  List<ActivityLog> getTodayLogs() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
    
    return _repository.findByDateRange(startOfDay, endOfDay);
  }

  /// Add new activity log
  ActivityLog addActivityLog(String deskripsi, String aktor, String avatar) {
    final log = ActivityLog(
      no: 0, // Will be assigned by repository
      deskripsi: deskripsi,
      aktor: aktor,
      tanggal: DateTime.now(),
      avatar: avatar,
    );
    
    return _repository.create(log);
  }

  /// Get log statistics
  Map<String, dynamic> getLogStatistics() {
    final allLogs = _repository.findAll();
    final todayLogs = getTodayLogs();
    
    // Count by actor
    final actorCount = <String, int>{};
    for (var log in allLogs) {
      actorCount[log.aktor] = (actorCount[log.aktor] ?? 0) + 1;
    }

    return {
      'total': allLogs.length,
      'today': todayLogs.length,
      'uniqueActors': actorCount.length,
      'mostActiveActor': actorCount.entries
          .reduce((a, b) => a.value > b.value ? a : b)
          .key,
    };
  }

  /// Search logs by description
  List<ActivityLog> searchLogs(String query) {
    if (query.trim().isEmpty) {
      return getAllActivityLogs();
    }

    final lowercaseQuery = query.toLowerCase();
    return _repository.findAll().where((log) {
      return log.deskripsi.toLowerCase().contains(lowercaseQuery) ||
          log.aktor.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }
}