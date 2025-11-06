import 'package:pentagram/models/activity_log.dart';

/// Repository for ActivityLog data access
class ActivityLogRepository {
  // Singleton pattern
  static final ActivityLogRepository _instance =
      ActivityLogRepository._internal();
  factory ActivityLogRepository() => _instance;
  ActivityLogRepository._internal();

  final List<ActivityLog> _activityLogs = [
    // Recent logs (Today - October 22, 2025)
    ActivityLog(
      no: 1,
      deskripsi: 'Menambahkan kegiatan baru: Senam Pagi Lansia',
      aktor: 'Admin Jawara',
      tanggal: DateTime(2024, 10, 22, 14, 30),
      avatar: 'AJ',
    ),
    ActivityLog(
      no: 2,
      deskripsi:
          'Mengupdate jumlah peserta Rapat Koordinasi RT dari 10 menjadi 12 orang',
      aktor: 'Bu RT',
      tanggal: DateTime(2025, 10, 22, 13, 15),
      avatar: 'BR',
    ),
    ActivityLog(
      no: 3,
      deskripsi:
          'Mengirim broadcast pengumuman jadwal Pengajian Rutin Bapak-bapak',
      aktor: 'Admin Jawara',
      tanggal: DateTime(2025, 10, 22, 11, 45),
      avatar: 'AJ',
    ),
    ActivityLog(
      no: 4,
      deskripsi:
          'Menambahkan pengguna baru: Pak Sutrisno sebagai Koordinator Kebersihan',
      aktor: 'Admin Jawara',
      tanggal: DateTime(2025, 10, 22, 10, 20),
      avatar: 'AJ',
    ),
    ActivityLog(
      no: 5,
      deskripsi: 'Memverifikasi laporan kerusakan lampu jalan RT 03',
      aktor: 'Pak Budi',
      tanggal: DateTime(2025, 10, 22, 09, 00),
      avatar: 'PB',
    ),

    // Yesterday (October 21, 2025)
    ActivityLog(
      no: 6,
      deskripsi:
          'Menambahkan kegiatan: Bimbel Gratis SD untuk tanggal 26 Oktober',
      aktor: 'Pak Joko',
      tanggal: DateTime(2025, 10, 21, 20, 30),
      avatar: 'PJ',
    ),
    ActivityLog(
      no: 7,
      deskripsi: 'Mengupdate lokasi Arisan RT menjadi Rumah Bu Rina',
      aktor: 'Bu Rina',
      tanggal: DateTime(2025, 10, 21, 18, 45),
      avatar: 'BR',
    ),
    ActivityLog(
      no: 8,
      deskripsi: 'Mengirim reminder pembayaran iuran RT bulan Oktober',
      aktor: 'Admin Jawara',
      tanggal: DateTime(2025, 10, 21, 16, 00),
      avatar: 'AJ',
    ),
    ActivityLog(
      no: 9,
      deskripsi:
          'Menambahkan transfer channel baru: Channel Informasi Kesehatan',
      aktor: 'Bu Sari',
      tanggal: DateTime(2025, 10, 21, 14, 20),
      avatar: 'BS',
    ),
    ActivityLog(
      no: 10,
      deskripsi: 'Memperbarui jadwal Posyandu dari pukul 08:00 menjadi 09:00',
      aktor: 'Bu Sari',
      tanggal: DateTime(2025, 10, 21, 11, 30),
      avatar: 'BS',
    ),

    // October 20, 2025
    ActivityLog(
      no: 11,
      deskripsi:
          'Menyelesaikan kegiatan: Senam Sehat Ibu PKK dengan 30 peserta',
      aktor: 'Bu Sari',
      tanggal: DateTime(2025, 10, 20, 19, 00),
      avatar: 'BS',
    ),
    ActivityLog(
      no: 12,
      deskripsi: 'Menghapus pesan warga duplikat di Channel Pengumuman',
      aktor: 'Admin Jawara',
      tanggal: DateTime(2025, 10, 20, 15, 45),
      avatar: 'AJ',
    ),
    ActivityLog(
      no: 13,
      deskripsi: 'Menambahkan dokumentasi foto kegiatan Gotong Royong',
      aktor: 'Pak Wahyu',
      tanggal: DateTime(2025, 10, 20, 13, 20),
      avatar: 'PW',
    ),
    ActivityLog(
      no: 14,
      deskripsi: 'Memverifikasi pembayaran kas RT dari 15 KK',
      aktor: 'Bu RT',
      tanggal: DateTime(2025, 10, 20, 10, 00),
      avatar: 'BR',
    ),
    ActivityLog(
      no: 15,
      deskripsi: 'Mengirim broadcast undangan Rapat Koordinasi RT',
      aktor: 'Admin Jawara',
      tanggal: DateTime(2025, 10, 20, 08, 30),
      avatar: 'AJ',
    ),

    // October 19, 2025
    ActivityLog(
      no: 16,
      deskripsi:
          'Menambahkan kegiatan: Vaksinasi Massal untuk tanggal 3 November',
      aktor: 'Bu Sari',
      tanggal: DateTime(2025, 10, 19, 16, 15),
      avatar: 'BS',
    ),
    ActivityLog(
      no: 17,
      deskripsi: 'Mengupdate status kegiatan Pengajian Ibu-ibu menjadi selesai',
      aktor: 'Bu Fatimah',
      tanggal: DateTime(2025, 10, 19, 14, 00),
      avatar: 'BF',
    ),
    ActivityLog(
      no: 18,
      deskripsi: 'Menambahkan pengguna baru: Ustadz Yusuf sebagai Pembina TPQ',
      aktor: 'Admin Jawara',
      tanggal: DateTime(2025, 10, 19, 11, 30),
      avatar: 'AJ',
    ),
    ActivityLog(
      no: 19,
      deskripsi: 'Meninjau laporan kerusakan jalan di RT 02',
      aktor: 'Pak Budi',
      tanggal: DateTime(2025, 10, 19, 09, 45),
      avatar: 'PB',
    ),
    ActivityLog(
      no: 20,
      deskripsi: 'Memperbarui jadwal kerja bakti RT 05',
      aktor: 'Pak Bambang',
      tanggal: DateTime(2025, 10, 19, 07, 00),
      avatar: 'PB',
    ),

    // October 18, 2025
    ActivityLog(
      no: 21,
      deskripsi: 'Mengirim pengumuman jadwal Tahlilan Malam Jumat',
      aktor: 'Pak Ahmad',
      tanggal: DateTime(2025, 10, 18, 19, 30),
      avatar: 'PA',
    ),
    ActivityLog(
      no: 22,
      deskripsi: 'Mengupdate daftar peserta Pelatihan UMKM (25 pendaftar)',
      aktor: 'Bu Endah',
      tanggal: DateTime(2025, 10, 18, 16, 00),
      avatar: 'BE',
    ),
    ActivityLog(
      no: 23,
      deskripsi: 'Menambahkan kegiatan: Donor Darah untuk tanggal 22 November',
      aktor: 'Bu Sari',
      tanggal: DateTime(2025, 10, 18, 13, 20),
      avatar: 'BS',
    ),
    ActivityLog(
      no: 24,
      deskripsi: 'Menyelesaikan kegiatan: Ronda Malam dengan 8 peserta',
      aktor: 'Pak Wahyu',
      tanggal: DateTime(2025, 10, 18, 06, 30),
      avatar: 'PW',
    ),

    // October 17, 2025
    ActivityLog(
      no: 25,
      deskripsi: 'Menambahkan channel baru: Channel Pendidikan Anak',
      aktor: 'Pak Joko',
      tanggal: DateTime(2025, 10, 17, 20, 00),
      avatar: 'PJ',
    ),
    ActivityLog(
      no: 26,
      deskripsi: 'Memverifikasi laporan penggunaan dana kas RT bulan September',
      aktor: 'Bu RT',
      tanggal: DateTime(2025, 10, 17, 17, 45),
      avatar: 'BR',
    ),
    ActivityLog(
      no: 27,
      deskripsi: 'Mengirim broadcast reminder iuran sampah bulanan',
      aktor: 'Admin Jawara',
      tanggal: DateTime(2025, 10, 17, 15, 00),
      avatar: 'AJ',
    ),
    ActivityLog(
      no: 28,
      deskripsi: 'Mengupdate kontak darurat RT (nomor Puskesmas dan Polsek)',
      aktor: 'Admin Jawara',
      tanggal: DateTime(2025, 10, 17, 12, 30),
      avatar: 'AJ',
    ),
    ActivityLog(
      no: 29,
      deskripsi: 'Menambahkan kegiatan: Cek Kesehatan Gratis Lansia',
      aktor: 'Bu Sari',
      tanggal: DateTime(2025, 10, 17, 10, 15),
      avatar: 'BS',
    ),
    ActivityLog(
      no: 30,
      deskripsi:
          'Menyelesaikan kegiatan: Pelatihan Komputer Remaja dengan 18 peserta',
      aktor: 'Pak Joko',
      tanggal: DateTime(2025, 10, 17, 08, 00),
      avatar: 'PJ',
    ),

    // October 16, 2025
    ActivityLog(
      no: 31,
      deskripsi:
          'Menambahkan pengguna baru: Bu Rina sebagai Koordinator Arisan',
      aktor: 'Admin Jawara',
      tanggal: DateTime(2025, 10, 16, 18, 20),
      avatar: 'AJ',
    ),
    ActivityLog(
      no: 32,
      deskripsi: 'Memperbarui jadwal Pertemuan Karang Taruna',
      aktor: 'Pak Wahyu',
      tanggal: DateTime(2025, 10, 16, 15, 30),
      avatar: 'PW',
    ),
    ActivityLog(
      no: 33,
      deskripsi: 'Mengirim undangan Rapat Pleno RT/RW',
      aktor: 'Bu RT',
      tanggal: DateTime(2025, 10, 16, 13, 00),
      avatar: 'BR',
    ),
    ActivityLog(
      no: 34,
      deskripsi: 'Mengupdate daftar penerima bantuan sembako',
      aktor: 'Admin Jawara',
      tanggal: DateTime(2025, 10, 16, 10, 45),
      avatar: 'AJ',
    ),
    ActivityLog(
      no: 35,
      deskripsi: 'Menambahkan kegiatan: Bersih-bersih Saluran Air',
      aktor: 'Pak Budi',
      tanggal: DateTime(2025, 10, 16, 08, 15),
      avatar: 'PB',
    ),
  ];

