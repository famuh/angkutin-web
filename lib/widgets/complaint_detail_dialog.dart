import 'package:admin_panel/constans/space.dart';
import 'package:admin_panel/constans/text.dart';
import 'package:admin_panel/services/complaint_service.dart';
import 'package:flutter/material.dart';

void complaintDetailDialog(
    BuildContext context,
    String docID,
    String title,
    String senderName,
    String senderEmail,
    String sendereRole,
    String description,
    bool status,
    String date) {
  final ComplaintService complaintService = ComplaintService();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: SizedBox(
            width: 500,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'From: $senderName, $sendereRole ',
                      style: subtitleNB,
                    ),
                    Text(date),
                  ],
                ),
                space1,
                space3,
                Text(description)
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Keluar')),
          TextButton(
              onPressed: () {
                complaintService.update(docID, status);
                Navigator.pop(context);
              },
              child: const Text('Selesai'))
        ],
      );
    },
  );
}
