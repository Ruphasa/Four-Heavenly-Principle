import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Dev-only seeding helper. Call `seedFirestore()` once after Firebase init
/// (e.g. from a debug-only button) to populate sample data if collections are empty.
Future<void> seedFirestore() async {
  if (kReleaseMode) return; // avoid accidental production seeding

  final firestore = FirebaseFirestore.instance;

  await _seedPesan(firestore);
  // Tambah pemanggilan _seedX lainnya di sini untuk koleksi lain.
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
