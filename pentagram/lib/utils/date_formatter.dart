import 'package:intl/intl.dart';


class DateFormatter {
  static String formatDate(DateTime date) {
    // Create a DateFormat for Indonesian locale
    final formatter = DateFormat('d MMMM y', 'id_ID');
    return formatter.format(date);
  }
}