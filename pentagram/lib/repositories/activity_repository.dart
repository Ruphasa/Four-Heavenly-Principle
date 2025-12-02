import 'package:pentagram/models/activity.dart';

/// Repository for Activity data access
/// This layer handles data operations (CRUD)
class ActivityRepository {
  // Singleton pattern
  static final ActivityRepository _instance = ActivityRepository._internal();
  factory ActivityRepository() => _instance;
  ActivityRepository._internal();

  // In-memory storage placeholder; now intentionally empty to avoid dummy data
  final List<Activity> _activities = [];
  /// Get all activities from data source
  List<Activity> findAll() {
    return List.from(_activities);
  }

  /// Find activity by ID
  Activity? findById(int id) {
    try {
      return _activities.firstWhere((activity) => activity.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Find activities by category
  List<Activity> findByCategory(String category) {
    return _activities
        .where((activity) => activity.kategori == category)
        .toList();
  }

  /// Find activities by date range
  List<Activity> findByDateRange(DateTime start, DateTime end) {
    return _activities.where((activity) {
      return activity.tanggal.isAfter(start.subtract(const Duration(days: 1))) &&
          activity.tanggal.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  /// Create new activity
  Activity create(Activity activity) {
    // Generate new ID
    final newId = _activities.isEmpty 
        ? 1 
        : _activities.map((a) => a.id).reduce((a, b) => a > b ? a : b) + 1;
    
    final newActivity = activity.copyWith(id: newId);
    _activities.add(newActivity);
    return newActivity;
  }

  /// Update existing activity
  Activity? update(Activity activity) {
    final index = _activities.indexWhere((a) => a.id == activity.id);
    if (index != -1) {
      _activities[index] = activity;
      return activity;
    }
    return null;
  }

  /// Delete activity by ID
  bool delete(int id) {
    final initialLength = _activities.length;
    _activities.removeWhere((activity) => activity.id == id);
    return _activities.length < initialLength;
  }

  /// Check if activity exists
  bool exists(int id) {
    return _activities.any((activity) => activity.id == id);
  }

  /// Get total count of activities
  int count() {
    return _activities.length;
  }

  /// Clear all activities (for testing purposes)
  void clear() {
    _activities.clear();
  }
}