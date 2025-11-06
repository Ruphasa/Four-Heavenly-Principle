import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pentagram/pages/login/login_page.dart';
import 'package:pentagram/providers/app_providers.dart';
import 'package:pentagram/utils/app_colors.dart';

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

  String? _jenisKelamin;
  String? _rumah;
  String? _statusRumah;
  bool _isHoveringButton = false;
  bool _isHoveringLogin = false;

  final List<String> _listJenisKelamin = ['Laki-laki', 'Perempuan'];
  final List<String> _listRumah = [
    'i',
    'Quis',
    'Fasda',
    'wer wer',
    'Jl. Merbabu',
  ];
  final List<String> _listStatusRumah = ['Pemilik', 'Penyewa'];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.listen(registerControllerProvider, (prev, next) {
        final msg = next.error;
        if (msg != null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
            _buildTextField('Nama Lengkap', _namaController),
            _buildTextField('NIK', _nikController),
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
            _buildDropdown(
              label: 'Pilih Rumah yang Sudah Ada',
              hint: '-- Pilih Rumah --',
              value: _rumah,
              items: _listRumah,
              onChanged: (v) {
                setState(() {
                  _rumah = v;
                  if (v != null && v.isNotEmpty) _alamatController.clear();
                });
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
            const SizedBox(height: 16),
            _buildUploadField(
              label: 'Foto Identias',
            ),
            const SizedBox(height: 32),
            _buildRegisterButton(),
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
              .map((e) => DropdownMenuItem<String>(
                    value: e,
                    child: Text(e),
                  ))
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


  Widget _buildUploadField({required String label}) {
    return Container(
      height: 80,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.backgroundGrey,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12, width: 1.5),
      ),
      child: const Text(
        'Upload foto KK/KTP (.png/.jpg)',
        style: TextStyle(color: AppColors.textMuted),
      ),
    );
  }

  Widget _buildRegisterButton() {
    final loading = ref.watch(registerControllerProvider).loading;
    return MouseRegion(
      onEnter: (_) => setState(() => _isHoveringButton = true),
      onExit: (_) => setState(() => _isHoveringButton = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.diagonal3Values(
          _isHoveringButton ? 1.02 : 1.0,
          _isHoveringButton ? 1.02 : 1.0,
          1.0,
        ),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(12),
            boxShadow: _isHoveringButton
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
            onPressed: loading
                ? null
                : () async {
                    // Trigger register action
                    await ref
                        .read(registerControllerProvider.notifier)
                        .refresh();
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Akun berhasil dibuat'),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
                  },
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
                : const Text(
                    'Buat Akun',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textOnPrimary,
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
