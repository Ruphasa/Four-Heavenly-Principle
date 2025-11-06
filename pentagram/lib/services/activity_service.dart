import 'package:flutter/material.dart';
import 'package:pentagram/models/activity.dart';
import 'package:pentagram/repositories/activity_repository.dart';

/// Service for Activity business logic
/// This layer handles business rules and orchestrates data operations
class ActivityService {
  // Singleton pattern
  static final ActivityService _instance = ActivityService._internal();
  factory ActivityService() => _instance;
  ActivityService._internal();

  final ActivityRepository _repository = ActivityRepository();

  /// Get all activities
  List<Activity> getAllActivities() {
    return _repository.findAll();
  }

  /// Get upcoming activities (today and future)
  List<Activity> getUpcomingActivities() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    return _repository.findAll().where((activity) {
      final activityDate = DateTime(
        activity.tanggal.year,
        activity.tanggal.month,
        activity.tanggal.day,
      );
      return activityDate.isAtSameMomentAs(today) || 
             activityDate.isAfter(today);
    }).toList()
      ..sort((a, b) => a.tanggal.compareTo(b.tanggal));
  }

  /// Get past activities (completed)
  List<Activity> getPastActivities() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    return _repository.findAll().where((activity) {
      final activityDate = DateTime(
        activity.tanggal.year,
        activity.tanggal.month,
        activity.tanggal.day,
      );
      return activityDate.isBefore(today);
    }).toList()
      ..sort((a, b) => b.tanggal.compareTo(a.tanggal));
  }

  /// Get today's activities
  List<Activity> getTodayActivities() {
    final now = DateTime.now();
    return _repository.findAll().where((activity) {
      return activity.tanggal.year == now.year &&
          activity.tanggal.month == now.month &&
          activity.tanggal.day == now.day;
    }).toList()
      ..sort((a, b) => a.tanggal.compareTo(b.tanggal));
  }

  /// Get activities by category
  List<Activity> getActivitiesByCategory(String category) {
    return _repository.findByCategory(category);
  }

  /// Get activity by ID
  Activity? getActivityById(int id) {
    return _repository.findById(id);
  }

  /// Get activities for current month
  List<Activity> getCurrentMonthActivities() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);
    
    return _repository.findByDateRange(startOfMonth, endOfMonth);
  }

  /// Get monthly statistics
  Map<String, dynamic> getMonthlyStatistics() {
    final allActivities = _repository.findAll();
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    final monthlyActivities = allActivities.where((activity) {
      return activity.tanggal.isAfter(firstDayOfMonth.subtract(const Duration(days: 1))) &&
          activity.tanggal.isBefore(lastDayOfMonth.add(const Duration(days: 1)));
    }).toList();

    final completed = monthlyActivities.where((a) => 
      a.tanggal.isBefore(now.subtract(const Duration(days: 1)))
    ).length;

    final total = monthlyActivities.length;
    final percentage = total > 0 ? ((completed / total) * 100).round() : 0;
    final remaining = total - completed;

    return {
      'total': total,
      'completed': completed,
      'percentage': percentage,
      'remaining': remaining,
    };
  }

  /// Add new activity
  Activity addActivity(Activity activity) {
    return _repository.create(activity);
  }

  /// Update existing activity
  bool updateActivity(Activity activity) {
    return _repository.update(activity) != null;
  }

  /// Delete activity
  bool deleteActivity(int id) {
    return _repository.delete(id);
  }

  /// Check if activity can be edited (business rule)
  bool canEditActivity(Activity activity) {
    // Example business rule: Can only edit future activities
    final now = DateTime.now();
    return activity.tanggal.isAfter(now);
  }

  /// Check if activity can be deleted (business rule)
  bool canDeleteActivity(Activity activity) {
    // Example business rule: Can delete any activity
    return true;
  }

  /// Get total activities count
  int getTotalActivitiesCount() {
    return _repository.count();
  }

  /// Search activities by name
  List<Activity> searchActivities(String query) {
    if (query.trim().isEmpty) {
      return getAllActivities();
    }

    final lowercaseQuery = query.toLowerCase();
    return _repository.findAll().where((activity) {
      return activity.nama.toLowerCase().contains(lowercaseQuery) ||
          activity.kategori.toLowerCase().contains(lowercaseQuery) ||
          activity.penanggungJawab.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  /// Get activities by responsible person
  List<Activity> getActivitiesByPenanggungJawab(String penanggungJawab) {
    return _repository.findAll()
        .where((activity) => activity.penanggungJawab == penanggungJawab)
        .toList();
  }

  /// Get popular categories with count and percentage
  List<Map<String, dynamic>> getPopularCategories() {
    final allActivities = _repository.findAll();
    if (allActivities.isEmpty) {
      return [];
    }

    final categoryCount = <String, int>{};
    
    for (var activity in allActivities) {
      categoryCount[activity.kategori] = 
        (categoryCount[activity.kategori] ?? 0) + 1;
    }

    final total = allActivities.length;
    final categories = categoryCount.entries.map((entry) {
      final percentage = total > 0 ? ((entry.value / total) * 100).round() : 0;
      return {
        'kategori': entry.key,
        'count': entry.value,
        'percentage': percentage,
      };
    }).toList();

    categories.sort((a, b) => (b['count'] as int).compareTo(a['count'] as int));
    
    return categories;
  }

    /// Get activity statistics
  Map<String, dynamic> getActivityStatistics() {
    final allActivities = _repository.findAll();
    final now = DateTime.now();
    
    final completed = allActivities.where((a) => 
      a.tanggal.isBefore(now.subtract(const Duration(days: 1)))
    ).length;
    
    final ongoing = allActivities.where((a) {
      final activityDate = DateTime(a.tanggal.year, a.tanggal.month, a.tanggal.day);
      final today = DateTime(now.year, now.month, now.day);
      return activityDate.isAtSameMomentAs(today);
    }).length;
    
    final upcoming = allActivities.where((a) => 
      a.tanggal.isAfter(now)
    ).length;
    
    return {
      'totalActivities': allActivities.length,
      'activityChange': 15.0, // Percentage change from last period
      'completed': completed,
      'ongoing': ongoing,
      'upcoming': upcoming,
    };
  }

  /// Get activity by category with statistics
  List<Map<String, dynamic>> getActivityByCategory() {
    final categories = getPopularCategories();
    if (categories.isEmpty) {
      return [];
    }

    final colors = [
      const Color(0xFF42A5F5),
      const Color(0xFF66BB6A),
      const Color(0xFFFFB74D),
      const Color(0xFFEF5350),
      const Color(0xFFAB47BC),
    ];
    
    return categories.asMap().entries.map((entry) {
      final index = entry.key;
      final cat = entry.value;
      return {
        'category': cat['kategori'] as String,
        'count': cat['count'] as int,
        'percentage': cat['percentage'] as int,
        'color': colors[index % colors.length],
      };
    }).toList();
  }

  /// Get top contributors (most responsible persons)
  List<Map<String, dynamic>> getTopContributors() {
    final allActivities = _repository.findAll();
    if (allActivities.isEmpty) {
      return [];
    }

    final contributorMap = <String, Map<String, int>>{};
    
    for (var activity in allActivities) {
      if (!contributorMap.containsKey(activity.penanggungJawab)) {
        contributorMap[activity.penanggungJawab] = {
          'activities': 0,
          'participants': 0,
        };
      }
      contributorMap[activity.penanggungJawab]!['activities'] = 
        contributorMap[activity.penanggungJawab]!['activities']! + 1;
      contributorMap[activity.penanggungJawab]!['participants'] = 
        contributorMap[activity.penanggungJawab]!['participants']! + activity.peserta;
    }
    
    final contributors = contributorMap.entries.map((entry) {
      return {
        'name': entry.key,
        'activities': entry.value['activities'] ?? 0,
        'participants': entry.value['participants'] ?? 0,
      };
    }).toList();
    
    contributors.sort((a, b) => 
      (b['activities'] as int).compareTo(a['activities'] as int)
    );
    
    return contributors.take(5).toList();
  }
}