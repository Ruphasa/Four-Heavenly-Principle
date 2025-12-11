import 'package:cloud_firestore/cloud_firestore.dart';

/// Simple normalized seeders creating linked demo data across collections.
/// Run these once in a controlled/dev environment.
class Seeders {
  final FirebaseFirestore firestore;
  Seeders(this.firestore);

  /// Optionally clears known collections before seeding fresh, for consistent state.
  Future<void> runAll({bool clearBefore = false}) async {
    if (clearBefore) {
      await clearCollections([
        'activity_logs',
        'activities',
        'broadcast_messages',
        'channels',
        'transactions',
        'penerimaan_warga',
        'pesan',
        'citizens',
        'families',
        'houses',
        'users',
      ]);
    }
    final users = await seedUsers();
    final channels = await seedChannels(users);
    final families = await seedFamilies();
    final houses = await seedHouses();
    final citizens = await seedCitizens(families, houses);
    await setFamilyHeads(families, citizens);
    await _updateFamilyDetails(families, citizens, houses);
    await _updateHouseHeads(houses, citizens);
    final activities = await seedActivities(users);
    await seedActivityLogs(activities, users);
    await seedBroadcasts(channels, users);
    await seedTransactions(users);
    await seedPenerimaanWarga(citizens);
    await seedPesan(citizens);
  }

  /// Deletes all docs in the provided collections in small batches.
  Future<void> clearCollections(List<String> collections) async {
    for (final name in collections) {
      final col = firestore.collection(name);
      while (true) {
        final snap = await col.limit(250).get();
        if (snap.docs.isEmpty) break;
        final batch = firestore.batch();
        for (final d in snap.docs) {
          batch.delete(d.reference);
        }
        await batch.commit();
      }
    }
  }

  Future<List<DocumentReference>> seedUsers() async {
    final col = firestore.collection('users');
    final batch = firestore.batch();
    
    // Admin user with Firebase Auth UID (tidak masuk ke citizen)
    final adminRef = col.doc('nyyTL9RMhKZuchjQ4hCXZ6nx4u33');
    batch.set(adminRef, {
      'name': 'Admin',
      'email': 'admin@example.com',
      'status': 'Disetujui',
      'role': 'Admin',
      'createdAt': FieldValue.serverTimestamp(),
    });
    
    // Ruphasa Mafahl user with Firebase Auth UID
    final ruphasaRef = col.doc('gdBrktH29QgsG7guxE8rHPUq93k1');
    batch.set(ruphasaRef, {
      'name': 'Ruphasa Mafahl',
      'email': 'ruphasa@example.com',
      'status': 'Disetujui',
      'role': 'User',
      'createdAt': FieldValue.serverTimestamp(),
    });
    
    // Warga users - setiap citizen akan punya user account
    final wargaUsers = [
      {'id': 'user_andi', 'name': 'Andi Wijaya', 'email': 'andi@example.com'},
      {'id': 'user_rina', 'name': 'Rina Wijaya', 'email': 'rina@example.com'},
      {'id': 'user_budi', 'name': 'Budi Santoso', 'email': 'budi@example.com'},
      {'id': 'user_dewi', 'name': 'Dewi Santoso', 'email': 'dewi@example.com'},
    ];
    
    final refs = <DocumentReference>[adminRef, ruphasaRef];
    for (final u in wargaUsers) {
      final ref = col.doc(u['id']!);
      batch.set(ref, {
        'name': u['name'],
        'email': u['email'],
        'status': 'Disetujui',
        'role': 'User',
        'createdAt': FieldValue.serverTimestamp(),
      });
      refs.add(ref);
    }
    await batch.commit();
    return refs;
  }

  Future<List<DocumentReference>> seedChannels(List<DocumentReference> users) async {
    final col = firestore.collection('channels');
    final batch = firestore.batch();
    final refs = <DocumentReference>[];
    final adminId = 'nyyTL9RMhKZuchjQ4hCXZ6nx4u33';
    final channels = [
      {
        'id': 'channel1',
        'name': 'Informasi RW',
        'type': 'WhatsApp',
        'accountName': 'Grup RT 001',
      },
      {
        'id': 'channel2',
        'name': 'Kegiatan Warga',
        'type': 'Telegram',
        'accountName': 'Channel RW',
      },
    ];
    for (final ch in channels) {
      final ref = col.doc(ch['id']!);
      batch.set(ref, {
        'name': ch['name'],
        'type': ch['type'],
        'accountName': ch['accountName'],
        'createdByUserId': adminId,
        'createdAt': FieldValue.serverTimestamp(),
      });
      refs.add(ref);
    }
    await batch.commit();
    return refs;
  }

