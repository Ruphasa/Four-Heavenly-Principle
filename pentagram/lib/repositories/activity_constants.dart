class ActivityConstants {
  // Private constructor to prevent instantiation
  ActivityConstants._();

  static const List<String> kategoriOptions = [
    'Komunitas & Sosial',
    'Kebersihan & Keamanan',
    'Keagamaan',
    'Pendidikan',
    'Kesehatan & Olahraga',
    'Lainnya',
  ];

  static const List<String> lokasiOptions = [
    'RT 01/RW 01',
    'RT 02/RW 01',
    'RT 03/RW 01',
    'RT 01/RW 02',
    'RT 02/RW 02',
    'RT 03/RW 02',
    'Balai Desa',
    'Masjid Al-Ikhlas',
    'Lapangan Desa',
    'Kantor Desa',
  ];

  static const List<String> penanggungJawabOptions = [
    'Pak Bambang',
    'Pak Rosyid',
    'Pak Budi',
    'Pak Ahmad',
    'Bu Sari',
    'Pak Joko',
    'Bu Rina',
    'Pak Sutrisno',
    'Bu Endah',
    'Pak Wahyu',
  ];

  // Category colors mapping
  static const Map<String, int> categoryColors = {
    'Komunitas & Sosial': 0xFF4285F4,
    'Kebersihan & Keamanan': 0xFF34A853,
    'Keagamaan': 0xFFFF9800,
    'Pendidikan': 0xFF9C27B0,
    'Kesehatan & Olahraga': 0xFFE91E63,
    'Lainnya': 0xFF2196F3,
  };
}