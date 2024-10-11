import 'dart:developer';

import 'package:admin_panel/widgets/assign_dump_report_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '../constans/color.dart';
import '../constans/space.dart';
import '../services/dump_report_service.dart';

class DumpReportTable extends StatefulWidget {
  const DumpReportTable({super.key});

  @override
  State<DumpReportTable> createState() => _DumpReportTableState();
}

class _DumpReportTableState extends State<DumpReportTable> {
  final _dumpReportData = DumpReportService();
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
      body: _requestReport(),
    );
  }

  Widget _requestReport() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: white, borderRadius: BorderRadius.circular(8.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: SizedBox(
                        height: 42,
                        width: 200,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                                iconColor: Colors.black26,
                                hintText: 'Cari data Laporan',
                                border: InputBorder.none),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: const Center(
                          child: Icon(
                        Icons.search,
                        color: Colors.black26,
                      )),
                    ),
                  ],
                ),
              ),
            ],
          ),
          space3,
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _dumpReportData.searchRequestReport(_searchQuery),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  List<DocumentSnapshot> dumpReportDatas = snapshot.data!.docs;

                  return dumpReportDatas.isEmpty
                      ? const Center(
                          child: Text('Data tidak ditemukan'),
                        )
                      : PaginatedDataTable(
                          rowsPerPage: dumpReportDatas.length > 8
                              ? 8
                              : dumpReportDatas.length,
                          columns: const [
                            DataColumn(
                                label: SizedBox(
                              width: 20,
                              child: Text(
                                'No',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )),
                            DataColumn(
                                label: SizedBox(
                              width: 100,
                              child: Text(
                                'Nama Pelapor',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )),
                            DataColumn(
                                label: SizedBox(
                              width: 150,
                              child: Text(
                                'Deskripsi',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )),
                            DataColumn(
                                label: SizedBox(
                              width: 60,
                              child: Text(
                                'Biaya',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )),
                            DataColumn(
                                label: SizedBox(
                              width: 150,
                              child: Text(
                                'Tanggal Pengajuan',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )),
                            DataColumn(
                                label: SizedBox(
                              width: 150,
                              child: Text(
                                'Status',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )),
                            DataColumn(
                                label: SizedBox(
                              width: 150,
                              child: Text(
                                'Paratinjau',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )),
                          ],
                          source: _ReportRequestDataTableSourcer(
                              dumpReportDatas, context),
                        );
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  log('${snapshot.error}');
                  return const Center(child: Text('Data tidak ada'));
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportRequestDataTableSourcer extends DataTableSource {
  _ReportRequestDataTableSourcer(this.dumpReportDatas, this.context);

  final List<DocumentSnapshot> dumpReportDatas;
  final BuildContext context;

  @override
  DataRow getRow(int index) {
    final document = dumpReportDatas[index];
    final datas = document.data() as Map<String, dynamic>;
    final docID = document.id;
    final name = datas['name'] ?? '-';
    final email = datas['senderEmail'] ?? '-';
    final description = datas['description'] ?? '-';
    final orderCost = datas['biayaPengangkutan'] ?? 0;
    final orderImage = datas['imageUrl'];

    final Timestamp orderDateTimestamp = datas['date'] ?? '-';
    final DateTime orderDate = orderDateTimestamp.toDate();
    final String formattedDate =
        DateFormat('kk:mm a - MMMM d, yyyy').format(orderDate);

    final isDone = datas['isDone'] ?? false;
    final isAcceptByDriver = datas['isAcceptByDriver'] ?? false;
    final isDelivered = datas['isDelivered'] ?? false;
    final zone = datas['wilayah'];
    final driverAssigned = datas['idPetugas'] ?? '-';

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

    return DataRow(cells: [
      DataCell(Text((index + 1).toString())),
      DataCell(Text(name)),
      DataCell(Text(
        description.length > 20
            ? description.substring(0, 20) + '...'
            : description,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      )),
      DataCell(Text(orderCost.toString())),
      DataCell(Text(formattedDate)),
      DataCell(statusText),
      DataCell(OutlinedButton(
        onPressed: () {
          assignReport(context, docID, name, email, description, isDone,
              isAcceptByDriver, isDelivered, driverAssigned, zone, orderImage);
          log(orderImage);
        },
        child: const Text('Pratinjau'),
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => dumpReportDatas.length;

  @override
  int get selectedRowCount => 0;
}
