import 'package:admin_panel/pages/detal.dart';
import 'package:get/get.dart';

import '../pages/complaint_page.dart';
import '../pages/customer_page.dart';
import '../pages/dashboard_page.dart';
import '../pages/dump_report_page.dart';
import '../pages/employee_page.dart';
import '../routes/app_routes.dart';

class PageSController extends GetxController {
  RxInt index = 0.obs;
  RxInt pagesIndex = 0.obs;

  final pagesRoute = [
    RouteName.dashboard,
    RouteName.customer,
    RouteName.employee,
    RouteName.dumpReport,
    RouteName.complaint,
    RouteName.detail
  ];

  final pages = [
    const DashboardPage(),
    const CustomerPage(),
    const EmployeePage(),
    const DumpReportPage(),
    const ComplaintPage(),
    const DetailPage()
  ];
}
