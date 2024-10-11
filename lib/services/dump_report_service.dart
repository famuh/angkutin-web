import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class DumpReportService {
  final _dumpReport = FirebaseFirestore.instance.collection('requests');

  Stream<QuerySnapshot> readReport() {
    final data = _dumpReport
        .doc('report')
        .collection('items')
        .orderBy('isDone', descending: false)
        .snapshots();
    return data;
  }

  Stream<QuerySnapshot> readRequest() {
    final data = _dumpReport
        .doc('carbage')
        .collection('items')
        .orderBy('isDone', descending: false)
        .snapshots();
    return data;
  }

  Stream<QuerySnapshot> readDataNotDone() {
    final data = _dumpReport
        .doc('report')
        .collection('items')
        .where('isDone', isEqualTo: false)
        .snapshots();
    return data;
  }

  Future<int> getDataCount() async {
    QuerySnapshot querySnapshot =
        await _dumpReport.doc('report').collection('items').get();
    return querySnapshot.size;
  }

  Future<int> getDataDone() async {
    QuerySnapshot querySnapshot = await _dumpReport
        .doc('report')
        .collection('items')
        .where('isDone', isEqualTo: true)
        .get();
    return querySnapshot.size;
  }

  Future<int> getDataNotDone() async {
    QuerySnapshot querySnapshot = await _dumpReport
        .doc('report')
        .collection('items')
        .where('isDone', isEqualTo: false)
        .get();
    return querySnapshot.size;
  }

  Stream<QuerySnapshot> searchRequestReport(String query) {
    if (query.isEmpty) {
      return readReport();
    } else {
      return _dumpReport
          .doc('report')
          .collection('items')
          .where('name', isGreaterThanOrEqualTo: query.toLowerCase())
          .where('name', isLessThanOrEqualTo: '${query.toLowerCase()}\uf8ff')
          .snapshots();
    }
  }

  Stream<QuerySnapshot> searchCarbageRequest(String query) {
    if (query.isEmpty) {
      return readRequest();
    } else {
      return _dumpReport
          .doc('carbage')
          .collection('items')
          .where('name', isGreaterThanOrEqualTo: query.toLowerCase())
          .where('name', isLessThanOrEqualTo: '${query.toLowerCase()}\uf8ff')
          .snapshots();
    }
  }

  Future<void> assignReport(String docID, String idPetugas) async {
    try {
      await _dumpReport
          .doc('report')
          .collection('items')
          .doc(docID)
          .update({'idPetugas': idPetugas, 'isDelivered': true});
      log('Data berhasil diperbarui');
    } catch (e) {
      log('Terjadi kesalahan saat memperbarui data: $e');
    }
  }

  Future<void> deleteReport(String docID) async {
    try {
      await _dumpReport.doc('report').collection('items').doc(docID).delete();
    } catch (e) {
      log('Terjadi kesalahan saat menghapus data: $e');
    }
  }
}
