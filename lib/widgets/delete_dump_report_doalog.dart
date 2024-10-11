import 'package:admin_panel/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/dump_report_service.dart';

void dumpReportDeleteDialog(
  BuildContext context,
  String docID,
) {
  final DumpReportService dataReport = DumpReportService();

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
              await dataReport.deleteReport(docID);
              Get.offAndToNamed(RouteName.home);
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
