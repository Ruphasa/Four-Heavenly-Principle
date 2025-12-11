import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterService {
  RegisterService();
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  Future<void> registerUser({
    required String email,
    required String password,
    required String name,
    required String nik,
    required String phone,
    required String birthPlace,
    required String birthDate,
    required String gender,
    required String address,
    String? selectedHouseAddress,
    required String ownershipStatus,
  }) async {
    try {
      // 1. Create Firebase Auth user
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final uid = userCredential.user!.uid;
      
      // 2. Create user document in Firestore (status: Menunggu)
      await _firestore.collection('users').doc(uid).set({
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
        'status': 'Menunggu', // Pending approval
        'createdAt': FieldValue.serverTimestamp(),
      });
      
      // 3. Handle house - either find existing or create new
      String? houseId;
      
      if (selectedHouseAddress != null && selectedHouseAddress.isNotEmpty) {
        // Find existing house by address
        final houseQuery = await _firestore
            .collection('houses')
            .where('address', isEqualTo: selectedHouseAddress)
            .limit(1)
            .get();
        
        if (houseQuery.docs.isNotEmpty) {
          houseId = houseQuery.docs.first.id;
        }
      } else if (address.isNotEmpty) {
        // Create new house
        final newHouseDoc = await _firestore.collection('houses').add({
          'address': address,
          'rt': '01', // Default RT
          'rw': '01', // Default RW
          'headName': name, // New homeowner
          'status': 'Dihuni',
          'createdAt': FieldValue.serverTimestamp(),
        });
        houseId = newHouseDoc.id;
      }
      
      // 4. Create citizen document (linked to user via userId)
      await _firestore.collection('citizens').add({
        'userId': uid,
        'nik': nik,
        'gender': gender,
        'birthDate': birthDate,
        'birthPlace': birthPlace,
        'familyRole': 'Kepala Keluarga', // Default role for new registration
        'maritalStatus': 'Belum Kawin', // Default
        'religion': 'Islam', // Default
        'education': '-',
        'occupation': '-',
        'status': 'Aktif',
        'familyName': '-', // Will be updated when assigned to family
        if (houseId != null) 'houseId': houseId,
        'ownershipStatus': ownershipStatus,
        'createdAt': FieldValue.serverTimestamp(),
      });
      
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw 'Password terlalu lemah. Gunakan minimal 6 karakter.';
      } else if (e.code == 'email-already-in-use') {
        throw 'Email sudah terdaftar. Silakan gunakan email lain.';
      } else if (e.code == 'invalid-email') {
        throw 'Format email tidak valid.';
      } else {
        throw 'Registrasi gagal: ${e.message}';
      }
    } catch (e) {
      throw 'Terjadi kesalahan: $e';
    }
  }
  
  Future<void> refresh() async {}
}
