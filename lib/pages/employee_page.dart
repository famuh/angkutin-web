import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../components/buttons.dart';
import '../widgets/add_employee_dialog.dart';
import '../constans/color.dart';
import '../constans/space.dart';
import '../services/employee_service.dart';
import '../widgets/update_employee_dialog.dart';
import '../widgets/delete_employee_dialog.dart';

class EmployeePage extends StatefulWidget {
  const EmployeePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EmployeePageState createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  final _employeeData = EmployeeService();
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
          'Data Petugas',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
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
                                  hintText: 'Cari data petugas',
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
                SizedBox(
                    height: 41,
                    child: LargeButton(
                        onPressed: () => addDataDialog(context),
                        text: 'Daftarkan petugas baru'))
              ],
            ),
            space3,
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _employeeData.searchEmployee(_searchQuery),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    List<DocumentSnapshot> employeeDatas = snapshot.data!.docs;

                    return employeeDatas.isEmpty
                        ? const Center(child: Text('Data tidak ada'))
                        : Theme(
                            data: Theme.of(context).copyWith(
                                dataTableTheme: const DataTableThemeData(
                                    dividerThickness: 0.0)),
                            child: PaginatedDataTable(
                              rowsPerPage: employeeDatas.length > 10
                                  ? 10
                                  : employeeDatas.isEmpty
                                      ? 1
                                      : employeeDatas.length,
                              columns: const [
                                DataColumn(
                                    label: SizedBox(
                                  width: 20,
                                  child: Text(
                                    'No',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                )),
                                DataColumn(
                                    label: SizedBox(
                                  width: 200,
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
                                    'Email',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                )),
                                DataColumn(
                                    label: SizedBox(
                                  width: 200,
                                  child: Text(
                                    'Nomor Telepon',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                )),
                                DataColumn(
                                    label: SizedBox(
                                  width: 200,
                                  child: Text(
                                    'Zona',
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
                              source: _DataSource(
                                  employeeDatas, context, updateEmployeeDialog),
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
  _DataSource(this.employeeDatas, this.context, this.updateUserDialog);

  final List<DocumentSnapshot> employeeDatas;
  final BuildContext context;
  final Function(BuildContext, String, String, String, int, String)
      updateUserDialog;

  @override
  DataRow getRow(int index) {
    final document = employeeDatas[index];
    final datas = document.data() as Map<String, dynamic>;
    final docID = document.id;
    final employeeName = datas['name'];
    final employeeEmail = datas['email'];
    final employeeAddress = datas['address'];
    final employeePhone = datas['activePhoneNumber'] ?? 0;

    return DataRow(cells: [
      DataCell(Text((index + 1).toString())),
      DataCell(Text(employeeName)),
      DataCell(Text(employeeEmail)),
      DataCell(Text(employeePhone.toString())),
      DataCell(Text(employeeAddress)),
      DataCell(Row(
        children: [
          IconButton(
              onPressed: () {
                updateUserDialog(context, docID, employeeName, employeeEmail,
                    employeePhone, employeeAddress);
              },
              icon: const Icon(Icons.edit)),
          IconButton(
              onPressed: () {
                employeeDeleteConfirm(context, docID);
              },
              icon: const Icon(Icons.delete)),
        ],
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => employeeDatas.length;

  @override
  int get selectedRowCount => 0;
}
