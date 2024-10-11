import 'package:admin_panel/pages/complaint_page.dart';
import 'package:admin_panel/pages/detal.dart';
import 'package:admin_panel/pages/main_page.dart';
import 'package:get/get.dart';

import '../pages/customer_page.dart';
import '../pages/dashboard_page.dart';
import '../pages/dump_report_page.dart';
import '../pages/employee_page.dart';
import '../pages/login_page.dart';

abstract class RouteName {
  static const login = '/login';
  static const home = '/aplication';
  static const dashboard = '/dashboard';
  static const customer = '/customer';
  static const employee = '/employee';
  static const dumpReport = '/dumpReport';
  static const complaint = '/complaint';
  static const detail = '/detail';
}

class AppPage {
  static final pages = [
    GetPage(
      name: RouteName.home,
      page: () => MainPage(),
    ),
    GetPage(
      name: RouteName.login,
      page: () => const LoginPage(),
    ),
    GetPage(
      name: RouteName.dashboard,
      page: () => const DashboardPage(),
    ),
    GetPage(
      name: RouteName.customer,
      page: () => const CustomerPage(),
    ),
    GetPage(
      name: RouteName.employee,
      page: () => const EmployeePage(),
    ),
    GetPage(
      name: RouteName.dumpReport,
      page: () => const DumpReportPage(),
    ),
    GetPage(
      name: RouteName.complaint,
      page: () => const ComplaintPage(),
    ),
    GetPage(
      name: RouteName.complaint,
      page: () => const DetailPage(),
    ),
  ];
}
