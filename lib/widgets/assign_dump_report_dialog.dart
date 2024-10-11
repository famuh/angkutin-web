import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constans/color.dart';
import '../constans/space.dart';
import '../services/dump_report_service.dart';
import '../services/employee_service.dart';
import 'show_images_dialog.dart';

void assignReport(
    BuildContext context,
    String docID,
    String senderName,
    String senderEmail,
    String description,
    bool isDone,
    bool isAcceptByDriver,
    bool isDelivered,
    String idPetugas,
    String zone,
    String imageUrl) {
  final DumpReportService dataReport = DumpReportService();
  final employeeService = EmployeeService();

  String selectedEmployee = '0';

  Widget statusText;
  switch (true) {
    case true:
      if (isDone) {
        statusText = Text(
          'Selesai',
          style: TextStyle(color: Colors.green[600]),
        );
      } else if (isAcceptByDriver) {
        statusText = Text(
          'Sudah diterima petugas',
          style: TextStyle(color: primary),
        );
      } else if (isDelivered) {
        statusText = Text(
          'Menunggu petugas',
          style: TextStyle(color: Colors.amber[600]),
        );
      } else {
        statusText = Text(
          'Perlu Dicek',
          style: TextStyle(color: Colors.red[600]),
        );
      }
      break;
    default:
      statusText = Text(
        'Perlu Dicek',
        style: TextStyle(color: Colors.red[600]),
      );
  }

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Tinjau laporan dari $senderName'),
        content: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  statusText,
                  if (isDelivered) Text('Ditugaskan kepada: $idPetugas'),
                  space2,
                  Row(
                    children: [
                      const Text('Nama'),
                      const SizedBox(width: 115),
                      Text(': $senderName')
                    ],
                  ),
                  space2,
                  Row(
                    children: [
                      const Text('Email'),
                      const SizedBox(width: 118),
                      Text(': $senderEmail')
                    ],
                  ),
                  space2,
                  Row(
                    children: [
                      const Text('Wilayah'),
                      const SizedBox(width: 105),
                      Text(': $zone')
                    ],
                  ),
                  space2,
                  Row(
                    children: [
                      const Text('Foto Timbunan'),
                      const SizedBox(width: 70),
                      TextButton(
                          onPressed: () {
                            showImage(context, imageUrl);
                          },
                          child: const Text('Lihat foto')),
                    ],
                  ),
                  space2,
                  const Text('Deskripsi Permohonan:'),
                  space2,
                  Text('  $description'),
                  const SizedBox(height: 20),
                  if (isDone == false && isDelivered == false)
                    StatefulBuilder(
                      builder: (context, setState) {
                        return StreamBuilder<QuerySnapshot>(
                          stream: employeeService.read(),
                          builder: (context, snapshot) {
                            List<DropdownMenuItem> employees = [];
                            if (!snapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              final employeeData =
                                  snapshot.data?.docs.where((employee) {
                                final employeeData =
                                    employee.data() as Map<String, dynamic>;
                                final employeeZone = employeeData['address'];
                                return zone == employeeZone;
                              }).toList();

                              employees.add(const DropdownMenuItem(
                                  value: '0',
                                  child: Text(
                                      'Pilih petugas di kecamatan yang sama')));
                              for (var employee in employeeData!) {
                                employees.add(DropdownMenuItem(
                                    value: employee.id,
                                    child: Text(employee['name'])));
                              }
                            }
                            return DropdownButton(
                              items: employees,
                              value: selectedEmployee,
                              onChanged: (value) {
                                setState(
                                  () {
                                    selectedEmployee = value;
                                    log(value);
                                  },
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Keluar'),
          ),
          if (isDone == false && isDelivered == false)
            TextButton(
              onPressed: () async {
                await dataReport.assignReport(docID, selectedEmployee);
                Get.back();
              },
              child: const Text('Pilih'),
            ),
        ],
      );
    },
  );
}
