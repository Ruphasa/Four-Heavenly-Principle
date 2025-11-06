import 'package:flutter/material.dart';
import 'package:pentagram/repositories/activity_constants.dart';
import 'package:pentagram/utils/app_colors.dart';
import 'package:pentagram/widgets/common/enhanced_date_field.dart';
import 'package:pentagram/widgets/common/enhanced_dropdown.dart';

class ActivityAddStep2 extends StatelessWidget {
  final DateTime? selectedDate;
  final VoidCallback onDateTap;
  final String? selectedLokasi;
  final void Function(String?) onLokasiChanged;

  const ActivityAddStep2({
    required this.selectedDate,
    required this.onDateTap,
    required this.selectedLokasi,
    required this.onLokasiChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Waktu & Tempat', Icons.schedule_rounded),
        const SizedBox(height: 20),
        EnhancedDateField(
          selectedDate: selectedDate,
          label: 'Tanggal Pelaksanaan',
          hint: 'Pilih tanggal pelaksanaan',
          onTap: onDateTap,
        ),
        const SizedBox(height: 20),
        EnhancedDropdown(
          value: selectedLokasi,
          label: 'Lokasi Kegiatan',
          hint: 'Pilih lokasi',
          icon: Icons.location_on_rounded,
          items: ActivityConstants.lokasiOptions,
          onChanged: onLokasiChanged,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Lokasi harus dipilih';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
