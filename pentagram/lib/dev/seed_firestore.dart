import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import 'package:flutter/foundation.dart';
import 'package:pentagram/models/activity.dart';
import 'package:pentagram/models/activity_log.dart';
import 'package:pentagram/models/citizen.dart';
import 'package:pentagram/models/family.dart';
import 'package:pentagram/models/family_mutation.dart';
import 'package:pentagram/models/house.dart';
import 'package:pentagram/models/transaction.dart';
import 'package:pentagram/models/broadcast_message.dart';

/// Dev-only seeding helper. Call `seedFirestore()` once after Firebase init
/// (e.g. from a debug-only button) to populate sample data if collections are empty.
Future<void> seedFirestore() async {
  if (kReleaseMode) return; // avoid accidental production seeding

  final firestore = FirebaseFirestore.instance;

  await _seedPesan(firestore);
  await _seedActivities(firestore);
  await _seedActivityLogs(firestore);
  await _seedTransactions(firestore);
  await _seedCitizens(firestore);
  await _seedFamilies(firestore);
  await _seedHouses(firestore);
  await _seedFamilyMutations(firestore);
  await _seedBroadcastMessages(firestore);
  await _seedUsers(firestore);
  await _seedChannels(firestore);
  await _seedPenerimaanWarga(firestore);
}

Future<void> _seedPesan(FirebaseFirestore firestore) async {
  final col = firestore.collection('pesan');
  final snap = await col.limit(1).get();
  if (snap.docs.isNotEmpty) return; // sudah ada data

  final batch = firestore.batch();
  final now = DateTime.now();
  final samples = [
    {
      'nama': 'Admin',
      'pesan': 'Selamat datang di aplikasi Jawara Pintar!',
      'waktu': 'init',
      'unread': true,
      'avatar': 'AD',
      'createdAt': now,
    },
    {
      'nama': 'Ketua RT',
      'pesan': 'Rapat warga hari Sabtu pukul 19.00.',
      'waktu': 'jadwal',
      'unread': true,
      'avatar': 'RT',
      'createdAt': now.add(const Duration(minutes: 1)),
    },
    {
      'nama': 'Admin',
      'pesan': 'Jangan lupa update data keluarga.',
      'waktu': 'pengingat',
      'unread': false,
      'avatar': 'AD',
      'createdAt': now.add(const Duration(minutes: 2)),
    },
  ];

  for (final doc in samples) {
    final ref = col.doc();
    batch.set(ref, doc);
  }
  await batch.commit();
}

Future<void> _seedBroadcastMessages(FirebaseFirestore firestore) async {
  final col = firestore.collection('broadcast_messages');
  final snap = await col.limit(1).get();
  if (snap.docs.isNotEmpty) return;

  final now = DateTime.now();
  final messages = [
    BroadcastMessage(
      id: 1,
      title: 'Pengumuman Gotong Royong Minggu Ini',
      content:
          'Kepada seluruh warga RT 01/RW 02, dihimbau untuk mengikuti kegiatan gotong royong pada hari Minggu, 27 Oktober 2024 pukul 08:00 WIB. Mohon kehadiran semua warga.',
      category: 'Kegiatan',
      isUrgent: false,
      sender: 'Admin Jawara',
      sentDate: now.subtract(const Duration(days: 3, hours: 2)),
      recipientCount: 85,
      readCount: 72,
      recipients: const ['Semua Warga RT 01'],
    ),
    BroadcastMessage(
      id: 2,
      title: 'URGENT: Pemadaman Listrik Besok',
      content:
          'Info penting! Besok akan ada pemadaman listrik dari PLN pukul 09:00-15:00 WIB. Harap persiapkan diri dan matikan peralatan listrik penting.',
      category: 'Informasi Umum',
      isUrgent: true,
      sender: 'Pak RT',
      sentDate: now.subtract(const Duration(days: 2, hours: 6)),
      recipientCount: 85,
      readCount: 81,
      recipients: const ['Semua Warga RT 01'],
    ),
    BroadcastMessage(
      id: 3,
      title: 'Reminder Pembayaran Iuran RT Bulan Ini',
      content:
          'Kepada warga yang belum membayar iuran RT bulan ini sebesar Rp 50.000, dimohon untuk segera melakukan pembayaran paling lambat tanggal 25.',
      category: 'Iuran',
      isUrgent: false,
      sender: 'Bu Bendahara',
      sentDate: now.subtract(const Duration(days: 4)),
      recipientCount: 32,
      readCount: 28,
      recipients: const ['Warga Belum Bayar'],
    ),
  ];

  final batch = firestore.batch();
  for (final m in messages) {
    batch.set(col.doc(), m.toMap());
  }
  await batch.commit();
}

