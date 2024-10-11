import 'package:admin_panel/constans/color.dart';
import 'package:admin_panel/constans/space.dart';
import 'package:admin_panel/constans/text.dart';
import 'package:admin_panel/services/complaint_service.dart';
import 'package:admin_panel/widgets/complaint_percent_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ComplaintPreview extends StatelessWidget {
  ComplaintPreview({
    super.key,
  });

  final ComplaintService complaintService = ComplaintService();

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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Jumlah keluhan selesai'),
                    space2,
                    const ComplaintPercentage(),
                    space2,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [dataDone(), dataCount()],
                    ),
                    space1,
                    const Text(
                      'Segera cek data keluhan!',
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
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
                      'Beberapa keluhan yang belum ditinjau',
                      style: subtitleNB,
                    ),
                    space1,
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: complaintService.readDataNotDone(),
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
                                    'Horee! tidak ada keluhan yang belum ditinjau '));
                          }

                          final complaints = snapshot.data!.docs;

                          if (complaints.isEmpty) {
                            return const Center(
                              child: Text('Tidak ada keluhan!'),
                            );
                          } else {
                            return ListView.builder(
                              itemCount:
                                  complaints.length > 3 ? 3 : complaints.length,
                              itemBuilder: (context, index) {
                                final commplanint = complaints[index];
                                final commplaintData =
                                    commplanint.data() as Map<String, dynamic>;
                                final commplanintTitle =
                                    commplaintData['title'] ?? '-';
                                final senderName =
                                    commplaintData['senderName'] ?? '-';

                                final Timestamp complaintTimeStamp =
                                    commplaintData['time'];
                                final DateTime complaintDate =
                                    complaintTimeStamp.toDate();
                                final String formattedDate =
                                    DateFormat('kk:mm a - MMMM d, yyyy')
                                        .format(complaintDate);

                                return ListTile(
                                  tileColor: Colors.white,
                                  title: Text(commplanintTitle),
                                  subtitle: Text('Dikirim oleh: $senderName'),
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
      future: complaintService.getDataDone(),
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
      future: complaintService.getDataCount(),
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