  /// Get all activity logs
  List<ActivityLog> findAll() {
    return List.from(_activityLogs);
  }

  /// Find logs by limit
  List<ActivityLog> findRecent({int limit = 10}) {
    return _activityLogs.take(limit).toList();
  }

  /// Find logs by actor
  List<ActivityLog> findByActor(String aktor) {
    return _activityLogs.where((log) => log.aktor == aktor).toList();
  }

  /// Find logs by date range
  List<ActivityLog> findByDateRange(DateTime start, DateTime end) {
    return _activityLogs.where((log) {
      return log.tanggal.isAfter(start.subtract(const Duration(days: 1))) &&
          log.tanggal.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  /// Create new log
  ActivityLog create(ActivityLog log) {
    final newNo = _activityLogs.isEmpty
        ? 1
        : _activityLogs.map((l) => l.no).reduce((a, b) => a > b ? a : b) + 1;

    final newLog = ActivityLog(
      no: newNo,
      deskripsi: log.deskripsi,
      aktor: log.aktor,
      tanggal: log.tanggal,
      avatar: log.avatar,
    );

    _activityLogs.insert(0, newLog); // Add to beginning
    return newLog;
  }

  /// Get total count
  int count() {
    return _activityLogs.length;
  }

  /// Clear all logs (for testing)
  void clear() {
    _activityLogs.clear();
  }
}
