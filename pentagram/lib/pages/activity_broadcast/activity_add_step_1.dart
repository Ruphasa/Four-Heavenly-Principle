import 'package:flutter/material.dart';
import 'package:pentagram/repositories/activity_constants.dart';
import 'package:pentagram/utils/app_colors.dart';
import 'package:pentagram/widgets/common/enhanced_dropdown.dart';
import 'package:pentagram/widgets/common/enhanced_text_field.dart';

class ActivityAddStep1 extends StatelessWidget {
  final TextEditingController namaController;
  final String? selectedKategori;
  final void Function(String?) onKategoriChanged;

  const ActivityAddStep1({
    required this.namaController,
    required this.selectedKategori,
    required this.onKategoriChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Informasi Dasar', Icons.info_outline),
        const SizedBox(height: 20),
        EnhancedTextField(
          controller: namaController,
          label: 'Nama Kegiatan',
          hint: 'Contoh: Kerja Bakti Lingkungan',
          icon: Icons.event_rounded,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Nama kegiatan harus diisi';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        EnhancedDropdown(
          value: selectedKategori,
          label: 'Kategori Kegiatan',
          hint: 'Pilih kategori',
          icon: Icons.category_rounded,
          items: ActivityConstants.kategoriOptions,
          onChanged: onKategoriChanged,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Kategori harus dipilih';
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
