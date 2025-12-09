import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class KtpFraudDetectionService {
  static const String _fraudDetectionUrl =
      'https://njajal-production-25ee.up.railway.app';
  static const String _ocrUrl = 'https://ocrktp-production.up.railway.app';

  /// Mendeteksi fraud dan melakukan OCR jika KTP valid
  /// Returns hasil deteksi + OCR dalam bentuk [KtpDetectionResult]
  Future<KtpDetectionResult> detectFraudAndOcr(File ktpImage) async {
    try {
      // Step 1: Deteksi Fraud
      final fraudResult = await _detectFraud(ktpImage);

      print('=== Fraud Detection Result ===');
      print('Label: ${fraudResult.label}');
      print('Is Valid: ${fraudResult.isValid}');
      print('Validity: ${fraudResult.validityPercentage}');
      print('==============================');

      // Step 2: Jika KTP valid, lakukan OCR
      KtpOcrResult? ocrResult;
      if (fraudResult.isValid) {
        print('KTP valid, melakukan OCR...');
        ocrResult = await _performOcr(ktpImage);
        print('=== OCR Result ===');
        print('OCR Data: ${ocrResult.data}');
        print('==================');
      } else {
        print('KTP tidak valid, melewati OCR');
      }

      return KtpDetectionResult(
        fraudResult: fraudResult,
        ocrResult: ocrResult,
        isValid: fraudResult.isValid,
      );
    } catch (e) {
      throw KtpFraudDetectionException('Terjadi kesalahan: ${e.toString()}');
    }
  }

  /// Hanya deteksi fraud (legacy method)
  Future<KtpFraudResult> detectFraud(File ktpImage) async {
    return _detectFraud(ktpImage);
  }

  /// Private method untuk deteksi fraud
  Future<KtpFraudResult> _detectFraud(File ktpImage) async {
    try {
      final uri = Uri.parse('$_fraudDetectionUrl/predict');
      final request = http.MultipartRequest('POST', uri);

      // Tambahkan file ke request dengan key 'ketuepe'
      request.files.add(
        await http.MultipartFile.fromPath('ketuepe', ktpImage.path),
      );

      // Kirim request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Debug: Print response dari API
        print('=== Fraud Detection API Response ===');
        print('Raw response: ${response.body}');
        print('Label: ${data['label']}');
        print('p_valid: ${data['p_valid']}');
        print('p_fraud: ${data['p_fraud']}');
        print('threshold: ${data['threshold']}');
        print('=====================================');

        final pValid = (data['p_valid'] as num).toDouble();
        final threshold = (data['threshold'] as num).toDouble();

        // Validasi berdasarkan probabilitas
        final isActuallyValid = pValid >= threshold;

        print(
          'Calculated isValid: $isActuallyValid (pValid: $pValid >= threshold: $threshold)',
        );

        return KtpFraudResult(
          label: data['label'] as String,
          pValid: pValid,
          pFraud: (data['p_fraud'] as num).toDouble(),
          threshold: threshold,
          isValid: isActuallyValid,
        );
      } else {
        throw KtpFraudDetectionException(
          'Server error: ${response.statusCode}',
        );
      }
    } on SocketException {
      throw KtpFraudDetectionException(
        'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.',
      );
    } on http.ClientException {
      throw KtpFraudDetectionException(
        'Gagal menghubungi server. Silakan coba lagi.',
      );
    }
  }

  /// Private method untuk melakukan OCR
  Future<KtpOcrResult> _performOcr(File ktpImage) async {
    try {
      final uri = Uri.parse('$_ocrUrl/predict');
      final request = http.MultipartRequest('POST', uri);

      // Tambahkan file ke request
      request.files.add(
        await http.MultipartFile.fromPath('file', ktpImage.path),
      );

      // Kirim request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        print('=== OCR API Response ===');
        print('Raw response: ${response.body}');
        print('========================');

        return KtpOcrResult.fromJson(data);
      } else {
        throw KtpFraudDetectionException(
          'OCR Server error: ${response.statusCode}',
        );
      }
    } on SocketException {
      throw KtpFraudDetectionException(
        'Tidak dapat terhubung ke OCR server. Periksa koneksi internet Anda.',
      );
    } on http.ClientException {
      throw KtpFraudDetectionException(
        'Gagal menghubungi OCR server. Silakan coba lagi.',
      );
    }
  }
}

/// Model untuk hasil deteksi fraud
class KtpFraudResult {
  final String label; // "VALID" atau "FRAUD"
  final double pValid; // Probabilitas valid (0-1)
  final double pFraud; // Probabilitas fraud (0-1)
  final double threshold; // Threshold yang digunakan
  final bool isValid; // true jika VALID, false jika FRAUD

