import 'package:admin_panel/constans/color.dart';
import 'package:admin_panel/constans/space.dart';
import 'package:admin_panel/constans/text.dart';
import 'package:admin_panel/services/customer_service.dart';
import 'package:admin_panel/services/employee_service.dart';
import 'package:flutter/material.dart';

class QuickOverview extends StatelessWidget {
  QuickOverview({
    super.key,
  });

  final EmployeeService _employeeData = EmployeeService();
  final CustomerService _customerData = CustomerService();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 0, 16.0),
            child: Container(
              decoration: BoxDecoration(
                  color: white, borderRadius: BorderRadius.circular(8.0)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Pelanggan',
                      style: bodyNB,
                    ),
                    space2,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Icon(
                          Icons.people_alt_rounded,
                          size: 30,
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        FutureBuilder(
                          future: _customerData.getDataCount(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return Text('${snapshot.data}',
                                  style: const TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold));
                            }
                          },
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Text(
                          'Orang',
                          style: bodyNB,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8.0)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Petugas',
                    style: bodyNB,
                  ),
                  space2,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Icon(
                        Icons.person_2_rounded,
                        size: 30,
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      FutureBuilder(
                        future: _employeeData.getDataCount(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return Text('${snapshot.data}',
                                style: const TextStyle(
                                    fontSize: 26, fontWeight: FontWeight.bold));
                          }
                        },
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Text(
                        'Orang',
                        style: bodyNB,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ))
      ],
    );
  }
}
