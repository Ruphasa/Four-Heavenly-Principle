class House {
  final String? documentId;
  final String address;
  final String rt;
  final String rw;
  final String headName;
  final String status;

  const House({
    this.documentId,
    required this.address,
    required this.rt,
    required this.rw,
    required this.headName,
    required this.status,
  });

  factory House.fromMap(Map<String, dynamic> map) {
    return House(
      documentId: map['_docId'] as String?,
      address: (map['address'] ?? '-') as String,
      rt: (map['rt'] ?? '01') as String,
      rw: (map['rw'] ?? '01') as String,
      headName: (map['headName'] ?? map['kepalaKeluarga'] ?? '-') as String,
      status: (map['status'] ?? 'Dihuni') as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'rt': rt,
      'rw': rw,
      'headName': headName,
      'status': status,
    };
  }
}
