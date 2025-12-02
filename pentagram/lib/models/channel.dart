class Channel {
  final String? documentId;
  final String name;
  final String type;
  final String accountName;
  final String? thumbnail;

  const Channel({this.documentId, required this.name, required this.type, required this.accountName, this.thumbnail});

  factory Channel.fromMap(Map<String, dynamic> map) {
    return Channel(
      documentId: map['_docId'] as String?,
      name: (map['name'] ?? '-') as String,
      type: (map['type'] ?? '-') as String,
      accountName: (map['accountName'] ?? '-') as String,
      thumbnail: map['thumbnail'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'accountName': accountName,
      if (thumbnail != null) 'thumbnail': thumbnail,
    };
  }
}
