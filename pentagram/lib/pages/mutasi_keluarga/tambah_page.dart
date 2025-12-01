import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide Family;
import 'package:pentagram/models/family.dart';
import 'package:pentagram/models/family_mutation.dart';
import 'package:pentagram/providers/firestore_providers.dart';
import 'package:pentagram/utils/app_colors.dart';

class TambahMutasiPage extends ConsumerStatefulWidget {
  const TambahMutasiPage({super.key});

  @override
  ConsumerState<TambahMutasiPage> createState() => _TambahMutasiPageState();
}

class _TambahMutasiPageState extends ConsumerState<TambahMutasiPage> {
  final _formKey = GlobalKey<FormState>();

  String? _jenisMutasi;
  Family? _keluarga;
  String? _alasanMutasi;
  String? _alamatLama;
  String? _alamatBaru;
  DateTime? _tanggalMutasi;
  bool _isSaving = false;

  final List<String> _jenisList = const ['Pindah Rumah', 'Pindah Kota', 'Pindah Negara'];

  Future<void> _pilihTanggalMutasi(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.textOnPrimary,
              surface: AppColors.cardBackground,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _tanggalMutasi = picked;
      });
    }
  }

  String _formatTanggal(DateTime? tanggal) {
    if (tanggal == null) return 'Pilih Tanggal';
    return '${tanggal.day.toString().padLeft(2, '0')}/${tanggal.month.toString().padLeft(2, '0')}/${tanggal.year}';
  }

  Future<void> _simpanData() async {
    if (!_formKey.currentState!.validate()) return;
    if (_jenisMutasi == null || _keluarga == null || _tanggalMutasi == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lengkapi jenis mutasi, keluarga, dan tanggal'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final repo = ref.read(familyMutationRepositoryProvider);
      final existing = await repo.list();
      final nextNo = _generateNextNo(existing);

      final mutation = FamilyMutation(
        no: nextNo,
        family: _keluarga!.name,
        type: _jenisMutasi!,
        date: _tanggalMutasi!,
        oldAddress: _sanitizeInput(_alamatLama ?? _keluarga!.address),
        newAddress: _sanitizeInput(_alamatBaru ?? '-'),
        reason: _sanitizeInput(_alasanMutasi ?? '-'),
      );

      await repo.create(mutation);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data mutasi berhasil disimpan'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan data: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final familiesAsync = ref.watch(familiesStreamProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        title: const Text('Tambah Mutasi Keluarga'),
        elevation: 0,
      ),
      body: familiesAsync.when(
        data: (families) => Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader('Data Mutasi'),
                _buildDropdownField(
                  label: 'Jenis Mutasi',
                  value: _jenisMutasi,
                  items: _jenisList,
                  icon: Icons.change_circle_rounded,
                  hint: '-- Pilih Jenis Mutasi --',
                  onChanged: (val) => setState(() => _jenisMutasi = val),
                ),
                const SizedBox(height: 16),
                _buildFamilyDropdown(families),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Alamat Lama',
                  hint: 'Masukkan alamat lama...',
                  icon: Icons.home_work_outlined,
                  onChanged: (val) => _alamatLama = val,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Alamat Baru',
                  hint: 'Masukkan alamat baru (opsional)...',
                  icon: Icons.location_on_outlined,
                  onChanged: (val) => _alamatBaru = val,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: 'Alasan Mutasi',
                  hint: 'Masukkan alasan mutasi...',
                  icon: Icons.text_fields_rounded,
                  maxLines: 3,
                  onChanged: (val) => _alasanMutasi = val,
                ),
                const SizedBox(height: 16),
                _buildDateField(
                  label: 'Tanggal Mutasi',
                  value: _tanggalMutasi,
                  onTap: () => _pilihTanggalMutasi(context),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isSaving ? null : () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textSecondary,
                          side: const BorderSide(color: AppColors.border),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Batal'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _simpanData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.textOnPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: _isSaving
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Text('Simpan Data'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: AppColors.error, size: 40),
                const SizedBox(height: 12),
                Text(
                  'Gagal memuat daftar keluarga: $error',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==== WIDGET HELPERS ====

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    void Function(String)? onChanged,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          maxLines: maxLines,
          onChanged: onChanged,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.textMuted),
            prefixIcon: Icon(icon, color: AppColors.primary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            filled: true,
            fillColor: AppColors.cardBackground,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required List<String> items,
    required IconData icon,
    required void Function(String?) onChanged,
    String? value,
    String? hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(12),
            color: AppColors.cardBackground,
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            isExpanded: true,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: AppColors.primary),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            icon: const Icon(Icons.arrow_drop_down_rounded, color: AppColors.primary),
            style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            hint: hint != null ? Text(hint) : null,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildFamilyDropdown(List<Family> families) {
    if (families.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
          color: AppColors.cardBackground,
        ),
        child: const Text('Belum ada data keluarga di database.'),
      );
    }

    final sortedFamilies = [...families]..sort((a, b) => a.name.compareTo(b.name));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Keluarga',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(12),
            color: AppColors.cardBackground,
          ),
          child: DropdownButtonFormField<Family>(
            value: _keluarga,
            isExpanded: true,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.family_restroom_rounded, color: AppColors.primary),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            icon: const Icon(Icons.arrow_drop_down_rounded, color: AppColors.primary),
            style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
            items: sortedFamilies
                .map(
                  (family) => DropdownMenuItem<Family>(
                    value: family,
                    child: Text(family.name),
                  ),
                )
                .toList(),
            hint: const Text('-- Pilih Keluarga --'),
            onChanged: (value) {
              setState(() {
                _keluarga = value;
                _alamatLama = value?.address;
              });
            },
            validator: (value) => value == null ? 'Pilih keluarga' : null,
          ),
        ),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? value,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(12),
              color: AppColors.cardBackground,
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_rounded, color: AppColors.primary, size: 20),
                const SizedBox(width: 12),
                Text(
                  _formatTanggal(value),
                  style: TextStyle(
                    fontSize: 14,
                    color: value == null ? AppColors.textMuted : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  int _generateNextNo(List<FamilyMutation> mutations) {
    var maxNo = 0;
    for (final mutation in mutations) {
      if (mutation.no > maxNo) maxNo = mutation.no;
    }
    return maxNo + 1;
  }

  String _sanitizeInput(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return '-';
    return trimmed;
  }
}