Future<void> _seedUsers(FirebaseFirestore firestore) async {
  final col = firestore.collection('users');
  final count = await col.limit(1).get();
  if (count.docs.isNotEmpty) return;
  final users = [
    {'name': 'Budi Santoso', 'email': 'budi@gmail.com', 'status': 'Diterima'},
    {'name': 'Siti Aminah', 'email': 'siti@gmail.com', 'status': 'Menunggu'},
    {'name': 'Rizky Ananda', 'email': 'rizky@gmail.com', 'status': 'Diterima'},
  ];
  for (final u in users) {
    await col.add(u);
  }
}

Future<void> _seedChannels(FirebaseFirestore firestore) async {
  final col = firestore.collection('channels');
  final count = await col.limit(1).get();
  if (count.docs.isNotEmpty) return;
  final channels = [
    {'name': 'Transfer via BCA', 'type': 'Bank', 'accountName': 'RT Jawara Karangploso', 'thumbnail': 'assets/icons/bank.png'},
    {'name': 'Gopay Ketua RT', 'type': 'E-Wallet', 'accountName': 'Budi Santoso', 'thumbnail': 'assets/icons/ewallet.png'},
    {'name': 'QRIS Resmi RT 08', 'type': 'QRIS', 'accountName': 'RW 08 Karangploso', 'thumbnail': 'assets/icons/qris.png'},
  ];
  for (final c in channels) {
    await col.add(c);
  }
}

Future<void> _seedPenerimaanWarga(FirebaseFirestore firestore) async {
  final col = firestore.collection('penerimaan_warga');
  final count = await col.limit(1).get();
  if (count.docs.isNotEmpty) return;
  final warga = [
    {
      'no': 1,
      'nama': 'Farhan Hidayat',
      'nik': '3201012345678901',
      'email': 'farhan@gmail.com',
      'jenisKelamin': 'Laki-laki',
      'fotoIdentitas': 'assets/images/ktp1.png',
      'statusRegistrasi': 'Pending',
    },
    {
      'no': 2,
      'nama': 'Siti Nurhaliza',
      'nik': '3201012345678902',
      'email': 'siti@gmail.com',
      'jenisKelamin': 'Perempuan',
      'fotoIdentitas': 'assets/images/ktp2.png',
      'statusRegistrasi': 'Diterima',
    },
  ];
  for (final w in warga) {
    await col.add(w);
  }
}

Future<void> _seedActivities(FirebaseFirestore firestore) async {
  final col = firestore.collection('activities');
  final snap = await col.limit(1).get();
  if (snap.docs.isNotEmpty) return;

  final batch = firestore.batch();
  final activities = [
    Activity(
      id: 1,
      nama: 'Gotong Royong Kampung',
      kategori: 'Kebersihan & Keamanan',
      penanggungJawab: 'Pak Budi',
      tanggal: DateTime(2025, 10, 5, 8),
      waktu: '08:00',
      deskripsi: 'Bersih-bersih lingkungan dan selokan.',
      lokasi: 'RT 01/RW 02',
      peserta: 25,
    ),
    Activity(
      id: 2,
      nama: 'Pengajian Ibu PKK',
      kategori: 'Keagamaan',
      penanggungJawab: 'Bu Fatimah',
      tanggal: DateTime(2025, 10, 20, 14),
      waktu: '14:00',
      deskripsi: 'Kajian pekanan untuk ibu-ibu.',
      lokasi: 'Masjid Al-Ikhlas',
      peserta: 38,
    ),
    Activity(
      id: 3,
      nama: 'Senam Pagi Lansia',
      kategori: 'Kesehatan & Olahraga',
      penanggungJawab: 'Bu Endah',
      tanggal: DateTime(2025, 10, 23, 6, 30),
      waktu: '06:30',
      deskripsi: 'Senam rutin lansia bersama instruktur.',
      lokasi: 'Lapangan RT',
      peserta: 22,
    ),
    Activity(
      id: 4,
      nama: 'Rapat Koordinasi RT',
      kategori: 'Komunitas & Sosial',
      penanggungJawab: 'Bu RT',
      tanggal: DateTime(2025, 10, 23, 19, 30),
      waktu: '19:30',
      deskripsi: 'Pembahasan program bulan depan.',
      lokasi: 'Balai RT',
      peserta: 12,
    ),
  ];

  for (final activity in activities) {
    batch.set(col.doc(), activity.toMap());
  }

  await batch.commit();
}