  Future<List<DocumentReference>> seedFamilies() async {
    final col = firestore.collection('families');
    final refs = <DocumentReference>[];
    final familyNames = ['Keluarga Wijaya', 'Keluarga Santoso'];
    for (var i = 0; i < familyNames.length; i++) {
      final ref = col.doc('family${i + 1}');
      await ref.set({
        'name': familyNames[i],
        'headOfFamily': '-',
        'memberCount': 0,
        'address': '-',
        'createdAt': FieldValue.serverTimestamp(),
      });
      refs.add(ref);
    }
    return refs;
  }

  Future<List<DocumentReference>> seedHouses() async {
    final col = firestore.collection('houses');
    final refs = <DocumentReference>[];
    final addresses = ['Jl. Merdeka No. 10', 'Jl. Mawar No. 5'];
    for (var i = 0; i < addresses.length; i++) {
      final ref = col.doc('house${i + 1}');
      await ref.set({
        'address': addresses[i],
        'rt': '001',
        'rw': '002',
        'headName': '-',
        'status': 'Dihuni',
        'familyId': null,
        'createdAt': FieldValue.serverTimestamp(),
      });
      refs.add(ref);
    }
    return refs;
  }

  Future<List<DocumentReference>> seedCitizens(
      List<DocumentReference> families, List<DocumentReference> houses) async {
    final col = firestore.collection('citizens');
    final batch = firestore.batch();
    final refs = <DocumentReference>[];
    
    // families[0] -> Keluarga Wijaya, families[1] -> Keluarga Santoso
    // houses[0] -> Jl. Merdeka No. 10, houses[1] -> Jl. Mawar No. 5

    final citizensSeed = [
      {
        'id': 'citizen1',
        'userId': 'user_andi',
        'name': 'Andi Wijaya',
        'family': families[0],
        'house': houses[0],
        'familyRole': 'Kepala Keluarga',
        'gender': 'Laki-laki',
        'birthDate': DateTime(1990, 1, 10),
      },
      {
        'id': 'citizen2',
        'userId': 'user_rina',
        'name': 'Rina Wijaya',
        'family': families[0],
        'house': houses[0],
        'familyRole': 'Istri',
        'gender': 'Perempuan',
        'birthDate': DateTime(1992, 5, 20),
      },
      {
        'id': 'citizen3',
        'userId': 'user_budi',
        'name': 'Budi Santoso',
        'family': families[1],
        'house': houses[1],
        'familyRole': 'Kepala Keluarga',
        'gender': 'Laki-laki',
        'birthDate': DateTime(1988, 3, 15),
      },
      {
        'id': 'citizen4',
        'userId': 'user_dewi',
        'name': 'Dewi Santoso',
        'family': families[1],
        'house': houses[1],
        'familyRole': 'Istri',
        'gender': 'Perempuan',
        'birthDate': DateTime(1991, 8, 5),
      },
    ];

    for (var i = 0; i < citizensSeed.length; i++) {
      final c = citizensSeed[i];
      final ref = col.doc(c['id'] as String);
      final familyRef = c['family'] as DocumentReference;
      final houseRef = c['house'] as DocumentReference;
      final familyRole = c['familyRole'] as String;
      final gender = c['gender'] as String;
      final birthDate = c['birthDate'] as DateTime;
      final name = c['name'] as String;
      final userId = c['userId'] as String;

      batch.set(ref, {
        'userId': userId,
        'name': name,
        'nik': '31740${1000 + i}',
        'familyId': familyRef.id,
        'houseId': houseRef.id,
        'familyRole': familyRole,
        'status': 'Aktif',
        'gender': gender,
        'maritalStatus': familyRole == 'Anak' ? 'Belum Kawin' : 'Kawin',
        'birthDate': Timestamp.fromDate(birthDate),
        'religion': 'Islam',
        'education': 'SMA/SMK',
        'occupation': familyRole == 'Istri' ? 'Ibu Rumah Tangga' : 'Wiraswasta',
        'familyName': familyRef.id == families[0].id
            ? 'Keluarga Wijaya'
            : 'Keluarga Santoso',
        'createdAt': FieldValue.serverTimestamp(),
      });
      refs.add(ref);
    }
    await batch.commit();
    return refs;
  }

