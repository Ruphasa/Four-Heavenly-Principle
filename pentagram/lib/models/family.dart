class Family {
  final String? documentId;
  final String name;
  final String headOfFamily;
  final String? headCitizenId; // relation to citizens
  final int memberCount;
  final String address;

  Family({
    this.documentId,
    required this.name,
    required this.headOfFamily,
    this.headCitizenId,
    required this.memberCount,
    required this.address,
  });

  factory Family.fromMap(Map<String, dynamic> map) {
    return Family(
      documentId: map['_docId'] as String?,
      name: (map['name'] ?? map['namaKeluarga'] ?? '-') as String,
      headOfFamily: (map['headOfFamily'] ?? map['kepalaKeluarga'] ?? '-') as String,
      headCitizenId: map['headCitizenId'] as String?,
      memberCount: ((map['memberCount'] ?? map['jumlahAnggota'] ?? 0) as num).toInt(),
      address: (map['address'] ?? map['alamat'] ?? '-') as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'headOfFamily': headOfFamily,
      'headCitizenId': headCitizenId,
      'memberCount': memberCount,
      'address': address,
    };
  }
}