Future<void> _seedActivityLogs(FirebaseFirestore firestore) async {
  final col = firestore.collection('activity_logs');
  final snap = await col.limit(1).get();
  if (snap.docs.isNotEmpty) return;

  final now = DateTime.now();
  final logs = [
    ActivityLog(
      no: 1,
      deskripsi: 'Menambahkan kegiatan Gotong Royong Kampung',
      aktor: 'Admin Jawara',
      tanggal: now.subtract(const Duration(hours: 1)),
      avatar: 'AJ',
    ),
    ActivityLog(
      no: 2,
      deskripsi: 'Memperbarui jumlah peserta Senam Pagi',
      aktor: 'Bu Endah',
      tanggal: now.subtract(const Duration(hours: 3)),
      avatar: 'BE',
    ),
    ActivityLog(
      no: 3,
      deskripsi: 'Mengirim broadcast rapat koordinasi',
      aktor: 'Bu RT',
      tanggal: now.subtract(const Duration(hours: 6)),
      avatar: 'BR',
    ),
  ];

  final batch = firestore.batch();
  for (final log in logs) {
    batch.set(col.doc(), log.toMap());
  }
  await batch.commit();
}

Future<void> _seedTransactions(FirebaseFirestore firestore) async {
  final col = firestore.collection('transactions');
  final snap = await col.limit(1).get();
  if (snap.docs.isNotEmpty) return;

  final transactions = [
    Transaction(
      title: 'Iuran Bulanan Oktober',
      date: DateTime(2025, 10, 21),
      amount: 2500000,
      isIncome: true,
    ),
    Transaction(
      title: 'Donasi Kegiatan',
      date: DateTime(2025, 10, 20),
      amount: 1000000,
      isIncome: true,
    ),
    Transaction(
      title: 'Belanja Kegiatan Bersih Desa',
      date: DateTime(2025, 10, 19),
      amount: 1200000,
      isIncome: false,
    ),
    Transaction(
      title: 'Konsumsi Rapat',
      date: DateTime(2025, 10, 18),
      amount: 350000,
      isIncome: false,
    ),
  ];

  final batch = firestore.batch();
  for (final trx in transactions) {
    batch.set(col.doc(), trx.toMap());
  }
  await batch.commit();
}

Future<void> _seedCitizens(FirebaseFirestore firestore) async {
  final col = firestore.collection('citizens');
  final snap = await col.limit(1).get();
  if (snap.docs.isNotEmpty) return;

  final citizens = [
    Citizen(
      name: 'Ahmad Subarjo',
      nik: '3201012345678901',
      familyRole: 'Kepala Keluarga',
      status: 'Aktif',
      gender: 'Laki-laki',
      maritalStatus: 'Kawin',
      birthDate: DateTime(1980, 4, 12),
      religion: 'Islam',
      education: 'S1',
      occupation: 'Karyawan Swasta',
      familyName: 'Keluarga Ahmad Subarjo',
    ),
    Citizen(
      name: 'Siti Nurhaliza',
      nik: '3201012345678902',
      familyRole: 'Istri',
      status: 'Aktif',
      gender: 'Perempuan',
      maritalStatus: 'Kawin',
      birthDate: DateTime(1984, 7, 2),
      religion: 'Islam',
      education: 'SMA/SMK',
      occupation: 'Ibu Rumah Tangga',
      familyName: 'Keluarga Ahmad Subarjo',
    ),
    Citizen(
      name: 'Budi Santoso',
      nik: '3201012345678903',
      familyRole: 'Kepala Keluarga',
      status: 'Aktif',
      gender: 'Laki-laki',
      maritalStatus: 'Kawin',
      birthDate: DateTime(1978, 1, 23),
      religion: 'Islam',
      education: 'SMA/SMK',
      occupation: 'Wiraswasta',
      familyName: 'Keluarga Budi Santoso',
    ),
    Citizen(
      name: 'Dewi Lestari',
      nik: '3201012345678904',
      familyRole: 'Anak',
      status: 'Tidak Aktif',
      gender: 'Perempuan',
      maritalStatus: 'Belum Kawin',
      birthDate: DateTime(2005, 3, 30),
      religion: 'Islam',
      education: 'SMA/SMK',
      occupation: 'Pelajar',
      familyName: 'Keluarga Budi Santoso',
    ),
    Citizen(
      name: 'Andi Wijaya',
      nik: '3201012345678905',
      familyRole: 'Kepala Keluarga',
      status: 'Aktif',
      gender: 'Laki-laki',
      maritalStatus: 'Kawin',
      birthDate: DateTime(1990, 9, 14),
      religion: 'Islam',
      education: 'S1',
      occupation: 'PNS/TNI/Polri',
      familyName: 'Keluarga Andi Wijaya',
    ),
  ];

  final batch = firestore.batch();
  for (final citizen in citizens) {
    batch.set(col.doc(), citizen.toMap());
  }
  await batch.commit();
}

