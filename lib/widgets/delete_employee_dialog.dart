import 'package:flutter/material.dart';

import '../services/employee_service.dart';

void employeeDeleteConfirm(
  BuildContext context,
  String docID,
) {
  final EmployeeService employeeService = EmployeeService();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Konfirmasi Penghapusan'),
        content: const Text('Apakah Anda yakin ingin menghapus data ini?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await employeeService.delete(docID);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Hapus'),
          ),
        ],
      );
    },
  );
}
