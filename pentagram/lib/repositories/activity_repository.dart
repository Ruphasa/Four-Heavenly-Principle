import 'package:pentagram/models/activity.dart';

/// Repository for Activity data access
/// This layer handles data operations (CRUD)
class ActivityRepository {
  // Singleton pattern
  static final ActivityRepository _instance = ActivityRepository._internal();
  factory ActivityRepository() => _instance;
  ActivityRepository._internal();

  // Mock data storage (replace with actual database/API later)
  final List<Activity> _activities = [
    // Past Activities (October 2025)
    Activity(
      id: 1,
      nama: 'Gotong Royong Kampung',
      kategori: 'Kebersihan & Keamanan',
      penanggungJawab: 'Pak Budi',
      tanggal: DateTime(2025, 10, 5),
      waktu: '08:00',
      deskripsi: 'Kegiatan gotong royong membersihkan lingkungan kampung, termasuk saluran air dan jalan kampung',
      lokasi: 'RT 01/RW 02',
      peserta: 25,
    ),
    Activity(
      id: 2,
      nama: 'Pengajian Ibu-ibu',
      kategori: 'Keagamaan',
      penanggungJawab: 'Bu Fatimah',
      tanggal: DateTime(2025, 10, 8),
      waktu: '14:00',
      deskripsi: 'Pengajian rutin mingguan untuk ibu-ibu dengan kajian kitab dan tahlilan',
      lokasi: 'Masjid Al-Ikhlas',
      peserta: 35,
    ),
    Activity(
      id: 3,
      nama: 'Posyandu Balita',
      kategori: 'Kesehatan & Olahraga',
      penanggungJawab: 'Bu Sari',
      tanggal: DateTime(2025, 10, 10),
      waktu: '09:00',
      deskripsi: 'Pemeriksaan kesehatan dan pemberian imunisasi untuk balita',
      lokasi: 'Balai RW',
      peserta: 42,
    ),
    Activity(
      id: 4,
      nama: 'Ronda Malam',
      kategori: 'Kebersihan & Keamanan',
      penanggungJawab: 'Pak Wahyu',
      tanggal: DateTime(2025, 10, 12),
      waktu: '22:00',
      deskripsi: 'Patroli keamanan lingkungan pada malam hari',
      lokasi: 'Keliling RT 01-05',
      peserta: 8,
    ),
    Activity(
      id: 5,
      nama: 'Pelatihan Komputer Remaja',
      kategori: 'Pendidikan',
      penanggungJawab: 'Pak Joko',
      tanggal: DateTime(2025, 10, 15),
      waktu: '15:00',
      deskripsi: 'Pelatihan dasar komputer dan Microsoft Office untuk remaja',
      lokasi: 'Rumah Pak Joko',
      peserta: 18,
    ),

    // Today's Activities (October 23, 2025)
    Activity(
      id: 6,
      nama: 'Senam Pagi Lansia',
      kategori: 'Kesehatan & Olahraga',
      penanggungJawab: 'Bu Endah',
      tanggal: DateTime(2025, 10, 23),
      waktu: '06:30',
      deskripsi: 'Senam pagi khusus untuk lansia dengan gerakan ringan dan terukur',
      lokasi: 'Lapangan RT',
      peserta: 22,
    ),
    Activity(
      id: 7,
      nama: 'Rapat Koordinasi RT',
      kategori: 'Komunitas & Sosial',
      penanggungJawab: 'Bu RT',
      tanggal: DateTime(2025, 10, 23),
      waktu: '19:30',
      deskripsi: 'Rapat koordinasi pengurus RT membahas program bulan depan',
      lokasi: 'Balai RT',
      peserta: 12,
    ),

    // Upcoming Activities (Late October - November 2025)
    Activity(
      id: 8,
      nama: 'Pengajian Rutin Bapak-bapak',
      kategori: 'Keagamaan',
      penanggungJawab: 'Pak Ahmad',
      tanggal: DateTime(2025, 10, 23),
      waktu: '19:30',
      deskripsi: 'Pengajian rutin mingguan untuk bapak-bapak dengan kajian fiqih',
      lokasi: 'Masjid Al-Ikhlas',
      peserta: 40,
    ),
    Activity(
      id: 9,
      nama: 'Senam Sehat Ibu PKK',
      kategori: 'Kesehatan & Olahraga',
      penanggungJawab: 'Bu Sari',
      tanggal: DateTime(2025, 10, 25),
      waktu: '06:30',
      deskripsi: 'Senam aerobik untuk ibu-ibu PKK',
      lokasi: 'Balai Desa',
      peserta: 30,
    ),
    Activity(
      id: 10,
      nama: 'Bimbel Gratis SD',
      kategori: 'Pendidikan',
      penanggungJawab: 'Pak Joko',
      tanggal: DateTime(2025, 10, 26),
      waktu: '15:00',
      deskripsi: 'Bimbingan belajar gratis untuk anak SD kelas 4-6',
      lokasi: 'Rumah Pak Joko',
      peserta: 15,
    ),
    Activity(
      id: 11,
      nama: 'Lomba 17 Agustus (Persiapan)',
      kategori: 'Komunitas & Sosial',
      penanggungJawab: 'Pak Bambang',
      tanggal: DateTime(2025, 10, 28),
      waktu: '16:00',
      deskripsi: 'Rapat persiapan lomba 17 Agustus tahun depan dan koordinasi kepanitiaan',
      lokasi: 'Balai RT',
      peserta: 20,
    ),
    Activity(
      id: 12,
      nama: 'Kerja Bakti Masjid',
      kategori: 'Kebersihan & Keamanan',
      penanggungJawab: 'Pak Sutrisno',
      tanggal: DateTime(2025, 10, 30),
      waktu: '08:00',
      deskripsi: 'Kerja bakti membersihkan masjid dan halaman masjid',
      lokasi: 'Masjid Al-Ikhlas',
      peserta: 28,
    ),
    Activity(
      id: 13,
      nama: 'Arisan RT',
      kategori: 'Komunitas & Sosial',
      penanggungJawab: 'Bu Rina',
      tanggal: DateTime(2025, 11, 1),
      waktu: '19:00',
      deskripsi: 'Arisan bulanan RT dengan doorprize dan makan bersama',
      lokasi: 'Rumah Bu Rina',
      peserta: 35,
    ),
    Activity(
      id: 14,
      nama: 'Vaksinasi Massal',
      kategori: 'Kesehatan & Olahraga',
      penanggungJawab: 'Bu Sari',
      tanggal: DateTime(2025, 11, 3),
      waktu: '09:00',
      deskripsi: 'Vaksinasi massal untuk warga RT bekerjasama dengan Puskesmas',
      lokasi: 'Balai RW',
      peserta: 60,
    ),
    Activity(
      id: 15,
      nama: 'Tahlilan Malam Jumat',
      kategori: 'Keagamaan',
      penanggungJawab: 'Pak Ahmad',
      tanggal: DateTime(2025, 11, 8),
      waktu: '20:00',
      deskripsi: 'Tahlilan rutin malam Jumat untuk almarhum dan almarhumah',
      lokasi: 'Masjid Al-Ikhlas',
      peserta: 45,
    ),
    Activity(
      id: 16,
      nama: 'Pelatihan UMKM',
      kategori: 'Pendidikan',
      penanggungJawab: 'Bu Endah',
      tanggal: DateTime(2025, 11, 10),
      waktu: '13:00',
      deskripsi: 'Pelatihan pembuatan makanan ringan dan packaging untuk ibu-ibu',
      lokasi: 'Balai RT',
      peserta: 25,
    ),
    Activity(
      id: 17,
      nama: 'Cek Kesehatan Gratis Lansia',
      kategori: 'Kesehatan & Olahraga',
      penanggungJawab: 'Bu Sari',
      tanggal: DateTime(2025, 11, 12),
      waktu: '08:00',
      deskripsi: 'Pemeriksaan kesehatan gratis untuk lansia (tensi, gula darah, kolesterol)',
      lokasi: 'Balai RW',
      peserta: 32,
    ),
    Activity(
      id: 18,
      nama: 'Bersih-bersih Saluran Air',
      kategori: 'Kebersihan & Keamanan',
      penanggungJawab: 'Pak Budi',
      tanggal: DateTime(2025, 11, 15),
      waktu: '07:00',
      deskripsi: 'Gotong royong membersihkan saluran air untuk mencegah banjir',
      lokasi: 'Sepanjang Jalan RT',
      peserta: 30,
    ),
    Activity(
      id: 19,
      nama: 'Pengajian Anak-anak TPQ',
      kategori: 'Keagamaan',
      penanggungJawab: 'Ustadz Yusuf',
      tanggal: DateTime(2025, 11, 16),
      waktu: '15:30',
      deskripsi: 'Pengajian dan belajar membaca Al-Quran untuk anak-anak',
      lokasi: 'Masjid Al-Ikhlas',
      peserta: 38,
    ),
    Activity(
      id: 20,
      nama: 'Pertemuan Karang Taruna',
      kategori: 'Komunitas & Sosial',
      penanggungJawab: 'Pak Wahyu',
      tanggal: DateTime(2025, 11, 18),
      waktu: '19:00',
      deskripsi: 'Pertemuan rutin karang taruna membahas kegiatan pemuda',
      lokasi: 'Pos Ronda RT 03',
      peserta: 16,
    ),
    Activity(
      id: 21,
      nama: 'Bimbel SMP Gratis',
      kategori: 'Pendidikan',
      penanggungJawab: 'Pak Joko',
      tanggal: DateTime(2025, 11, 20),
      waktu: '16:00',
      deskripsi: 'Bimbingan belajar matematika dan IPA untuk siswa SMP',
      lokasi: 'Rumah Pak Joko',
      peserta: 12,
    ),
    Activity(
      id: 22,
      nama: 'Donor Darah',
      kategori: 'Kesehatan & Olahraga',
      penanggungJawab: 'Bu Sari',
      tanggal: DateTime(2025, 11, 22),
      waktu: '09:00',
      deskripsi: 'Donor darah bekerjasama dengan PMI untuk membantu sesama',
      lokasi: 'Balai Desa',
      peserta: 28,
    ),
    Activity(
      id: 23,
      nama: 'Rapat Pleno RT/RW',
      kategori: 'Komunitas & Sosial',
      penanggungJawab: 'Bu RT',
      tanggal: DateTime(2025, 11, 25),
      waktu: '20:00',
      deskripsi: 'Rapat pleno evaluasi program kerja dan perencanaan tahun depan',
      lokasi: 'Balai RW',
      peserta: 18,
    ),
  ];
  /// Get all activities from data source
  List<Activity> findAll() {
    return List.from(_activities);
  }

