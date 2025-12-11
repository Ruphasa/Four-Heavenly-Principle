import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pentagram/pages/login/login_page.dart';
import 'package:pentagram/providers/firestore_providers.dart';
import 'package:pentagram/providers/app_providers.dart';
import 'package:pentagram/utils/app_colors.dart';
import 'package:pentagram/widgets/profil/ktp_verification_section.dart';

class RegisterForm extends ConsumerStatefulWidget {
  const RegisterForm({super.key});

  @override
  ConsumerState<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _nikController = TextEditingController();
  final _emailController = TextEditingController();
  final _telpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _alamatController = TextEditingController();
  final _tempatLahirController = TextEditingController();
  final _tanggalLahirController = TextEditingController();

  String? _jenisKelamin;
  String? _rumah;
  String? _statusRumah;
  bool _isHoveringButton = false;
  bool _isHoveringLogin = false;

  final List<String> _listJenisKelamin = ['Laki-laki', 'Perempuan'];
  // Rumah options will be populated from Firestore houses stream
  List<String> _listRumah = const [];
  final List<String> _listStatusRumah = ['Pemilik', 'Penyewa'];

  @override
  void initState() {
    super.initState();
    // Listener must be placed in build; nothing to init here for now
  }

  @override
  Widget build(BuildContext context) {
    // Show registration errors as snackbars
    ref.listen(registerControllerProvider, (prev, next) {
      final msg = next.error;
      if (msg != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
        );
      }
    });

