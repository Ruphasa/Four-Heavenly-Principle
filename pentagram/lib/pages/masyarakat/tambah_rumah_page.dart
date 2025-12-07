import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pentagram/utils/app_colors.dart';
import 'package:pentagram/models/house.dart';
import 'package:pentagram/providers/firestore_providers.dart';

class TambahRumahPage extends ConsumerStatefulWidget {
  const TambahRumahPage({super.key});

  @override
  ConsumerState<TambahRumahPage> createState() => _TambahRumahPageState();
}

class _TambahRumahPageState extends ConsumerState<TambahRumahPage> {
  final _formKey = GlobalKey<FormState>();
  final _alamatController = TextEditingController();
  final _rtController = TextEditingController();
  final _rwController = TextEditingController();
  final _luasTanahController = TextEditingController();
  final _luasBangunanController = TextEditingController();
  final _keteranganController = TextEditingController();
  
  String? _keluargaId;
  String? _keluargaNama;
  String _statusRumah = 'Ditempati';
  String _jenisRumah = 'Permanen';
  String _statusKepemilikan = 'Milik Sendiri';

  // Removed dummy data - will use Firestore data

  final List<String> _statusRumahOptions = ['Ditempati', 'Kosong', 'Sedang Renovasi'];
  final List<String> _jenisRumahOptions = ['Permanen', 'Semi Permanen', 'Tidak Permanen'];
  final List<String> _statusKepemilikanOptions = [
    'Milik Sendiri',
    'Sewa/Kontrak',
    'Bebas Sewa',
    'Dinas',
    'Lainnya',
  ];

  @override
  void dispose() {
    _alamatController.dispose();
    _rtController.dispose();
    _rwController.dispose();
    _luasTanahController.dispose();
    _luasBangunanController.dispose();
    _keteranganController.dispose();
    super.dispose();
  }

  Future<void> _simpanData() async {
    if (_formKey.currentState!.validate()) {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        // Create House object
        final house = House(
          address: _alamatController.text.trim(),
          rt: _rtController.text.trim(),
          rw: _rwController.text.trim(),
          headName: _keluargaNama ?? 'Belum Ditentukan',
          status: _statusRumah,
          familyId: _keluargaId,
        );

        // Save to Firestore
        final repo = ref.read(houseRepositoryProvider);
        await repo.create(house);

        if (!mounted) return;
        
        // Close loading dialog
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data rumah berhasil disimpan ke database'),
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
        title: const Text('Tambah Rumah'),
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
                        'Isi data rumah dengan lengkap dan benar',
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

              // Alamat Section
              _buildSectionHeader('Alamat Rumah'),
              _buildTextField(
                controller: _alamatController,
                label: 'Alamat Lengkap',
                hint: 'Contoh: Jl. Mawar No. 12',
                icon: Icons.location_on_rounded,
                maxLines: 2,
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
                    child: _buildTextField(
                      controller: _rtController,
                      label: 'RT',
                      hint: '00',
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
                    child: _buildTextField(
                      controller: _rwController,
                      label: 'RW',
                      hint: '00',
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
              const SizedBox(height: 24),

              // Data Rumah Section
              _buildSectionHeader('Data Rumah'),
              _buildDropdownField(
                label: 'Status Rumah',
                value: _statusRumah,
                items: _statusRumahOptions,
                icon: Icons.home_work_rounded,
                onChanged: (value) {
                  setState(() {
                    _statusRumah = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildDropdownField(
                label: 'Jenis Rumah',
                value: _jenisRumah,
                items: _jenisRumahOptions,
                icon: Icons.house_rounded,
                onChanged: (value) {
                  setState(() {
                    _jenisRumah = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildDropdownField(
                label: 'Status Kepemilikan',
                value: _statusKepemilikan,
                items: _statusKepemilikanOptions,
                icon: Icons.verified_user_rounded,
                onChanged: (value) {
                  setState(() {
                    _statusKepemilikan = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _luasTanahController,
                      label: 'Luas Tanah (m²)',
                      hint: '0',
                      icon: Icons.terrain_rounded,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: _luasBangunanController,
                      label: 'Luas Bangunan (m²)',
                      hint: '0',
                      icon: Icons.apartment_rounded,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Penghuni Section
              _buildSectionHeader('Penghuni'),
              const Text(
                'Keluarga Penghuni',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Consumer(
                builder: (context, ref, child) {
                  final familiesAsync = ref.watch(familiesStreamProvider);
                  
                  return familiesAsync.when(
                    data: (families) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.cardBackground,
                        ),
                        child: DropdownButtonFormField<String>(
                          value: _keluargaId,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.family_restroom_rounded, color: AppColors.primary),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            hintText: 'Pilih Keluarga (Opsional)',
                            hintStyle: TextStyle(color: AppColors.textMuted),
                          ),
                          icon: const Icon(Icons.arrow_drop_down_rounded, color: AppColors.primary),
                          style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
                          items: [
                            const DropdownMenuItem<String>(
                              value: null,
                              child: Text('Belum Ditentukan'),
                            ),
                            ...families.map((family) {
                              return DropdownMenuItem<String>(
                                value: family.documentId,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      family.name,
                                      style: const TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      'KK: ${family.headOfFamily}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _keluargaId = value;
                              if (value != null) {
                                final selected = families.firstWhere((f) => f.documentId == value);
                                _keluargaNama = selected.headOfFamily;
                              } else {
                                _keluargaNama = null;
                              }
                            });
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
                        'Error loading keluarga: $error',
                        style: const TextStyle(color: AppColors.error),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _keteranganController,
                label: 'Keterangan',
                hint: 'Keterangan tambahan (opsional)',
                icon: Icons.note_rounded,
                maxLines: 3,
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
}
