import 'package:flutter/material.dart';
import 'package:pentagram/utils/app_colors.dart';

class FilterPesanDialog extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterSelected;

  const FilterPesanDialog({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: const Text(
        'Filter Pesan',
        style: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDialogOption(context, 'Semua', Icons.all_inbox_rounded),
          _buildDialogOption(context, 'Belum Dibaca', Icons.mark_email_unread_rounded),
          _buildDialogOption(context, 'Sudah Dibaca', Icons.drafts_rounded),
        ],
      ),
    );
  }

  Widget _buildDialogOption(BuildContext context, String label, IconData icon) {
    final isSelected = selectedFilter == label;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppColors.primary : AppColors.iconPrimary,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing:
          isSelected ? const Icon(Icons.check_circle_rounded, color: AppColors.primary) : null,
      onTap: () {
        onFilterSelected(label);
        Navigator.pop(context);
      },
    );
  }
}
