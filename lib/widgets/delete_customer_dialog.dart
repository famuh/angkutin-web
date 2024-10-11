import 'package:admin_panel/services/customer_service.dart';
import 'package:flutter/material.dart';

void customerDeleteConfirm(
  BuildContext context,
  String docID,
) {
  final CustomerService customerService = CustomerService();

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
              await customerService.delete(docID);
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
