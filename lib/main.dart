import 'package:admin_panel/pages/main_page.dart';
import 'package:admin_panel/routes/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDQBXEneGgeKdM2i5MjuuWIkcmrzR-QwYQ",
          authDomain: "angkutin-7fc40.firebaseapp.com",
          databaseURL:
              "https://angkutin-7fc40-default-rtdb.asia-southeast1.firebasedatabase.app",
          projectId: "angkutin-7fc40",
          storageBucket: "angkutin-7fc40.appspot.com",
          messagingSenderId: "185926635205",
          appId: "1:185926635205:web:c112d0fddf5da91b472aac",
          measurementId: "G-7QYN063LX3"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Admin Angkutin',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      initialRoute: RouteName.login,
      getPages: AppPage.pages,
      home: MainPage(),
    );
  }
}