  /// Set headCitizenId on each family to the first citizen we created for that family.
  Future<void> setFamilyHeads(List<DocumentReference> families, List<DocumentReference> citizens) async {
    final byFamily = <String, List<Map<String, dynamic>>>{};
    for (final c in citizens) {
      final snap = await c.get();
      final data = (snap.data() as Map<String, dynamic>);
      final fid = data['familyId'] as String?;
      if (fid != null) {
        byFamily.putIfAbsent(fid, () => []).add({'ref': c, 'data': data});
      }
    }
    final batch = firestore.batch();
    for (final f in families) {
      final list = byFamily[f.id] ?? [];
      if (list.isNotEmpty) {
        // Hanya yang memiliki role 'Kepala Keluarga' yang boleh menjadi kepala keluarga
        final kkCandidates = list.where((e) {
          final data = e['data'] as Map<String, dynamic>;
          return (data['familyRole'] as String?) == 'Kepala Keluarga';
        }).toList();

        if (kkCandidates.isEmpty) {
          // Tidak ada warga ber-role Kepala Keluarga di keluarga ini, biarkan tanpa headCitizenId
          continue;
        }

        final head = kkCandidates.first;
        final headRef = head['ref'] as DocumentReference;
        batch.update(f, {'headCitizenId': headRef.id});
      }
    }
    await batch.commit();
  }

  Future<List<DocumentReference>> seedActivities(List<DocumentReference> users) async {
    final col = firestore.collection('activities');
    final refs = <DocumentReference>[];
    final now = DateTime.now();
    final adminId = 'nyyTL9RMhKZuchjQ4hCXZ6nx4u33';
    final activities = [
      {
        'docId': 'activity1',
        'id': 1,
        'nama': 'Kerja Bakti Mingguan',
        'kategori': 'Kebersihan & Keamanan',
        'penanggungJawab': 'Admin',
        'tanggal': Timestamp.fromDate(now.add(const Duration(days: 2))),
        'waktu': '08:00 - 10:00',
        'deskripsi': 'Kerja bakti membersihkan lingkungan RT.',
        'lokasi': 'Balai Warga',
        'peserta': 25,
      },
      {
        'docId': 'activity2',
        'id': 2,
        'nama': 'Rapat RT Bulanan',
        'kategori': 'Komunitas & Sosial',
        'penanggungJawab': 'Admin',
        'tanggal': Timestamp.fromDate(now.add(const Duration(days: 7))),
        'waktu': '19:00 - 21:00',
        'deskripsi': 'Rapat koordinasi bulanan RT.',
        'lokasi': 'Rumah Ketua RT',
        'peserta': 15,
      },
      {
        'docId': 'activity3',
        'id': 3,
        'nama': 'Sosialisasi Kesehatan',
        'kategori': 'Kesehatan & Olahraga',
        'penanggungJawab': 'Admin',
        'tanggal': Timestamp.fromDate(now.subtract(const Duration(days: 3))),
        'waktu': '09:00 - 11:00',
        'deskripsi': 'Sosialisasi PHBS dan cek kesehatan.',
        'lokasi': 'Posyandu RW',
        'peserta': 40,
      },
    ];
    for (final a in activities) {
      final ref = col.doc(a['docId'] as String);
      await ref.set({
        'id': a['id'],
        'nama': a['nama'],
        'kategori': a['kategori'],
        'penanggung_jawab': a['penanggungJawab'],
        'organizerUserId': adminId,
        'tanggal': a['tanggal'],
        'waktu': a['waktu'],
        'deskripsi': a['deskripsi'],
        'lokasi': a['lokasi'],
        'peserta': a['peserta'],
        'createdAt': FieldValue.serverTimestamp(),
      });
      refs.add(ref);
    }
    return refs;
  }

