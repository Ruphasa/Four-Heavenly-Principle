import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class KtpFraudDetectionService {
  static const String _baseUrl =
      'https://njajal-production-25ee.up.railway.app';

  /// Mendeteksi apakah KTP fraud atau valid
  /// Returns hasil deteksi dalam bentuk [KtpFraudResult]
  Future<KtpFraudResult> detectFraud(File ktpImage) async {
    try {
      final uri = Uri.parse('$_baseUrl/predict');
      final request = http.MultipartRequest('POST', uri);

      // Tambahkan file ke request dengan key 'ketuepe'
      request.files.add(
        await http.MultipartFile.fromPath(
          'ketuepe',
          ktpImage.path,
        ),
      );

      // Kirim request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Debug: Print response dari API
        print('=== API Response ===');
        print('Raw response: ${response.body}');
        print('Label: ${data['label']}');
        print('p_valid: ${data['p_valid']}');
        print('p_fraud: ${data['p_fraud']}');
        print('threshold: ${data['threshold']}');
        print('==================');

        final pValid = (data['p_valid'] as num).toDouble();
        final threshold = (data['threshold'] as num).toDouble();
        
        // Validasi berdasarkan probabilitas, bukan hanya label dari API
        // Karena kadang API memberikan label yang tidak konsisten
        final isActuallyValid = pValid >= threshold;
        
        print('Calculated isValid: $isActuallyValid (pValid: $pValid >= threshold: $threshold)');

        return KtpFraudResult(
          label: data['label'] as String,
          pValid: pValid,
          pFraud: (data['p_fraud'] as num).toDouble(),
          threshold: threshold,
          isValid: isActuallyValid, // Gunakan validasi manual
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
    } catch (e) {
      throw KtpFraudDetectionException(
        'Terjadi kesalahan: ${e.toString()}',
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

/// Exception untuk error fraud detection
class KtpFraudDetectionException implements Exception {
  final String message;

  KtpFraudDetectionException(this.message);

  @override
  String toString() => message;
}