Future<void> _seedFamilies(FirebaseFirestore firestore) async {
  final col = firestore.collection('families');
  final snap = await col.limit(1).get();
  if (snap.docs.isNotEmpty) return;

  final families = [
    Family(
      name: 'Keluarga Ahmad Subarjo',
      headOfFamily: 'Ahmad Subarjo',
      memberCount: 4,
      address: 'Jl. Mawar No. 12',
    ),
    Family(
      name: 'Keluarga Budi Santoso',
      headOfFamily: 'Budi Santoso',
      memberCount: 3,
      address: 'Jl. Melati No. 8',
    ),
    Family(
      name: 'Keluarga Andi Wijaya',
      headOfFamily: 'Andi Wijaya',
      memberCount: 5,
      address: 'Jl. Anggrek No. 15',
    ),
  ];

  final batch = firestore.batch();
  for (final family in families) {
    batch.set(col.doc(), family.toMap());
  }
  await batch.commit();
}

Future<void> _seedHouses(FirebaseFirestore firestore) async {
  final col = firestore.collection('houses');
  final snap = await col.limit(1).get();
  if (snap.docs.isNotEmpty) return;

  final houses = [
    House(
      address: 'Jl. Mawar No. 12',
      rt: '01',
      rw: '02',
      headName: 'Ahmad Subarjo',
      status: 'Dihuni',
    ),
    House(
      address: 'Jl. Melati No. 8',
      rt: '01',
      rw: '02',
      headName: 'Budi Santoso',
      status: 'Dihuni',
    ),
    const House(
      address: 'Jl. Kenanga No. 5',
      rt: '02',
      rw: '03',
      headName: '-',
      status: 'Kosong',
    ),
  ];

  final batch = firestore.batch();
  for (final house in houses) {
    batch.set(col.doc(), house.toMap());
  }
  await batch.commit();
}

Future<void> _seedFamilyMutations(FirebaseFirestore firestore) async {
  final col = firestore.collection('family_mutations');
  final snap = await col.limit(1).get();
  if (snap.docs.isNotEmpty) return;

  final records = [
    FamilyMutation(
      no: 1,
      family: 'Keluarga Ijat',
      type: 'Keluar Wilayah',
      date: DateTime(2025, 10, 15),
      oldAddress: 'Jl. Mawar No. 12',
      newAddress: '-',
      reason: 'Pindah ke luar kota',
    ),
    FamilyMutation(
      no: 2,
      family: 'Keluarga Mara Nunez',
      type: 'Pindah Rumah',
      date: DateTime(2025, 9, 30),
      oldAddress: 'Jl. Melati No. 7',
      newAddress: 'Jl. Kenanga No. 5',
      reason: 'Rumah pribadi selesai direnovasi',
    ),
  ];

  final batch = firestore.batch();
  for (final mutation in records) {
    batch.set(col.doc(), mutation.toMap());
  }
  await batch.commit();
}
