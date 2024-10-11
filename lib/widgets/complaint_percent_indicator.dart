import 'package:admin_panel/constans/color.dart';
import 'package:admin_panel/services/complaint_service.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ComplaintPercentage extends StatefulWidget {
  const ComplaintPercentage({super.key});

  @override
  State<ComplaintPercentage> createState() => _ComplaintPercentageState();
}

class _ComplaintPercentageState extends State<ComplaintPercentage> {
  final ComplaintService _complaints = ComplaintService();

  Future<double> calculatePercentage() async {
    int done = await _complaints.getDataDone();
    int total = await _complaints.getDataCount();
    if (total == 0) return 0.0;
    return done / total;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<double>(
      future: calculatePercentage(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          double percentage = snapshot.data ?? 0.0;
          return CircularPercentIndicator(
            radius: 50.0,
            lineWidth: 10.0,
            percent: percentage,
            center: Text('${(percentage * 100).toStringAsFixed(1)}%'),
            progressColor: primary,
            backgroundColor: Colors.grey,
            circularStrokeCap: CircularStrokeCap.round,
          );
        }
      },
    );
  }
}