  /// Find activity by ID
  Activity? findById(int id) {
    try {
      return _activities.firstWhere((activity) => activity.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Find activities by category
  List<Activity> findByCategory(String category) {
    return _activities
        .where((activity) => activity.kategori == category)
        .toList();
  }

  /// Find activities by date range
  List<Activity> findByDateRange(DateTime start, DateTime end) {
    return _activities.where((activity) {
      return activity.tanggal.isAfter(start.subtract(const Duration(days: 1))) &&
          activity.tanggal.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  /// Create new activity
  Activity create(Activity activity) {
    // Generate new ID
    final newId = _activities.isEmpty 
        ? 1 
        : _activities.map((a) => a.id).reduce((a, b) => a > b ? a : b) + 1;
    
    final newActivity = activity.copyWith(id: newId);
    _activities.add(newActivity);
    return newActivity;
  }

  /// Update existing activity
  Activity? update(Activity activity) {
    final index = _activities.indexWhere((a) => a.id == activity.id);
    if (index != -1) {
      _activities[index] = activity;
      return activity;
    }
    return null;
  }

  /// Delete activity by ID
  bool delete(int id) {
    final initialLength = _activities.length;
    _activities.removeWhere((activity) => activity.id == id);
    return _activities.length < initialLength;
  }

  /// Check if activity exists
  bool exists(int id) {
    return _activities.any((activity) => activity.id == id);
  }

  /// Get total count of activities
  int count() {
    return _activities.length;
  }

  /// Clear all activities (for testing purposes)
  void clear() {
    _activities.clear();
  }
}