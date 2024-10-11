import 'dart:developer';

import 'package:admin_panel/routes/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthService extends GetxService {
  final _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        log('  $user already login');
        Get.offAllNamed(RouteName.login);
      } else {
        log('  $user already logout');
        Get.offAllNamed(RouteName.home);
      }
    });
  }

  Future<User?> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      log('berhasil masuk');
      return cred.user;
    } catch (e) {
      log('Samtingwong: $e');
    }
    return null;
  }

  Future<void> signout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      log('Samtingwong');
    }
  }
}
