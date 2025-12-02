import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pentagram/utils/app_colors.dart';
import 'package:pentagram/widgets/profil/ktp_verification_section.dart';
import 'package:pentagram/widgets/profil/profile_picture_widget.dart';
import 'package:pentagram/widgets/profil/profile_text_field.dart';

// Import provider dari ktp_verification_section
export 'package:pentagram/widgets/profil/ktp_verification_section.dart' show ktpValidationProvider;

class EditProfilPage extends ConsumerStatefulWidget {
  const EditProfilPage({super.key});

  @override
  ConsumerState<EditProfilPage> createState() => _EditProfilPageState();
}

class _EditProfilPageState extends ConsumerState<EditProfilPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController(text: 'Nyi Roro Lor');
  final _emailController = TextEditingController(text: 'nyirorolor@gmail.com');
  final _teleponController = TextEditingController(text: '081234567890');
  final _alamatController = TextEditingController(
    text: 'Jl. Raya Desa No. 123, RT 01/RW 02',
  );

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _teleponController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement save profile logic
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profil berhasil diperbarui!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: AppBar(
        title: const Text(
          'Edit Profil',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.gradientStart,
                AppColors.gradientMiddle,
                AppColors.gradientEnd,
              ],
            ),
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Picture Section
                Center(
                  child: ProfilePictureWidget(
                    imagePath: 'assets/images/profile.png',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Fitur ubah foto profil akan segera hadir!',
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 32),

                // Personal Info Section
                _buildSectionTitle('Informasi Pribadi'),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      ProfileTextField(
                        controller: _namaController,
                        label: 'Nama Lengkap',
                        icon: Icons.person_outline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nama tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      ProfileTextField(
                        controller: _emailController,
                        label: 'Email',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email tidak boleh kosong';
                          }
                          if (!RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          ).hasMatch(value)) {
                            return 'Format email tidak valid';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      ProfileTextField(
                        controller: _teleponController,
                        label: 'Nomor Telepon',
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nomor telepon tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      ProfileTextField(
                        controller: _alamatController,
                        label: 'Alamat',
                        icon: Icons.location_on_outlined,
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Alamat tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // KTP Verification Section
                _buildSectionTitle('Verifikasi Identitas'),
                const SizedBox(height: 12),
                const KtpVerificationSection(),

                const SizedBox(height: 32),

                // Save Button
                Consumer(
                  builder: (context, ref, child) {
                    final ktpValidation = ref.watch(ktpValidationProvider);
                    final hasKtpImage = ktpValidation.ktpImage != null;
                    final isKtpValid = ktpValidation.isValid;
                    final isKtpValidated = ktpValidation.isValidated;

                    // Button hanya bisa diklik jika:
                    // 1. Tidak ada KTP (belum upload), atau
                    // 2. Ada KTP dan sudah divalidasi dan hasilnya VALID
                    final canSave = !hasKtpImage || (isKtpValidated && isKtpValid);

                    return Column(
                      children: [
                        // Peringatan jika KTP fraud atau belum divalidasi
                        if (hasKtpImage && (!isKtpValidated || !isKtpValid)) ...[
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.error.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.error.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.warning_amber_rounded,
                                  color: AppColors.error,
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    !isKtpValidated
                                        ? 'KTP belum divalidasi. Silakan upload ulang foto KTP.'
                                        : 'KTP terdeteksi fraud. Anda tidak dapat menyimpan perubahan sampai KTP valid.',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textPrimary,
                                      height: 1.4,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: canSave ? _saveProfile : null,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                              disabledBackgroundColor: Colors.grey.shade300,
                              disabledForegroundColor: Colors.grey.shade600,
                            ).copyWith(
                              backgroundColor: MaterialStateProperty.resolveWith(
                                (states) {
                                  if (states.contains(MaterialState.disabled)) {
                                    return Colors.grey.shade300;
                                  }
                                  if (states.contains(MaterialState.pressed)) {
                                    return AppColors.primaryDark;
                                  }
                                  return AppColors.primary;
                                },
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (canSave && hasKtpImage && isKtpValid) ...[
                                  const Icon(
                                    Icons.check_circle,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 8),
                                ],
                                Text(
                                  canSave
                                      ? 'Simpan Perubahan'
                                      : 'Validasi KTP Diperlukan',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }
}
