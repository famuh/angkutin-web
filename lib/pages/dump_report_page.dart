import 'package:flutter/material.dart';
import '../widgets/carbage_request_table.dart';
import '../widgets/dump_report_table.dart';

class DumpReportPage extends StatelessWidget {
  const DumpReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            bottom: const 
            TabBar(
              tabs: [
                Tab(text: "Laporan Timbunan"),
                Tab(text: "Riwayat Permohonan"),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              DumpReportTable(),
              CarbageTable(),
            ],
          ),
        ),
      );
    
  }
}
