import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pentagram/utils/app_colors.dart';
import 'package:pentagram/models/citizen.dart';
import 'package:pentagram/models/user.dart';
import 'package:pentagram/providers/firestore_providers.dart';
import 'package:pentagram/widgets/common/form_text_field.dart';
import 'package:pentagram/widgets/common/form_dropdown_field.dart';
import 'package:pentagram/widgets/common/form_date_field.dart';
import 'package:pentagram/widgets/common/form_section_header.dart';

class TambahWargaPage extends ConsumerStatefulWidget {
  const TambahWargaPage({super.key});

  @override
  ConsumerState<TambahWargaPage> createState() => _TambahWargaPageState();
}

class _TambahWargaPageState extends ConsumerState<TambahWargaPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _nikController = TextEditingController();
  final _tempatLahirController = TextEditingController();
  final _alamatController = TextEditingController();
  final _noTelpController = TextEditingController();
  final _pekerjaanController = TextEditingController();
  
  DateTime? _tanggalLahir;
  String _jenisKelamin = 'Laki-laki';
  String _statusPerkawinan = 'Belum Kawin';
  String _agama = 'Islam';
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
    _pekerjaanController.dispose();
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

  Future<void> _simpanData() async {
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

      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        // Create User first
        final userName = _namaController.text.trim();
        final user = AppUser(
          name: userName,
          email: '', // Will be set when user logs in
          status: 'Disetujui',
        );
        
        final userRepo = ref.read(userRepositoryProvider);
        final userId = await userRepo.create(user);

        // Create Citizen object with userId reference
        final citizen = Citizen(
          userId: userId,
          nik: _nikController.text.trim(),
          gender: _jenisKelamin,
          birthDate: _tanggalLahir!,
          familyRole: _hubunganKeluarga,
          maritalStatus: _statusPerkawinan,
          religion: _agama,
          education: _pendidikan,
          occupation: _pekerjaanController.text.isNotEmpty ? _pekerjaanController.text.trim() : 'Tidak Bekerja',
          status: _statusHidup,
          familyName: '-', // Will be updated when assigned to family
        );

        // Save to Firestore
        final repo = ref.read(citizenRepositoryProvider);
        await repo.create(citizen);

        if (!mounted) return;
        
        // Close loading dialog
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data warga berhasil disimpan ke database'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context, true); // Return true to indicate success
      } catch (e) {
        if (!mounted) return;
        
        // Close loading dialog
        Navigator.pop(context);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan data: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
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
              const FormSectionHeader(title: 'Data Identitas', icon: Icons.person_outline_rounded),
              const SizedBox(height: 16),
              FormTextField(
                controller: _namaController,
                label: 'Nama Lengkap',
                hintText: 'Masukkan nama lengkap',
                icon: Icons.person_rounded,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              FormTextField(
                controller: _nikController,
                label: 'NIK',
                hintText: 'Masukkan NIK 16 digit',
                icon: Icons.badge_rounded,
                keyboardType: TextInputType.number,
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
              FormDropdownField(
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
              FormTextField(
                controller: _tempatLahirController,
                label: 'Tempat Lahir',
                hintText: 'Masukkan tempat lahir',
                icon: Icons.location_city_rounded,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tempat lahir tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              FormDateField(
                label: 'Tanggal Lahir',
                value: _tanggalLahir,
                icon: Icons.cake_rounded,
                onTap: () => _pilihTanggalLahir(context),
              ),
              const SizedBox(height: 24),

              // Data Keluarga Section
              const FormSectionHeader(title: 'Data Keluarga', icon: Icons.family_restroom_rounded),
              const SizedBox(height: 16),
              FormDropdownField(
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
              FormDropdownField(
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
              const FormSectionHeader(title: 'Data Lainnya', icon: Icons.info_rounded),
              const SizedBox(height: 16),
              FormDropdownField(
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
              FormDropdownField(
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
              FormTextField(
                controller: _pekerjaanController,
                label: 'Pekerjaan',
                hintText: 'Masukkan pekerjaan',
                icon: Icons.work_rounded,
              ),
              const SizedBox(height: 16),
              FormTextField(
                controller: _alamatController,
                label: 'Alamat',
                hintText: 'Masukkan alamat lengkap',
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
              FormTextField(
                controller: _noTelpController,
                label: 'No. Telepon',
                hintText: 'Masukkan nomor telepon',
                icon: Icons.phone_rounded,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              FormDropdownField(
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
              FormDropdownField(
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
}
