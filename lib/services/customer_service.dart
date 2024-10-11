import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerService {
  final _customers = FirebaseFirestore.instance.collection('users');

  Stream<QuerySnapshot> read() {
    final data = _customers.where('role', isEqualTo: 'Masyarakat').snapshots();
    return data;
  }

  Future<int> getDataCount() async {
    QuerySnapshot querySnapshot =
        await _customers.where('role', isEqualTo: 'Masyarakat').get();
    return querySnapshot.size;
  }

  Future<void> update(
      String docID, String name, String email, int phone) async {
    try {
      await _customers.doc(docID).update({
        'name': name,
        'email': email,
        'activePhoneNumber': phone,
      });
      log('Data berhasil diperbarui');
    } catch (e) {
      log('Terjadi kesalahan saat memperbarui data: $e');
    }
  }

  Future<void> delete(String docID) async {
    try {
      await _customers.doc(docID).delete();
      log('data berhasil dihapus');
    } catch (e) {
      log('Terjadi kesalahan saat memperbarui data: $e');
    }
  }

  Stream<QuerySnapshot> search(String query) {
    if (query.isEmpty) {
      return read();
    } else {
      return _customers
          .where('name', isGreaterThanOrEqualTo: query.toLowerCase())
          .where('name', isLessThanOrEqualTo: '${query.toLowerCase()}\uf8ff')
          .snapshots();
    }
  }
}