  KtpFraudResult({
    required this.label,
    required this.pValid,
    required this.pFraud,
    required this.threshold,
    required this.isValid,
  });

  /// Mendapatkan persentase validitas
  String get validityPercentage => '${(pValid * 100).toStringAsFixed(1)}%';

  /// Mendapatkan persentase fraud
  String get fraudPercentage => '${(pFraud * 100).toStringAsFixed(1)}%';

  @override
  String toString() {
    return 'KtpFraudResult(label: $label, pValid: $pValid, pFraud: $pFraud)';
  }
}

/// Model untuk hasil OCR KTP
class KtpOcrResult {
  final Map<String, dynamic> data; // Data OCR lengkap dari API

  // Field-field dari OCR API response
  String? get agama => _getString('Agama') ?? _getString('agama');
  String? get alamat => _getString('Alamat') ?? _getString('alamat');
  String? get berlakuHingga =>
      _getString('Berlaku Hingga') ?? _getString('berlaku_hingga');
  String? get jenisKelamin =>
      _getString('Jenis Kelamin') ?? _getString('jenis_kelamin');
  String? get kecamatan => _getString('Kecamatan') ?? _getString('kecamatan');
  String? get kelDesa => _getString('Kel/Desa') ?? _getString('kel_desa');
  String? get kewarganegaraan =>
      _getString('Kewarganegaraan') ?? _getString('kewarganegaraan');
  String? get nik => _getString('NIK') ?? _getString('nik');
  String? get nama => _getString('Nama') ?? _getString('nama');
  String? get pekerjaan => _getString('Pekerjaan') ?? _getString('pekerjaan');
  String? get rtRw => _getString('RT/Rw') ?? _getString('rt_rw');
  String? get statusPerkawinan =>
      _getString('Status Perkawinan') ?? _getString('status_perkawinan');
  String? get tempatTglLahir =>
      _getString('Tempat/Tgl Lahir') ?? _getString('tempat_tgl_lahir');

  // Legacy field names untuk backward compatibility
  String? get tempatLahir => tempatTglLahir?.split('/').first;
  String? get tanggalLahir => tempatTglLahir?.split('/').last;
  String? get provinsi => _getString('Provinsi') ?? _getString('provinsi');
  String? get kotaKab =>
      _getString('Kota/Kab') ?? _getString('kota_kab') ?? kelDesa;
  String? get statusRumah =>
      _getString('Status Rumah') ?? _getString('status_rumah');

  KtpOcrResult({required this.data});

  /// Helper method untuk get string value dengan case-insensitive matching
  String? _getString(String key) {
    if (data.containsKey(key)) {
      final value = data[key];
      if (value is String && value.isNotEmpty && value != 'N/A' && value != '-') {
        return value;
      }
    }
    return null;
  }

  /// Create dari JSON response
  factory KtpOcrResult.fromJson(Map<String, dynamic> json) {
    return KtpOcrResult(data: json);
  }

  /// Convert ke JSON
  Map<String, dynamic> toJson() => data;

  /// Get value dari data dengan key yang lebih fleksibel
  dynamic getValue(String key) => data[key];

  /// Check apakah data kosong
  bool get isEmpty => data.isEmpty;

  /// Get semua keys yang ada di data
  List<String> get keys => data.keys.toList();

  /// Debug: print semua available fields
  void printAvailableFields() {
    print('=== Available OCR Fields ===');
    data.forEach((key, value) {
      print('$key: $value');
    });
    print('============================');
  }

  @override
  String toString() {
    return 'KtpOcrResult(NIK: $nik, Nama: $nama, Alamat: $alamat)';
  }
}

/// Model kombinasi hasil fraud detection + OCR
class KtpDetectionResult {
  final KtpFraudResult fraudResult;
  final KtpOcrResult? ocrResult; // Null jika KTP tidak valid
  final bool isValid;

  KtpDetectionResult({
    required this.fraudResult,
    required this.ocrResult,
    required this.isValid,
  });

  /// Get data OCR jika tersedia
  KtpOcrResult? getOcrData() => ocrResult;

  /// Get fraud result
  KtpFraudResult getFraudResult() => fraudResult;

  @override
  String toString() {
    return 'KtpDetectionResult(isValid: $isValid, fraudResult: $fraudResult, ocrData: ${ocrResult?.data})';
  }
}

/// Exception untuk error fraud detection
class KtpFraudDetectionException implements Exception {
  final String message;

  KtpFraudDetectionException(this.message);

  @override
  String toString() => message;
}
