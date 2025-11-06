import 'package:flutter/material.dart';
import 'package:pentagram/utils/app_colors.dart';
import 'package:pentagram/utils/responsive_helper.dart';

class FinanceFilterToggle extends StatelessWidget {
  final bool showIncome;
  final ValueChanged<bool> onChanged;

  const FinanceFilterToggle({
    super.key,
    required this.showIncome,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    
    return Container(
      padding: EdgeInsets.all(responsive.padding(4)),
      decoration: BoxDecoration(
        color: AppColors.backgroundGrey,
        borderRadius: BorderRadius.circular(responsive.borderRadius(12)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _FilterButton(
              label: 'Pemasukan',
              isSelected: showIncome,
              onTap: () => onChanged(true),
            ),
          ),
          Expanded(
            child: _FilterButton(
              label: 'Pengeluaran',
              isSelected: !showIncome,
              onTap: () => onChanged(false),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: responsive.padding(12)),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.background : Colors.transparent,
          borderRadius: BorderRadius.circular(responsive.borderRadius(8)),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: responsive.elevation(4),
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: responsive.fontSize(14),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
