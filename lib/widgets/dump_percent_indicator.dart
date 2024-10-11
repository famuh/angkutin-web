import 'package:admin_panel/services/dump_report_service.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class DumpPercentIndicator extends StatefulWidget {
  const DumpPercentIndicator({super.key});

  @override
  State<DumpPercentIndicator> createState() => _DumpPercentIndicatorState();
}

class _DumpPercentIndicatorState extends State<DumpPercentIndicator> {
  final DumpReportService _dumps = DumpReportService();

  Future<double> calculatePercentage() async {
    int done = await _dumps.getDataDone();
    int total = await _dumps.getDataCount();
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
            progressColor: Colors.green,
            backgroundColor: Colors.grey,
            circularStrokeCap: CircularStrokeCap.round,
          );
        }
      },
    );
  }
}
