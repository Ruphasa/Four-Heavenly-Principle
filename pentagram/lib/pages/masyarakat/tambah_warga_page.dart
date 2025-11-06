import 'package:flutter/material.dart';
import 'package:pentagram/utils/app_colors.dart';

class TambahWargaPage extends StatefulWidget {
  const TambahWargaPage({super.key});

  @override
  State<TambahWargaPage> createState() => _TambahWargaPageState();
}

class _TambahWargaPageState extends State<TambahWargaPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _nikController = TextEditingController();
  final _tempatLahirController = TextEditingController();
  final _alamatController = TextEditingController();
  final _noTelpController = TextEditingController();
  
  DateTime? _tanggalLahir;
  String _jenisKelamin = 'Laki-laki';
  String _statusPerkawinan = 'Belum Kawin';
  String _agama = 'Islam';
  String _pekerjaan = '';
  String _pendidikan = 'SD';
  String _statusDomisili = 'Tetap';
  String _statusHidup = 'Hidup';
  String _hubunganKeluarga = 'Kepala Keluarga';

  final List<String> _jenisKelaminOptions = ['Laki-laki', 'Perempuan'];
  final List<String> _statusPerkawinanOptions = ['Belum Kawin', 'Kawin', 'Cerai Hidup', 'Cerai Mati'];
  final List<String> _agamaOptions = ['Islam', 'Kristen', 'Katolik', 'Hindu', 'Buddha', 'Konghucu'];
  final List<String> _pendidikanOptions = ['Tidak/Belum Sekolah', 'SD', 'SMP', 'SMA', 'D3', 'S1', 'S2', 'S3'];
  final List<String> _statusDomisiliOptions = ['Tetap', 'Sementara', 'Pindah'];
  final List<String> _statusHidupOptions = ['Hidup', 'Meninggal'];
  final List<String> _hubunganKeluargaOptions = [
    'Kepala Keluarga',
    'Istri',
    'Suami',
    'Anak',
    'Menantu',
    'Cucu',
    'Orang Tua',
    'Mertua',
    'Famili Lain',
    'Pembantu',
  ];

  @override
  void dispose() {
    _namaController.dispose();
    _nikController.dispose();
    _tempatLahirController.dispose();
    _alamatController.dispose();
    _noTelpController.dispose();
    super.dispose();
  }

  Future<void> _pilihTanggalLahir(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
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
        _tanggalLahir = picked;
      });
    }
  }

  String _formatTanggal(DateTime? tanggal) {
    if (tanggal == null) return 'Pilih Tanggal';
    return '${tanggal.day.toString().padLeft(2, '0')}/${tanggal.month.toString().padLeft(2, '0')}/${tanggal.year}';
  }

  void _simpanData() {
    if (_formKey.currentState!.validate()) {
      if (_tanggalLahir == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Harap pilih tanggal lahir'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      // TODO: Implement save functionality
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data warga berhasil disimpan'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        title: const Text('Tambah Warga'),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Data Identitas Section
              _buildSectionHeader('Data Identitas'),
              _buildTextField(
                controller: _namaController,
                label: 'Nama Lengkap',
                hint: 'Masukkan nama lengkap',
                icon: Icons.person_rounded,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _nikController,
                label: 'NIK',
                hint: 'Masukkan NIK 16 digit',
                icon: Icons.badge_rounded,
                keyboardType: TextInputType.number,
                maxLength: 16,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'NIK tidak boleh kosong';
                  }
                  if (value.length != 16) {
                    return 'NIK harus 16 digit';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildDropdownField(
                label: 'Jenis Kelamin',
                value: _jenisKelamin,
                items: _jenisKelaminOptions,
                icon: Icons.wc_rounded,
                onChanged: (value) {
                  setState(() {
                    _jenisKelamin = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _tempatLahirController,
                label: 'Tempat Lahir',
                hint: 'Masukkan tempat lahir',
                icon: Icons.location_city_rounded,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tempat lahir tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildDateField(
                label: 'Tanggal Lahir',
                value: _tanggalLahir,
                onTap: () => _pilihTanggalLahir(context),
              ),
              const SizedBox(height: 24),

              // Data Keluarga Section
              _buildSectionHeader('Data Keluarga'),
              _buildDropdownField(
                label: 'Hubungan dalam Keluarga',
                value: _hubunganKeluarga,
                items: _hubunganKeluargaOptions,
                icon: Icons.family_restroom_rounded,
                onChanged: (value) {
                  setState(() {
                    _hubunganKeluarga = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildDropdownField(
                label: 'Status Perkawinan',
                value: _statusPerkawinan,
                items: _statusPerkawinanOptions,
                icon: Icons.favorite_rounded,
                onChanged: (value) {
                  setState(() {
                    _statusPerkawinan = value!;
                  });
                },
              ),
              const SizedBox(height: 24),

              // Data Lainnya Section
              _buildSectionHeader('Data Lainnya'),
              _buildDropdownField(
                label: 'Agama',
                value: _agama,
                items: _agamaOptions,
                icon: Icons.mosque_rounded,
                onChanged: (value) {
                  setState(() {
                    _agama = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildDropdownField(
                label: 'Pendidikan Terakhir',
                value: _pendidikan,
                items: _pendidikanOptions,
                icon: Icons.school_rounded,
                onChanged: (value) {
                  setState(() {
                    _pendidikan = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: TextEditingController(text: _pekerjaan),
                label: 'Pekerjaan',
                hint: 'Masukkan pekerjaan',
                icon: Icons.work_rounded,
                onChanged: (value) {
                  _pekerjaan = value;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _alamatController,
                label: 'Alamat',
                hint: 'Masukkan alamat lengkap',
                icon: Icons.home_rounded,
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Alamat tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _noTelpController,
                label: 'No. Telepon',
                hint: 'Masukkan nomor telepon',
                icon: Icons.phone_rounded,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              _buildDropdownField(
                label: 'Status Domisili',
                value: _statusDomisili,
                items: _statusDomisiliOptions,
                icon: Icons.location_on_rounded,
                onChanged: (value) {
                  setState(() {
                    _statusDomisili = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildDropdownField(
                label: 'Status Hidup',
                value: _statusHidup,
                items: _statusHidupOptions,
                icon: Icons.health_and_safety_rounded,
                onChanged: (value) {
                  setState(() {
                    _statusHidup = value!;
                  });
                },
              ),
              const SizedBox(height: 32),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
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
                      onPressed: _simpanData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.textOnPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: const Text('Simpan Data'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

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
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    int? maxLength,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
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
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          maxLength: maxLength,
          validator: validator,
          onChanged: onChanged,
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
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error),
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
    required String value,
    required List<String> items,
    required IconData icon,
    required void Function(String?) onChanged,
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
            onChanged: onChanged,
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
}
