import 'package:admin_panel/services/dump_report_service.dart';
import 'package:admin_panel/widgets/dump_percent_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constans/color.dart';
import '../constans/space.dart';
import '../constans/text.dart';

class DumpsPreview extends StatelessWidget {
  DumpsPreview({
    super.key,
  });

  final DumpReportService dumpReportService = DumpReportService();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
            color: white, borderRadius: BorderRadius.circular(8.0)),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Jumlah laporan selesai'),
                  space2,
                  const DumpPercentIndicator(),
                  space2,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [dataDone(), dataCount()],
                  ),
                  space1,
                  const Text(
                    'Segera cek laporan timbunan!',
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 30.0),
              child: VerticalDivider(),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Beberapa laporan timbunan yang belum ditinjau',
                      style: subtitleNB,
                    ),
                    space1,
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: dumpReportService.readDataNotDone(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return const Center(
                                child: Text(
                                    'Horee! tidak ada keluhan yang belum ditinjau'));
                          }

                          final dumps = snapshot.data!.docs;

                          if (dumps.isEmpty) {
                            return const Center(
                              child: Text('Tidak ada keluhan!'),
                            );
                          } else {
                            return ListView.builder(
                              itemCount: dumps.length > 3 ? 3 : dumps.length,
                              itemBuilder: (context, index) {
                                final commplanint = dumps[index];
                                final commplaintData =
                                    commplanint.data() as Map<String, dynamic>;
                                final commplanintZone =
                                    commplaintData['wilayah'] ?? '-';
                                final senderName =
                                    commplaintData['name'] ?? '-';

                                final Timestamp complaintTimeStamp =
                                    commplaintData['date'];
                                final DateTime complaintDate =
                                    complaintTimeStamp.toDate();
                                final String formattedDate =
                                    DateFormat('d MMMM, yyyy kk:mm a')
                                        .format(complaintDate);

                                return ListTile(
                                  tileColor: Colors.white,
                                  title: Text(senderName),
                                  subtitle: Text('Wilayah: $commplanintZone'),
                                  trailing: Text(formattedDate),
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  FutureBuilder<int> dataDone() {
    return FutureBuilder(
      future: dumpReportService.getDataDone(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          int count = snapshot.data ?? 0;
          return Text(
            '$count',
            style: subtitleNB,
          );
        }
      },
    );
  }

  FutureBuilder<int> dataCount() {
    return FutureBuilder(
      future: dumpReportService.getDataCount(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          int count = snapshot.data ?? 0;
          return Text('/$count', style: subtitleNB);
        }
      },
    );
  }
}