    // Listen to KTP validation changes for auto-fill
    ref.listen(ktpValidationProvider, (prev, next) {
      if (next.isValid && next.isValidated) {
        // Auto-fill form fields from OCR data
        if (next.ocrNik != null) _nikController.text = next.ocrNik!;
        if (next.ocrNama != null) _namaController.text = next.ocrNama!;
        if (next.ocrAlamat != null) _alamatController.text = next.ocrAlamat!;
        if (next.ocrTempatLahir != null)
          _tempatLahirController.text = next.ocrTempatLahir!;
        if (next.ocrTanggalLahir != null)
          _tanggalLahirController.text = next.ocrTanggalLahir!;

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Data KTP berhasil diisi otomatis!'),
              backgroundColor: AppColors.success,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    });

    return Container(
      constraints: const BoxConstraints(maxWidth: 600),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShaderMask(
              shaderCallback: (bounds) =>
                  AppColors.primaryGradient.createShader(bounds),
              child: const Text(
                'Buat Akun Baru',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Lengkapi formulir di bawah ini untuk mendaftar.',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            const Divider(color: AppColors.divider, thickness: 1),
            const SizedBox(height: 16),

            // KTP Scanning Section
            const Text(
              'Scan KTP Anda',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Scan KTP untuk mengisi data secara otomatis',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            const KtpVerificationSection(),
            const SizedBox(height: 20),
            const Divider(color: AppColors.divider, thickness: 1),
            const SizedBox(height: 20),

            _buildTextField('Nama Lengkap', _namaController),
            _buildTextField('NIK', _nikController),
            _buildTextField('Tempat Lahir', _tempatLahirController),
            _buildTextField(
              'Tanggal Lahir',
              _tanggalLahirController,
              hint: 'DD-MM-YYYY',
            ),
            _buildTextField('Email', _emailController),
            _buildTextField(
              'No Telepon',
              _telpController,
              hint: '08xxxxxxxxxx',
            ),
            _buildTextField('Password', _passwordController, obscure: true),
            _buildTextField(
              'Konfirmasi Password',
              _confirmPasswordController,
              obscure: true,
            ),
            _buildDropdown(
              label: 'Jenis Kelamin',
              hint: '-- Pilih Jenis Kelamin --',
              value: _jenisKelamin,
              items: _listJenisKelamin,
              onChanged: (v) => setState(() => _jenisKelamin = v),
            ),
            Consumer(
              builder: (context, ref, _) {
                final housesAsync = ref.watch(housesStreamProvider);
                return housesAsync.when(
                  data: (houses) {
                    _listRumah = houses.map((h) => h.address).toList();
                    return _buildDropdown(
                      label: 'Pilih Rumah yang Sudah Ada',
                      hint: '-- Pilih Rumah --',
                      value: _rumah,
                      items: _listRumah,
                      onChanged: (v) {
                        setState(() {
                          _rumah = v;
                          if (v != null && v.isNotEmpty)
                            _alamatController.clear();
                        });
                      },
                    );
                  },
                  loading: () => const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: LinearProgressIndicator(),
                  ),
                  error: (e, _) => _buildDropdown(
                    label: 'Pilih Rumah yang Sudah Ada',
                    hint: '-- Pilih Rumah --',
                    value: _rumah,
                    items: _listRumah,
                    onChanged: (v) {
                      setState(() {
                        _rumah = v;
                        if (v != null && v.isNotEmpty)
                          _alamatController.clear();
                      });
                    },
                  ),
                );
              },
            ),
            const Text(
              'Kalau tidak ada di daftar, isi alamat rumah di bawah ini',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 6),
            _buildTextField(
              'Alamat Rumah (Jika Tidak Ada di List)',
              _alamatController,
              onChanged: (v) {
                if (v.isNotEmpty) setState(() => _rumah = null);
              },
            ),
            _buildDropdown(
              label: 'Status Kepemilikan Rumah',
              hint: '-- Pilih Status --',
              value: _statusRumah,
              items: _listStatusRumah,
              onChanged: (v) => setState(() => _statusRumah = v),
            ),
            const SizedBox(height: 32),
            Consumer(
              builder: (context, ref, _) {
                final ktpValidation = ref.watch(ktpValidationProvider);
                final isKtpValid =
                    ktpValidation.isValid && ktpValidation.isValidated;

                return Column(
                  children: [
                    // Warning jika KTP belum valid
                    if (!isKtpValid) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.error.withValues(alpha: 0.3),
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
                            const Expanded(
                              child: Text(
                                'Silakan scan KTP Anda terlebih dahulu untuk melanjutkan pendaftaran',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    _buildRegisterButton(canRegister: isKtpValid),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            _buildLoginLink(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool obscure = false,
    String? hint,
    Function(String)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
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
          TextField(
            controller: controller,
            obscureText: obscure,
            onChanged: onChanged,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: hint ?? 'Masukkan $label di sini',
              hintStyle: const TextStyle(color: AppColors.textMuted),
              filled: true,
              fillColor: AppColors.backgroundGrey,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String hint,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
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
          DropdownButtonFormField<String>(
            initialValue: value,
            isExpanded: true,
            hint: Text(
              hint,
              style: const TextStyle(color: AppColors.textMuted),
            ),
            items: items
                .map((e) => DropdownMenuItem<String>(value: e, child: Text(e)))
                .toList(),
            onChanged: onChanged,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.backgroundGrey,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            iconEnabledColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterButton({required bool canRegister}) {
    final loading = ref.watch(registerControllerProvider).loading;
    final isEnabled = canRegister && !loading;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHoveringButton = true),
      onExit: (_) => setState(() => _isHoveringButton = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.diagonal3Values(
          _isHoveringButton && isEnabled ? 1.02 : 1.0,
          _isHoveringButton && isEnabled ? 1.02 : 1.0,
          1.0,
        ),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: isEnabled ? AppColors.primaryGradient : null,
            color: isEnabled ? null : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
            boxShadow: _isHoveringButton && isEnabled
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: ElevatedButton(
            onPressed: isEnabled
                ? () async {
                    // Validate form
                    if (!_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Mohon lengkapi semua field yang diperlukan'),
                          backgroundColor: AppColors.error,
                        ),
                      );
                      return;
                    }
                    
                    // Validate required fields
                    if (_namaController.text.trim().isEmpty ||
                        _nikController.text.trim().isEmpty ||
                        _emailController.text.trim().isEmpty ||
                        _telpController.text.trim().isEmpty ||
                        _passwordController.text.trim().isEmpty ||
                        _tempatLahirController.text.trim().isEmpty ||
                        _tanggalLahirController.text.trim().isEmpty ||
                        _jenisKelamin == null ||
                        _statusRumah == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Mohon lengkapi semua field yang diperlukan'),
                          backgroundColor: AppColors.error,
                        ),
                      );
                      return;
                    }
                    
                    // Validate house selection
                    if ((_rumah == null || _rumah!.isEmpty) &&
                        _alamatController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Pilih rumah yang ada atau isi alamat rumah baru'),
                          backgroundColor: AppColors.error,
                        ),
                      );
                      return;
                    }
                    
                    // Validate password confirmation
                    if (_passwordController.text != _confirmPasswordController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Password dan konfirmasi password tidak sama'),
                          backgroundColor: AppColors.error,
                        ),
                      );
                      return;
                    }
                    
                    // Trigger register action
                    await ref.read(registerControllerProvider.notifier).register(
                      email: _emailController.text.trim(),
                      password: _passwordController.text.trim(),
                      name: _namaController.text.trim(),
                      nik: _nikController.text.trim(),
                      phone: _telpController.text.trim(),
                      birthPlace: _tempatLahirController.text.trim(),
                      birthDate: _tanggalLahirController.text.trim(),
                      gender: _jenisKelamin!,
                      address: _alamatController.text.trim().isNotEmpty
                          ? _alamatController.text.trim()
                          : _rumah!,
                      selectedHouseAddress: _rumah,
                      ownershipStatus: _statusRumah!,
                    );
                    
                    // Check if registration was successful
                    final state = ref.read(registerControllerProvider);
                    if (!mounted) return;
                    
                    if (state.success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Akun berhasil dibuat! Silakan tunggu persetujuan admin.'),
                          backgroundColor: AppColors.success,
                          duration: Duration(seconds: 3),
                        ),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    } else if (state.error != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.error!),
                          backgroundColor: AppColors.error,
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    }
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: loading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                : Text(
                    canRegister ? 'Buat Akun' : 'Scan KTP Terlebih Dahulu',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: canRegister
                          ? AppColors.textOnPrimary
                          : Colors.grey.shade600,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Sudah punya akun? ',
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        MouseRegion(
          onEnter: (_) => setState(() => _isHoveringLogin = true),
          onExit: (_) => setState(() => _isHoveringLogin = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            child: ShaderMask(
              shaderCallback: (bounds) =>
                  AppColors.primaryGradient.createShader(bounds),
              child: Text(
                'Masuk',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  decoration: _isHoveringLogin
                      ? TextDecoration.underline
                      : TextDecoration.none,
                  decorationColor: AppColors.primary,
                  decorationThickness: 2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
