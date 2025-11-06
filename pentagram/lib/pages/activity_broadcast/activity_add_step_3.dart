import 'package:flutter/material.dart';
import 'package:pentagram/pages/activity_broadcast/components/activity_summary_card.dart';
import 'package:pentagram/repositories/activity_constants.dart';
import 'package:pentagram/utils/app_colors.dart';
import 'package:pentagram/utils/date_formatter.dart';
import 'package:pentagram/widgets/common/enhanced_dropdown.dart';
import 'package:pentagram/widgets/common/enhanced_text_field.dart';

class ActivityAddStep3 extends StatelessWidget {
  final TextEditingController deskripsiController;
  final String? selectedPenanggungJawab;
  final void Function(String?) onPenanggungJawabChanged;
  final TextEditingController namaController;
  final String? selectedKategori;
  final DateTime? selectedDate;
  final String? selectedLokasi;

  const ActivityAddStep3({
    required this.deskripsiController,
    required this.selectedPenanggungJawab,
    required this.onPenanggungJawabChanged,
    required this.namaController,
    required this.selectedKategori,
    required this.selectedDate,
    required this.selectedLokasi,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Detail Kegiatan', Icons.description_rounded),
        const SizedBox(height: 20),
        EnhancedDropdown(
          value: selectedPenanggungJawab,
          label: 'Penanggung Jawab',
          hint: 'Pilih penanggung jawab',
          icon: Icons.person_rounded,
          items: ActivityConstants.penanggungJawabOptions,
          onChanged: onPenanggungJawabChanged,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Penanggung jawab harus dipilih';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        EnhancedTextField(
          controller: deskripsiController,
          label: 'Deskripsi Kegiatan',
          hint: 'Jelaskan detail kegiatan...',
          icon: Icons.notes_rounded,
          maxLines: 5,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Deskripsi harus diisi';
            }
            return null;
          },
        ),
        const SizedBox(height: 24),
        // Summary Card
        SummaryCard(
          items: [
            SummaryItemData(
              label: 'Nama',
              value: namaController.text.isNotEmpty
                  ? namaController.text
                  : '-',
              icon: Icons.event_rounded,
            ),
            SummaryItemData(
              label: 'Kategori',
              value: selectedKategori ?? '-',
              icon: Icons.category_rounded,
            ),
            SummaryItemData(
              label: 'Tanggal',
              value: selectedDate != null
                  ? DateFormatter.formatDate(selectedDate!)
                  : '-',
              icon: Icons.calendar_today_rounded,
            ),
            SummaryItemData(
              label: 'Lokasi',
              value: selectedLokasi ?? '-',
              icon: Icons.location_on_rounded,
            ),
            SummaryItemData(
              label: 'Penanggung Jawab',
              value: selectedPenanggungJawab ?? '-',
              icon: Icons.person_rounded,
            ),
          ],
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
