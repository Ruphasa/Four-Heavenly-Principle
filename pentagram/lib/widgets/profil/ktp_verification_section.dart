import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pentagram/utils/app_colors.dart';
import 'package:pentagram/pages/profil/ktp_camera_page.dart';
import 'package:pentagram/widgets/profil/permission_dialog.dart';
import 'package:pentagram/widgets/profil/image_source_bottom_sheet.dart';
import 'package:pentagram/widgets/profil/delete_ktp_dialog.dart';
import 'package:pentagram/widgets/profil/ktp_image_preview.dart';
import 'package:pentagram/services/ktp_fraud_detection_service.dart';

// Provider untuk status validasi KTP - bisa diakses dari edit_profil_page
final ktpValidationProvider = StateProvider<KtpValidationState>((ref) {
  return KtpValidationState();
});

class KtpValidationState {
  final File? ktpImage;
  final bool isValid;
  final bool isValidated;
  final KtpFraudResult? fraudResult;

  // OCR Results
  final String? ocrNik;
  final String? ocrNama;
  final String? ocrAlamat;
  final String? ocrTempatLahir;
  final String? ocrTanggalLahir;

  KtpValidationState({
    this.ktpImage,
    this.isValid = false,
    this.isValidated = false,
    this.fraudResult,
    this.ocrNik,
    this.ocrNama,
    this.ocrAlamat,
    this.ocrTempatLahir,
    this.ocrTanggalLahir,
  });

  KtpValidationState copyWith({
    File? ktpImage,
    bool? isValid,
    bool? isValidated,
    KtpFraudResult? fraudResult,
    String? ocrNik,
    String? ocrNama,
    String? ocrAlamat,
    String? ocrTempatLahir,
    String? ocrTanggalLahir,
  }) {
    return KtpValidationState(
      ktpImage: ktpImage ?? this.ktpImage,
      isValid: isValid ?? this.isValid,
      isValidated: isValidated ?? this.isValidated,
      fraudResult: fraudResult ?? this.fraudResult,
      ocrNik: ocrNik ?? this.ocrNik,
      ocrNama: ocrNama ?? this.ocrNama,
      ocrAlamat: ocrAlamat ?? this.ocrAlamat,
      ocrTempatLahir: ocrTempatLahir ?? this.ocrTempatLahir,
      ocrTanggalLahir: ocrTanggalLahir ?? this.ocrTanggalLahir,
    );
  }
}

class KtpVerificationSection extends ConsumerStatefulWidget {
  const KtpVerificationSection({super.key});

  @override
  ConsumerState<KtpVerificationSection> createState() =>
      _KtpVerificationSectionState();
}

