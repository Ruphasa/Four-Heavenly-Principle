class AppUser {
  final String? documentId;
  final String name;
  final String email;
  final String status;

  const AppUser({this.documentId, required this.name, required this.email, required this.status});

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      documentId: map['_docId'] as String?,
      name: (map['name'] ?? '-') as String,
      email: (map['email'] ?? '-') as String,
      status: (map['status'] ?? 'Menunggu') as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'status': status,
    };
  }
}
