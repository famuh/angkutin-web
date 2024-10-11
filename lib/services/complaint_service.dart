import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class ComplaintService {
  final _complaints = FirebaseFirestore.instance.collection('complaints');

  Stream<QuerySnapshot> read() {
    final data = _complaints.orderBy('isDone', descending: false).snapshots();
    return data;
  }

  Stream<QuerySnapshot> readDataNotDone() {
    final data = _complaints.where('isDone', isEqualTo: false).snapshots();
    return data;
  }

  Future<int> getDataCount() async {
    QuerySnapshot querySnapshot = await _complaints.get();
    return querySnapshot.size;
  }

  Future<int> getDataNotDone() async {
    QuerySnapshot querySnapshot =
        await _complaints.where('isDone', isEqualTo: false).get();
    return querySnapshot.size;
  }

  Future<int> getDataDone() async {
    QuerySnapshot querySnapshot =
        await _complaints.where('isDone', isEqualTo: true).get();
    return querySnapshot.size;
  }

  Future<void> update(String docID, bool status) async {
    try {
      await _complaints.doc(docID).update({'isDone': true});
    } catch (e) {
      log('Terjadi kesalahan saat memperbarui data: $e');
    }
  }

  Stream<QuerySnapshot> search(String query) {
    if (query.isEmpty) {
      return read();
    } else {
      return _complaints
          .where('senderName', isGreaterThanOrEqualTo: query.toLowerCase())
          .where('senderName',
              isLessThanOrEqualTo: '${query.toLowerCase()}\uf8ff')
          .snapshots();
    }
  }

  Future<void> delete(String docID) async {
    await _complaints.doc(docID).delete();
  }
}
