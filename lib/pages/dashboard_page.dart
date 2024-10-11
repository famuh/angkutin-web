import 'package:admin_panel/widgets/live_clock.dart';
import 'package:flutter/material.dart';

import '../constans/space.dart';
import '../widgets/active_employees.dart';
import '../widgets/quick_overview.dart';
import '../widgets/complaint_preview.dart';
import '../widgets/dumps_preview.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Dashboard'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Expanded(child: QuickOverview()),
                    Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            Expanded(child: DumpsPreview()),
                            space2,
                            Expanded(child: ComplaintPreview()),
                          ],
                        ))
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: ActiveEmployees(),
                    ),
                    space2,
                    const Expanded(
                      child: LiveClock(),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
