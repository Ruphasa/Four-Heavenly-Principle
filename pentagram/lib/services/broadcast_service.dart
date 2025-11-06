import 'package:pentagram/models/broadcast_message.dart';

class BroadcastService {
  static final BroadcastService _instance = BroadcastService._internal();
  factory BroadcastService() => _instance;
  BroadcastService._internal();

  final List<BroadcastMessage> _messages = [
    BroadcastMessage(
      id: 1,
      title: 'Pengumuman Gotong Royong Minggu Ini',
      content: 'Kepada seluruh warga RT 01/RW 02, dihimbau untuk mengikuti kegiatan gotong royong pada hari Minggu, 27 Oktober 2024 pukul 08:00 WIB. Mohon kehadiran semua warga.',
      category: 'Kegiatan',
      isUrgent: false,
      sender: 'Admin Jawara',
      sentDate: DateTime(2024, 10, 22, 14, 30),
      recipientCount: 85,
      readCount: 72,
      recipients: ['Semua Warga RT 01'],
    ),
    BroadcastMessage(
      id: 2,
      title: 'URGENT: Pemadaman Listrik Besok',
      content: 'Info penting! Besok 23 Oktober 2024 akan ada pemadaman listrik dari PLN pukul 09:00-15:00 WIB. Harap persiapkan diri dan matikan peralatan listrik penting.',
      category: 'Informasi Umum',
      isUrgent: true,
      sender: 'Pak RT',
      sentDate: DateTime(2024, 10, 22, 10, 15),
      recipientCount: 85,
      readCount: 81,
      recipients: ['Semua Warga RT 01'],
    ),
    BroadcastMessage(
      id: 3,
      title: 'Reminder Pembayaran Iuran RT Bulan Oktober',
      content: 'Kepada warga yang belum membayar iuran RT bulan Oktober sebesar Rp 50.000, dimohon untuk segera melakukan pembayaran paling lambat tanggal 25 Oktober 2024.',
      category: 'Iuran',
      isUrgent: false,
      sender: 'Bu Bendahara',
      sentDate: DateTime(2024, 10, 21, 16, 45),
      recipientCount: 32,
      readCount: 28,
      recipients: ['Warga Belum Bayar'],
    ),
    BroadcastMessage(
      id: 4,
      title: 'URGENT: Kasus Pencurian di RT 03',
      content: 'Waspada! Tadi malam terjadi pencurian di RT 03. Harap warga lebih waspada dan mengunci rumah dengan baik. Jika melihat hal mencurigakan segera hubungi Pak Hansip.',
      category: 'Keamanan',
      isUrgent: true,
      sender: 'Pak Hansip',
      sentDate: DateTime(2024, 10, 21, 7, 30),
      recipientCount: 85,
      readCount: 85,
      recipients: ['Semua Warga RT 01'],
    ),
    BroadcastMessage(
      id: 5,
      title: 'Vaksinasi Massal 3 November 2024',
      content: 'Akan diadakan vaksinasi massal bekerjasama dengan Puskesmas pada 3 November 2024 pukul 09:00 di Balai RW. Bawa KTP dan KK. Gratis untuk semua warga.',
      category: 'Kesehatan',
      isUrgent: false,
      sender: 'Bu Sari',
      sentDate: DateTime(2024, 10, 20, 14, 0),
      recipientCount: 85,
      readCount: 68,
      recipients: ['Semua Warga RT 01'],
    ),
  ];

  List<BroadcastMessage> getAllMessages() {
    return List.from(_messages);
  }

  List<BroadcastMessage> getUrgentMessages() {
    return _messages.where((msg) => msg.isUrgent).toList();
  }

  List<BroadcastMessage> getSentMessages() {
    return _messages;
  }

  Map<String, dynamic> getBroadcastStatistics() {
    final urgent = _messages.where((msg) => msg.isUrgent).length;
    final now = DateTime.now();
    final today = _messages.where((msg) {
      return msg.sentDate.year == now.year &&
          msg.sentDate.month == now.month &&
          msg.sentDate.day == now.day;
    }).length;

    return {
      'totalMessages': _messages.length,
      'sent': _messages.length,
      'urgent': urgent,
      'today': today,
    };
  }

  void sendBroadcast(BroadcastMessage message) {
    _messages.insert(0, message);
  }
}