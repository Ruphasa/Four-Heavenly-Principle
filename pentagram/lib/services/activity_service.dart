/// Legacy ActivityService removed; retained as no-op to avoid breaking imports.
class ActivityService {
  static final ActivityService _instance = ActivityService._internal();
  factory ActivityService() => _instance;
  ActivityService._internal();
}