  Future<void> seedActivityLogs(List<DocumentReference> activities, List<DocumentReference> users) async {
    final col = firestore.collection('activity_logs');
    final batch = firestore.batch();
    final now = DateTime.now();
    final entries = [
      {
        'id': 'log1',
        'no': 1,
        'deskripsi': 'Admin membuat kegiatan baru: Kerja Bakti Mingguan',
        'aktor': 'Admin',
        'tanggal': Timestamp.fromDate(now.subtract(const Duration(hours: 3))),
        'avatar': 'A',
      },
      {
        'id': 'log2',
        'no': 2,
        'deskripsi': 'Admin mengirim broadcast: Informasi iuran',
        'aktor': 'Admin',
        'tanggal': Timestamp.fromDate(now.subtract(const Duration(hours: 2))),
        'avatar': 'A',
      },
      {
        'id': 'log3',
        'no': 3,
        'deskripsi': 'Admin mencatat transaksi pemasukan',
        'aktor': 'Admin',
        'tanggal': Timestamp.fromDate(now.subtract(const Duration(hours: 1))),
        'avatar': 'A',
      },
    ];
    for (final e in entries) {
      final ref = col.doc(e['id'] as String);
      batch.set(ref, {
        'no': e['no'],
        'deskripsi': e['deskripsi'],
        'aktor': e['aktor'],
        'tanggal': e['tanggal'],
        'avatar': e['avatar'],
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
    await batch.commit();
  }

  Future<void> seedBroadcasts(List<DocumentReference> channels, List<DocumentReference> users) async {
    final col = firestore.collection('broadcast_messages');
    final batch = firestore.batch();
    final adminId = 'nyyTL9RMhKZuchjQ4hCXZ6nx4u33';
    final now = DateTime.now();
    final messages = [
      {
        'id': 'broadcast1',
        'numId': 1,
        'title': 'Informasi Iuran Bulanan',
        'content': 'Mohon melakukan pembayaran iuran RT sebelum tanggal 10.',
        'category': 'Iuran',
        'isUrgent': false,
        'sender': 'Admin',
        'channelId': channels.first.id,
        'sentDate': Timestamp.fromDate(now.subtract(const Duration(days: 1))),
        'recipientCount': 20,
        'readCount': 15,
        'recipients': <String>['citizen1', 'citizen2'],
      },
      {
        'id': 'broadcast2',
        'numId': 2,
        'title': 'Peringatan Keamanan',
        'content': 'Harap berhati-hati, ada laporan pencurian motor.',
        'category': 'Keamanan',
        'isUrgent': true,
        'sender': 'Admin',
        'channelId': channels.last.id,
        'sentDate': Timestamp.fromDate(now),
        'recipientCount': 20,
        'readCount': 5,
        'recipients': <String>['citizen3', 'citizen4'],
      },
    ];
    for (final m in messages) {
      final ref = col.doc(m['id'] as String);
      batch.set(ref, {
        'id': m['numId'],
        'title': m['title'],
        'content': m['content'],
        'category': m['category'],
        'isUrgent': m['isUrgent'],
        'sender': m['sender'],
        'channelId': m['channelId'],
        'senderUserId': adminId,
        'sentDate': m['sentDate'],
        'recipientCount': m['recipientCount'],
        'readCount': m['readCount'],
        'recipients': m['recipients'],
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
    await batch.commit();
  }

  Future<void> seedTransactions(List<DocumentReference> users) async {
    final col = firestore.collection('transactions');
    final batch = firestore.batch();
    final now = DateTime.now();
    final adminId = 'nyyTL9RMhKZuchjQ4hCXZ6nx4u33';
    final txs = [
      {
        'id': 'tx1',
        'title': 'Iuran Kebersihan',
        'amount': 150000,
        'isIncome': true,
        'date': Timestamp.fromDate(now.subtract(const Duration(days: 1))),
      },
      {
        'id': 'tx2',
        'title': 'Pembelian sapu',
        'amount': 85000,
        'isIncome': false,
        'date': Timestamp.fromDate(now.subtract(const Duration(days: 2))),
      },
      {
        'id': 'tx3',
        'title': 'Donasi warga',
        'amount': 200000,
        'isIncome': true,
        'date': Timestamp.fromDate(now),
      },
      {
        'id': 'tx4',
        'title': 'Perbaikan saluran air',
        'amount': 120000,
        'isIncome': false,
        'date': Timestamp.fromDate(now.subtract(const Duration(days: 5))),
      },
    ];
    for (final t in txs) {
      final ref = col.doc(t['id'] as String);
      batch.set(ref, {
        'title': t['title'],
        'amount': t['amount'],
        'isIncome': t['isIncome'],
        'date': t['date'],
        'createdByUserId': adminId,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
    await batch.commit();
  }

  Future<void> seedPenerimaanWarga(List<DocumentReference> citizens) async {
    final col = firestore.collection('penerimaan_warga');
    final batch = firestore.batch();
    for (var i = 0; i < citizens.length; i++) {
      final ref = col.doc('penerimaan${i + 1}');
      batch.set(ref, {
        'no': i + 1,
        'nama': i == 0
            ? 'Ahmad Fauzi'
            : i == 1
                ? 'Lestari Putri'
                : i == 2
                    ? 'Hadi Pratama'
                    : 'Maya Sari',
        'nik': '31740${2000 + i}',
        'email': 'pemohon${i + 1}@example.com',
        'jenisKelamin': i % 2 == 0 ? 'L' : 'P',
        'fotoIdentitas': 'assets/images/ktp_sample.png',
        'statusRegistrasi': 'Pending',
        'applicantCitizenId': citizens[i].id,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
    await batch.commit();
  }

  Future<void> seedPesan(List<DocumentReference> citizens) async {
    final col = firestore.collection('pesan');
    final batch = firestore.batch();
    for (var i = 0; i < citizens.length; i++) {
      final ref = col.doc('pesan${i + 1}');
      batch.set(ref, {
        'nama': i == 0
            ? 'Andi Wijaya'
            : i == 1
                ? 'Rina Wijaya'
                : i == 2
                    ? 'Budi Santoso'
                    : 'Dewi Santoso',
        'pesan': i % 2 == 0 ? 'Selamat pagi, warga!' : 'Jangan lupa kerja bakti.',
        'waktu': DateTime.now().toIso8601String(),
        'unread': i % 2 == 0,
        'avatar': '-',
        'citizenId': citizens[i].id,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
    await batch.commit();
  }

  /// After citizens are seeded and family head set, update family details
  /// like headOfFamily, memberCount, and address, and update house headName.
  Future<void> _updateFamilyDetails(List<DocumentReference> families, List<DocumentReference> citizens, List<DocumentReference> houses) async {
    final batch = firestore.batch();
    // Build lookup maps
    final citizensData = <String, Map<String, dynamic>>{};
    for (final c in citizens) {
      final snap = await c.get();
      citizensData[c.id] = (snap.data() as Map<String, dynamic>);
    }
    final familyMembers = <String, List<Map<String, dynamic>>>{};
    for (final c in citizensData.values) {
      final fid = c['familyId'] as String?;
      if (fid == null) continue;
      familyMembers.putIfAbsent(fid, () => []).add(c);
    }
    final housesData = <String, Map<String, dynamic>>{};
    for (final h in houses) {
      final snap = await h.get();
      housesData[h.id] = (snap.data() as Map<String, dynamic>);
    }
    for (final f in families) {
      final famSnap = await f.get();
      final data = famSnap.data() as Map<String, dynamic>;
      final headId = data['headCitizenId'] as String?;
      String headName = '-';
      String address = data['address'] as String? ?? '-';
      final members = familyMembers[f.id] ?? [];
      if (headId != null && citizensData.containsKey(headId)) {
        headName = citizensData[headId]!['name'] as String? ?? '-';
        final headHouseId = citizensData[headId]!['houseId'] as String?;
        if (headHouseId != null && housesData.containsKey(headHouseId)) {
          address = housesData[headHouseId]!['address'] as String? ?? address;
        }
      }
      batch.update(f, {
        'headOfFamily': headName,
        'memberCount': members.length,
        'address': address,
      });
    }
    await batch.commit();
  }

  Future<void> _updateHouseHeads(List<DocumentReference> houses, List<DocumentReference> citizens) async {
    final batch = firestore.batch();
    final citizensData = <String, Map<String, dynamic>>{};
    for (final c in citizens) {
      final snap = await c.get();
      citizensData[c.id] = (snap.data() as Map<String, dynamic>);
    }
    // Build lookup for familyId -> familyName
    final familiesCol = firestore.collection('families');
    final familiesSnap = await familiesCol.get();
    final familyNameById = <String, String>{};
    for (final doc in familiesSnap.docs) {
      final data = doc.data();
      familyNameById[doc.id] = (data['name'] as String?) ?? '-';
    }
    final occupants = <String, List<Map<String, dynamic>>>{};
    for (final c in citizensData.values) {
      final hid = c['houseId'] as String?;
      if (hid == null) continue;
      occupants.putIfAbsent(hid, () => []).add(c);
    }
    for (final h in houses) {
      final occ = occupants[h.id] ?? [];
      String headName = '-';
      String? headFamilyId;
      for (final c in occ) {
        if ((c['familyRole'] as String?) == 'Kepala Keluarga') {
          headName = (c['name'] as String?) ?? '-';
          headFamilyId = c['familyId'] as String?;
          break;
        }
      }
      if (headName == '-' && occ.isNotEmpty) {
        headName = (occ.first['name'] as String?) ?? '-';
      }
      // Jika tidak ada Kepala Keluarga tapi ada penghuni, tetap isi familyId dari penghuni pertama
      if (headFamilyId == null && occ.isNotEmpty) {
        headFamilyId = occ.first['familyId'] as String?;
      }
      final familyName = headFamilyId != null
          ? (familyNameById[headFamilyId] ?? '-')
          : null;
      batch.update(h, {
        'headName': headName,
        'status': occ.isEmpty ? 'Kosong' : 'Dihuni',
        if (headFamilyId != null) 'familyId': headFamilyId,
        if (familyName != null) 'familyName': familyName,
      });
    }
    await batch.commit();
  }
}