class _KtpVerificationSectionState
    extends ConsumerState<KtpVerificationSection> {
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();
  final KtpFraudDetectionService _fraudService = KtpFraudDetectionService();

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();

    if (status.isDenied) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Izin kamera diperlukan untuk memindai KTP'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } else if (status.isPermanentlyDenied) {
      if (mounted) {
        _showPermissionDialog();
      }
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => const PermissionDialog(),
    );
  }

  Future<void> _captureKtp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Check camera permission first
      final cameraStatus = await Permission.camera.status;

      if (cameraStatus.isDenied || cameraStatus.isPermanentlyDenied) {
        await _requestCameraPermission();
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Navigate to custom camera page
      if (mounted) {
        final File? capturedImage = await Navigator.push<File>(
          context,
          MaterialPageRoute(builder: (context) => const KtpCameraPage()),
        );

        if (capturedImage != null) {
          // Validasi fraud detection setelah foto diambil dari kamera
          await _validateKtpImage(capturedImage);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengambil foto: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickFromGallery() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        // Validasi fraud detection setelah foto dipilih dari galeri
        await _validateKtpImage(File(image.path));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memilih foto: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Validasi KTP dengan fraud detection API
  Future<void> _validateKtpImage(File imageFile) async {
    // Tampilkan loading dialog
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(
                  'Memvalidasi KTP...',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8),
                Text(
                  'Mohon tunggu sebentar',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      // Panggil API fraud detection
      final result = await _fraudService.detectFraud(imageFile);

      if (!mounted) return;

      // Tutup loading dialog
      Navigator.pop(context);

      if (result.isValid) {
        // KTP VALID - lakukan OCR untuk mendapatkan data
        // Tampilkan loading OCR
        if (!mounted) return;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Membaca data KTP...',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Mohon tunggu sebentar',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        try {
          // Panggil OCR API dengan detectFraudAndOcr
          final detectionResult = await _fraudService.detectFraudAndOcr(
            imageFile,
          );

          if (!mounted) return;

          // Tutup loading OCR dialog
          Navigator.pop(context);

          if (detectionResult.isValid && detectionResult.ocrResult != null) {
            // OCR berhasil - simpan data ke provider
            final ocrData = detectionResult.ocrResult!;

            // Debug: print available fields
            ocrData.printAvailableFields();

            ref.read(ktpValidationProvider.notifier).state = KtpValidationState(
              ktpImage: imageFile,
              isValid: true,
              isValidated: true,
              fraudResult: result,
              // Ambil data dari OCR dengan fallback
              ocrNik: ocrData.nik ?? 'Tidak terbaca',
              ocrNama: ocrData.nama ?? 'Tidak terbaca',
              ocrAlamat: ocrData.alamat ?? 'Tidak terbaca',
              ocrTempatLahir: ocrData.tempatLahir ?? 'Tidak terbaca',
              ocrTanggalLahir: ocrData.tanggalLahir ?? 'Tidak terbaca',
            );

            // Tampilkan pesan sukses dengan data yang dibaca
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.white),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'KTP Valid & Data Berhasil Dibaca!',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Nama: ${ocrData.nama ?? 'N/A'}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            Text(
                              'NIK: ${ocrData.nik ?? 'N/A'}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: AppColors.success,
                  duration: const Duration(seconds: 3),
                ),
              );
            }
          } else {
            // OCR gagal, tapi KTP valid - gunakan mock data
            ref.read(ktpValidationProvider.notifier).state = KtpValidationState(
              ktpImage: imageFile,
              isValid: true,
              isValidated: true,
              fraudResult: result,
              // Mock OCR data jika API gagal
              ocrNik: '3201234567890123',
              ocrNama: 'SILAKAN LENGKAPI DATA',
              ocrAlamat: 'JL. CONTOH NO. 123 RT 01 RW 02',
              ocrTempatLahir: 'JAKARTA',
              ocrTanggalLahir: '01-01-1990',
            );

            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'KTP Valid!',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'OCR tidak tersedia, silakan lengkapi data manual',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: AppColors.primary,
                  duration: const Duration(seconds: 3),
                ),
              );
            }
          }
        } catch (e) {
          if (!mounted) return;

          // Tutup loading OCR dialog
          Navigator.pop(context);

          // OCR error - tapi KTP tetap valid
          ref.read(ktpValidationProvider.notifier).state = KtpValidationState(
            ktpImage: imageFile,
            isValid: true,
            isValidated: true,
            fraudResult: result,
            // Mock OCR data
            ocrNik: '3201234567890123',
            ocrNama: 'SILAKAN LENGKAPI DATA',
            ocrAlamat: 'JL. CONTOH NO. 123 RT 01 RW 02',
            ocrTempatLahir: 'JAKARTA',
            ocrTanggalLahir: '01-01-1990',
          );

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('KTP Valid! Silakan lengkapi data secara manual'),
                backgroundColor: AppColors.primary,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        }
      } else {
        // KTP FRAUD - tampilkan dialog error
        _showFraudDialog(result, imageFile);
      }
    } on KtpFraudDetectionException catch (e) {
      if (!mounted) return;

      // Tutup loading dialog
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error validasi: ${e.message}'),
          backgroundColor: AppColors.error,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  void _showFraudDialog(KtpFraudResult result, File imageFile) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 28),
            const SizedBox(width: 12),
            const Text(
              'KTP Tidak Valid',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Foto KTP yang Anda pilih terdeteksi sebagai fraud atau tidak memenuhi standar validasi.',
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.error.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tingkat Fraud: ${result.fraudPercentage}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tingkat Valid: ${result.validityPercentage}',
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Silakan pilih foto lain dengan memastikan:',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 8),
            _buildTip('KTP asli, bukan fotokopi'),
            _buildTip('Pencahayaan yang cukup'),
            _buildTip('Tidak ada pantulan atau blur'),
            _buildTip('KTP tidak tertutup atau terpotong'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
            },
            child: const Text(
              'Tutup',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              _showImageSourceDialog(); // Pilih foto lagi
            },
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Pilih Ulang'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTip(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 13)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ImageSourceBottomSheet(
        onCameraPressed: _captureKtp,
        onGalleryPressed: _pickFromGallery,
      ),
    );
  }

  void _deleteKtpImage() {
    showDialog(
      context: context,
      builder: (context) => DeleteKtpDialog(
        onConfirmDelete: () {
          // Reset validasi KTP
          ref.read(ktpValidationProvider.notifier).state = KtpValidationState();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Foto KTP berhasil dihapus'),
              duration: Duration(seconds: 2),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ktpValidation = ref.watch(ktpValidationProvider);
    final ktpImage = ktpValidation.ktpImage;
    final isValid = ktpValidation.isValid;
    final isValidated = ktpValidation.isValidated;

    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.credit_card,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Verifikasi KTP',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        letterSpacing: 0.3,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Upload foto KTP untuk verifikasi',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // KTP Preview or Placeholder
          KtpImagePreview(ktpImage: ktpImage),

          // Status validasi
          if (isValidated && ktpImage != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isValid
                    ? AppColors.success.withOpacity(0.1)
                    : AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isValid
                      ? AppColors.success.withOpacity(0.3)
                      : AppColors.error.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isValid ? Icons.check_circle : Icons.cancel,
                    color: isValid ? AppColors.success : AppColors.error,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      isValid
                          ? 'KTP tervalidasi sebagai asli (${ktpValidation.fraudResult?.validityPercentage})'
                          : 'KTP terdeteksi fraud',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary.withOpacity(0.9),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 16),

          // Action Buttons
          if (ktpImage == null)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _showImageSourceDialog,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Icon(Icons.add_a_photo),
                label: Text(
                  _isLoading ? 'Memproses...' : 'Ambil Foto KTP',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            )
          else
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _showImageSourceDialog,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Ganti Foto'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _deleteKtpImage,
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Hapus'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: AppColors.error),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),

          const SizedBox(height: 12),

          // Info Text
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.info.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.info.withOpacity(0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline, color: AppColors.info, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Pastikan foto KTP jelas dan tidak buram. Data akan digunakan untuk verifikasi identitas.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textPrimary.withOpacity(0.8),
                      height: 1.5,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
