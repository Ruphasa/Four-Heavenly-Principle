import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pentagram/utils/app_colors.dart';
import 'package:pentagram/models/family.dart' as models;
import 'package:pentagram/providers/firestore_providers.dart';
import 'package:pentagram/widgets/common/form_text_field.dart';
import 'package:pentagram/widgets/common/form_section_header.dart';

class TambahKeluargaPage extends ConsumerStatefulWidget {
  const TambahKeluargaPage({super.key});

  @override
  ConsumerState<TambahKeluargaPage> createState() => _TambahKeluargaPageState();
}

class _TambahKeluargaPageState extends ConsumerState<TambahKeluargaPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaKeluargaController = TextEditingController();
  final _noKKController = TextEditingController();
  final _alamatController = TextEditingController();
  final _rtController = TextEditingController();
  final _rwController = TextEditingController();
  
  String? _kepalaKeluargaId;
  String? _kepalaKeluargaNama;
  
  // Removed dummy data - will use Firestore data

  @override
  void dispose() {
    _namaKeluargaController.dispose();
    _noKKController.dispose();
    _alamatController.dispose();
    _rtController.dispose();
    _rwController.dispose();
    super.dispose();
  }

  Future<void> _simpanData() async {
    if (_formKey.currentState!.validate()) {
      if (_kepalaKeluargaId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Harap pilih kepala keluarga'),
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
        // Create Family object
        final family = models.Family(
          name: _namaKeluargaController.text.trim(),
          headOfFamily: _kepalaKeluargaNama ?? 'Unknown',
          headCitizenId: _kepalaKeluargaId,
          memberCount: 1, // Initial count, will be updated when members are added
          address: '${_alamatController.text.trim()}, RT ${_rtController.text.trim()}/RW ${_rwController.text.trim()}',
        );

        // Save to Firestore
        final repo = ref.read(familyRepositoryProvider);
        await repo.create(family);

        if (!mounted) return;
        
        // Close loading dialog
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data keluarga berhasil disimpan ke database'),
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
        title: const Text('Tambah Keluarga'),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary.withOpacity(0.1),
                      AppColors.secondary.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.info_outline_rounded,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Isi data keluarga dengan lengkap dan benar',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Data Keluarga Section
              const FormSectionHeader(title: 'Data Keluarga', icon: Icons.family_restroom_rounded),
              const SizedBox(height: 16),
              FormTextField(
                controller: _namaKeluargaController,
                label: 'Nama Keluarga',
                hintText: 'Contoh: Keluarga Ahmad Subarjo',
                icon: Icons.family_restroom_rounded,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama keluarga tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              FormTextField(
                controller: _noKKController,
                label: 'Nomor Kartu Keluarga (KK)',
                hintText: 'Masukkan nomor KK 16 digit',
                icon: Icons.credit_card_rounded,
                keyboardType: TextInputType.number,
                maxLength: 16,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor KK tidak boleh kosong';
                  }
                  if (value.length != 16) {
                    return 'Nomor KK harus 16 digit';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Kepala Keluarga',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Consumer(
                builder: (context, ref, child) {
                  final citizensAsync = ref.watch(citizensWithUserStreamProvider);
                  
                  return citizensAsync.when(
                    data: (citizensWithUser) {
                      if (citizensWithUser.isEmpty) {
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.cardBackground,
                            border: Border.all(color: AppColors.border),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Belum ada data warga. Tambahkan warga terlebih dahulu.',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        );
                      }
                      
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.cardBackground,
                        ),
                        child: DropdownButtonFormField<String>(
                          value: _kepalaKeluargaId,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person_rounded, color: AppColors.primary),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            hintText: 'Pilih Kepala Keluarga',
                            hintStyle: TextStyle(color: AppColors.textMuted),
                          ),
                          icon: const Icon(Icons.arrow_drop_down_rounded, color: AppColors.primary),
                          style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
                          items: citizensWithUser.map((cw) {
                            return DropdownMenuItem<String>(
                              value: cw.documentId,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    cw.name,
                                    style: const TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    'NIK: ${cw.nik}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _kepalaKeluargaId = value;
                              final selected = citizensWithUser.firstWhere((cw) => cw.documentId == value);
                              _kepalaKeluargaNama = selected.name;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Pilih kepala keluarga';
                            }
                            return null;
                          },
                        ),
                      );
                    },
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    error: (error, _) => Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.1),
                        border: Border.all(color: AppColors.error),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Error loading warga: $error',
                        style: const TextStyle(color: AppColors.error),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Alamat Section
              const FormSectionHeader(title: 'Alamat Keluarga', icon: Icons.home_rounded),
              const SizedBox(height: 16),
              FormTextField(
                controller: _alamatController,
                label: 'Alamat Lengkap',
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
              Row(
                children: [
                  Expanded(
                    child: FormTextField(
                      controller: _rtController,
                      label: 'RT',
                      hintText: '00',
                      icon: Icons.map_rounded,
                      keyboardType: TextInputType.number,
                      maxLength: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'RT tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FormTextField(
                      controller: _rwController,
                      label: 'RW',
                      hintText: '00',
                      icon: Icons.map_rounded,
                      keyboardType: TextInputType.number,
                      maxLength: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'RW tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
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
