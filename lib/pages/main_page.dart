import 'package:admin_panel/constans/color.dart';
import 'package:admin_panel/constans/space.dart';
import 'package:admin_panel/controllers/page_controller.dart';
import 'package:admin_panel/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/auth_service.dart';

class MainPage extends StatelessWidget {
  MainPage({
    super.key,
  });

  final PageSController pageController = Get.put(PageSController());
  final _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Row(
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(
              () => ListView(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/logos/logo.png',
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Image.asset(
                        'assets/images/angkutin.png',
                        height: 25,
                      ),
                    ],
                  ),
                  space5,
                  ListTile(
                    textColor: const Color(0xff9197B3),
                    iconColor: const Color(0xff9197B3),
                    hoverColor: secondary,
                    selectedColor: white,
                    selectedTileColor: primary,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    title: const Text('Dashboard'),
                    leading: const Icon(Icons.dashboard_rounded),
                    onTap: () {
                      pageController.index.value = 0;
                    },
                    selected: pageController.index.value == 0,
                  ),
                  space1,
                  ListTile(
                    textColor: const Color(0xff9197B3),
                    iconColor: const Color(0xff9197B3),
                    hoverColor: secondary,
                    selectedColor: white,
                    selectedTileColor: primary,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    title: const Text('Pelanggan'),
                    leading: const Icon(Icons.people_alt_rounded),
                    onTap: () {
                      pageController.index.value = 1;
                    },
                    selected: pageController.index.value == 1,
                  ),
                  space1,
                  ListTile(
                    textColor: const Color(0xff9197B3),
                    iconColor: const Color(0xff9197B3),
                    hoverColor: secondary,
                    selectedColor: white,
                    selectedTileColor: primary,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    title: const Text('Petugas'),
                    leading: const Icon(Icons.person_2_rounded),
                    onTap: () {
                      pageController.index.value = 2;
                    },
                    selected: pageController.index.value == 2,
                  ),
                  space1,
                  ListTile(
                    textColor: const Color(0xff9197B3),
                    iconColor: const Color(0xff9197B3),
                    hoverColor: secondary,
                    selectedColor: white,
                    selectedTileColor: primary,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    title: const Text('Data Pengangkutan'),
                    leading: const Icon(Icons.assistant_photo_outlined),
                    onTap: () {
                      pageController.index.value = 3;
                    },
                    selected: pageController.index.value == 3,
                  ),
                  space1,
                  ListTile(
                    textColor: const Color(0xff9197B3),
                    iconColor: const Color(0xff9197B3),
                    hoverColor: secondary,
                    selectedColor: white,
                    selectedTileColor: primary,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    title: const Text('Laporan Keluhan'),
                    leading: const Icon(Icons.report_gmailerrorred_rounded),
                    onTap: () {
                      pageController.index.value = 4;
                    },
                    selected: pageController.index.value == 4,
                  ),
                  ListTile(
                    textColor: const Color(0xff9197B3),
                    iconColor: const Color(0xff9197B3),
                    hoverColor: secondary,
                    selectedColor: white,
                    selectedTileColor: primary,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    title: const Text('Detail'),
                    leading: const Icon(Icons.assistant_photo_outlined),
                    onTap: () {
                      pageController.index.value = 3;
                    },
                    selected: pageController.index.value == 3,
                  ),
                  const SizedBox(
                    height: 330,
                  ),
                  ListTile(
                    hoverColor: secondary,
                    selectedColor: white,
                    selectedTileColor: primary,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    title: const Text(
                      'Keluar',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.redAccent),
                    ),
                    trailing: Icon(
                      Icons.logout,
                      color: Colors.red[600],
                    ),
                    onTap: () async {
                      await _auth.signout();
                      Get.offAllNamed(RouteName.login);
                    },
                  ),
                ],
              ),
            ),
          )),
          Expanded(
              flex: 5,
              child:
                  Obx(() => pageController.pages[pageController.index.value])),
        ],
      ),
    ));
  }
}
