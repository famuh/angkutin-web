import 'package:admin_panel/constans/color.dart';
import 'package:admin_panel/constans/space.dart';
import 'package:admin_panel/constans/text.dart';
import 'package:admin_panel/services/employee_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ActiveEmployees extends StatelessWidget {
  ActiveEmployees({
    super.key,
  });

  final EmployeeService _employeeService = EmployeeService();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Container(
        decoration: BoxDecoration(
            color: white, borderRadius: BorderRadius.circular(8.0)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Petugas Aktif',
                style: subtitleBB,
              ),
              space1,
              const Text(
                'Daftar petugas yang sedang bertugas',
                style: TextStyle(color: Colors.blueGrey, fontSize: 14),
              ),
              space2,
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _employeeService.readDaily(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                          child: Text('No active employees found.'));
                    }

                    final employees = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: employees.length,
                      itemBuilder: (context, index) {
                        final employee = employees[index];
                        final employeeData =
                            employee.data() as Map<String, dynamic>;
                        final employeeName = employeeData['name'] ?? '-';

                        return ListTile(
                          leading: const Icon(Icons.boy_rounded),
                          tileColor: Colors.white,
                          title: Text(employeeName),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
