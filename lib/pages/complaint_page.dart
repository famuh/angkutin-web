import 'dart:developer';

import 'package:admin_panel/widgets/complaint_detail_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/complaint_service.dart';

import '../constans/color.dart';
import '../constans/space.dart';
import '../widgets/update_employee_dialog.dart';

class ComplaintPage extends StatefulWidget {
  const ComplaintPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ComplaintPageState createState() => _ComplaintPageState();
}

class _ComplaintPageState extends State<ComplaintPage> {
  final _complaints = ComplaintService();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Data Komplain',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: white, borderRadius: BorderRadius.circular(8.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: const Center(
                        child: Icon(
                      Icons.search,
                      color: Colors.black26,
                    )),
                  ),
                  SizedBox(
                    height: 42,
                    width: 200,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                            iconColor: Colors.black26,
                            hintText: 'Cari data komplain',
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            space3,
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _complaints.search(_searchQuery),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    List<DocumentSnapshot> complaintDatas = snapshot.data!.docs;

                    return complaintDatas.isEmpty
                        ? const Center(child: Text('Data tidak ada'))
                        : Theme(
                            data: Theme.of(context).copyWith(
                                dataTableTheme: const DataTableThemeData(
                                    dividerThickness: 0.0)),
                            child: PaginatedDataTable(
                              rowsPerPage: complaintDatas.length > 10
                                  ? 10
                                  : complaintDatas.isEmpty
                                      ? 1
                                      : complaintDatas.length,
                              columns: const [
                                DataColumn(
                                    label: SizedBox(
                                  width: 150,
                                  child: Text(
                                    'Nama',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                )),
                                DataColumn(
                                    label: SizedBox(
                                  width: 200,
                                  child: Text(
                                    'Judul',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                )),
                                DataColumn(
                                    label: SizedBox(
                                  width: 100,
                                  child: Text(
                                    'Role',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                )),
                                DataColumn(
                                    label: SizedBox(
                                  width: 200,
                                  child: Text(
                                    'Tanggal Dibuat',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                )),
                                DataColumn(
                                    label: SizedBox(
                                  width: 150,
                                  child: Text(
                                    'Status',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                )),
                                DataColumn(
                                    label: SizedBox(
                                  width: 80,
                                  child: Text(
                                    'Aksi',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                )),
                              ],
                              source: _DataSource(complaintDatas, context,
                                  updateEmployeeDialog),
                            ),
                          );
                  } else if (snapshot.hasError) {
                    log('${snapshot.error}');
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DataSource extends DataTableSource {
  _DataSource(this.complaintDatas, this.context, this.dialog);

  final List<DocumentSnapshot> complaintDatas;
  final BuildContext context;
  final Function(BuildContext, String, String, String, int, String) dialog;

  @override
  DataRow getRow(int index) {
    final document = complaintDatas[index];
    final docID = document.id;
    final datas = document.data() as Map<String, dynamic>;
    final complaintTitle = datas['title'] ?? '-';
    final senderName = datas['senderName'] ?? '-';
    final senderEmail = datas['senderEmail'] ?? '-';
    final senderRole = datas['role'] ?? '-';
    final description = datas['description'] ?? '-';
    final isDone = datas['isDone'] ?? false;

    String status = 'Perlu ditinjau';
    if (isDone) {
      status = 'Selesai';
    }

    final Timestamp complaintTimestamp = datas['time'];
    final DateTime complaintDate = complaintTimestamp.toDate();
    final String formattedDate =
        DateFormat('kk:mm a - MMMM d, yyyy').format(complaintDate);

    return DataRow(cells: [
      DataCell(Text(senderName)),
      DataCell(Text(complaintTitle)),
      DataCell(Text(senderRole)),
      DataCell(Text(formattedDate)),
      DataCell(Text(status)),
      DataCell(Row(
        children: [
          TextButton(
              onPressed: () {
                complaintDetailDialog(
                  context,
                  docID,
                  complaintTitle,
                  senderName,
                  senderEmail,
                  senderRole,
                  description,
                  isDone,
                  formattedDate,
                );
              },
              child: const Text('Lihat')),
        ],
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => complaintDatas.length;

  @override
  int get selectedRowCount => 0;
}
