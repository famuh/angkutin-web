import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

// import '../model/employee_model.dart';

class EmployeeService {
  final _employees = FirebaseFirestore.instance.collection('users');

  Stream<QuerySnapshot> read() {
    final data = _employees.where('role', isEqualTo: 'Petugas').snapshots();
    return data;
  }

  Future<int> getDataCount() async {
    QuerySnapshot querySnapshot =
        await _employees.where('role', isEqualTo: 'Petugas').get();
    return querySnapshot.size;
  }

  Stream<QuerySnapshot> readDaily() {
    final data = _employees
        .where('role', isEqualTo: 'Petugas')
        .where('isDaily', isEqualTo: true)
        .snapshots();
    return data;
  }

  // Stream<List<Employee>> fetchEmployees() {
  //   return _employeesData.snapshots().map((snapshot) {
  //     return snapshot.docs.map((doc) => Employee.fromMap(doc.data())).toList();
  //   });
  // }

  Future<void> update(String docID, String name, String email, int phone,
      String address) async {
    try {
      await _employees.doc(docID).update({
        'name': name,
        'email': email,
        'activePhoneNumber': phone,
        'address': address
      });
      log('Data berhasil diperbarui');
    } catch (e) {
      log('Terjadi kesalahan saat memperbarui data: $e');
    }
  }

  Future<void> delete(String docID) async {
    try {
      await _employees.doc(docID).delete();
      log('data berhasil dihapus');
    } catch (e) {
      log('Terjadi kesalahan saat menghapus data: $e');
    }
  }

  Stream<QuerySnapshot> searchEmployee(String query) {
    if (query.isEmpty) {
      return read();
    } else {
      return _employees
          .where('role', isEqualTo: 'Petugas')
          .where('name', isGreaterThanOrEqualTo: query.toLowerCase())
          .where('name', isLessThanOrEqualTo: '${query.toLowerCase()}\uf8ff')
          .snapshots();
    }
  }

  // untuk penugasan laporan

  // final _employees = FirebaseFirestore.instance.collection('users');

  // final _employeesData = FirebaseFirestore.instance
  //     .collection('users')
  //     .where('role', isEqualTo: 'Petugas');

  // Stream<QuerySnapshot> read() {
  //   final data = _employees.where('role', isEqualTo: 'Petugas').snapshots();
  //   return data;
  // }

  // Stream<List<Employee>> fetchEmployees() {
  //   return _employeesData.snapshots().map((snapshot) {
  //     return snapshot.docs.map((doc) => Employee.fromMap(doc.data())).toList();
  //   });
  // }
  // Stream<List<Employee>> getEmployeesZoneBased(String zone) {
  //   final data = _employees
  //       .where('role', whereIn: ['Petugas', 'petugas'])
  //       .where('address', isEqualTo: zone)
  //       .snapshots();

  //   return data.map((snapshot) {
  //     return snapshot.docs.map((doc) {
  //       return Employee.fromMap(doc.data() as Map<String, dynamic>);
  //     }).toList();
  //   });
  // }
  //  Stream<List<Employee>> getEmployeesZoneBased(String zone) {
  //   return _employeesData
  //       .where('zone', isEqualTo: zone)
  //       .snapshots()
  //       .map((snapshot) {
  //     return snapshot.docs.map((doc) {
  //       return Employee.fromDocument(doc);
  //     }).toList();
  //   });
  // }
}
