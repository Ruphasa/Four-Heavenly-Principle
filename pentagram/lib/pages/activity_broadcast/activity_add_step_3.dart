import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pentagram/pages/activity_broadcast/components/activity_summary_card.dart';
import 'package:pentagram/providers/firestore_providers.dart';
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
        // Penanggung Jawab Dropdown - Using Firestore data
        Consumer(
          builder: (context, ref, child) {
            final citizensAsync = ref.watch(citizensWithUserStreamProvider);
            
            return citizensAsync.when(
              data: (citizensWithUser) {
                if (citizensWithUser.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.orange[700], size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Belum ada data warga. Silakan tambah warga terlebih dahulu.',
                            style: TextStyle(color: Colors.orange[900], fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                
                // Build list of citizen names
                final citizenNames = citizensWithUser.map((cw) => cw.name).toList();
                
                return EnhancedDropdown(
                  value: selectedPenanggungJawab,
                  label: 'Penanggung Jawab',
                  hint: 'Pilih penanggung jawab',
                  icon: Icons.person_rounded,
                  items: citizenNames,
                  onChanged: onPenanggungJawabChanged,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Penanggung jawab harus dipilih';
                    }
                    return null;
                  },
                );
              },
              loading: () => Container(
                padding: const EdgeInsets.all(16),
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
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Memuat data warga...',
                      style: TextStyle(color: Colors.black54, fontSize: 14),
                    ),
                  ],
                ),
              ),
              error: (error, stack) => Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red[700], size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Gagal memuat data: $error',
                        style: TextStyle(color: Colors.red[900], fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            );
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
