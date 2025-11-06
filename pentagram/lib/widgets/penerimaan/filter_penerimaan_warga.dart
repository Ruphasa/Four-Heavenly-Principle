import 'package:flutter/material.dart';
import 'package:pentagram/utils/app_colors.dart';

class FilterPenerimaanWargaDialog extends StatelessWidget {
  final String selectedGender;
  final Function(String) onFilterSelected;

  const FilterPenerimaanWargaDialog({
    super.key,
    required this.selectedGender,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        'Filter Jenis Kelamin',
        style: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildOption(context, 'Semua', Icons.people_alt_rounded),
          _buildOption(context, 'Laki-laki', Icons.male_rounded),
          _buildOption(context, 'Perempuan', Icons.female_rounded),
        ],
      ),
    );
  }

  Widget _buildOption(BuildContext context, String label, IconData icon) {
    final isSelected = selectedGender == label;
    return ListTile(
      leading: Icon(icon,
          color: isSelected ? AppColors.primary : AppColors.iconPrimary),
      title: Text(
        label,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
          : null,
      onTap: () {
        onFilterSelected(label);
        Navigator.pop(context);
      },
    );
  }
}
