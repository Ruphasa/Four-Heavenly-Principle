import 'package:flutter/material.dart';
import 'package:pentagram/utils/app_colors.dart';
import 'package:pentagram/utils/date_formatter.dart';

class EnhancedDateField extends StatelessWidget {
  final DateTime? selectedDate;
  final String label;
  final String hint;
  final VoidCallback onTap;

  const EnhancedDateField({
    super.key,
    required this.selectedDate,
    required this.label,
    required this.hint,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          // Date field
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  border: Border.all(
                    color: selectedDate == null
                        ? Colors.grey[300]!
                        : AppColors.primary,
                    width: selectedDate == null ? 1 : 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    // Calendar icon
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: selectedDate == null
                            ? Colors.grey[200]
                            : AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.event_rounded,
                        color: selectedDate == null
                            ? Colors.grey[600]
                            : AppColors.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Date text
                    Expanded(
                      child: Text(
                        selectedDate == null
                            ? hint
                            : DateFormatter.formatDate(selectedDate!),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: selectedDate == null
                              ? FontWeight.normal
                              : FontWeight.w600,
                          color: selectedDate == null
                              ? Colors.grey[600]
                              : Colors.black87,
                        ),
                      ),
                    ),

                    // Arrow icon
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey[400],
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
