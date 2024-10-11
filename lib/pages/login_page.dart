import 'dart:developer';

import 'package:admin_panel/routes/app_routes.dart';
import 'package:admin_panel/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/buttons.dart';
import '../components/custom_text_form_field.dart';
import '../constans/space.dart';
import '../constans/text.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = AuthService();

  final _formKey = GlobalKey<FormState>();

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  String? emailErrorText;
  String? passwordErrorText;

  User? user;

  @override
  void dispose() {
    super.dispose();
    email.dispose();
    password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 500,
          height: 600,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logos/logo.png',
                    width: 44,
                    height: 71,
                  ),
                  const SizedBox(
                    width: 22.0,
                  ),
                  Image.asset(
                    'assets/images/angkutin.png',
                    width: 172,
                    height: 42,
                  ),
                ],
              ),
              space2,
              Text(
                'Atur semua masalah persampahan',
                style: bodyNB,
              ),
              space2,
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextFormField(
                      title: 'Email',
                      controller: email,
                      hintText: 'Masukan email anda',
                      emailErrorText: emailErrorText,
                    ),
                    space1,
                    CustomTextFormField(
                      title: 'Password',
                      controller: password,
                      obscureText: true,
                      hintText: 'Masukan password anda',
                      emailErrorText: emailErrorText,
                    ),
                  ],
                ),
              ),
              space3,
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 48,
                child: LargeButton(
                  onPressed: () async {
                    await _login();
                  },
                  text: 'Masuk',
                ),
              ),
              space3,
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Lupa passwordnya?',
                    style: bodyNB,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Hubungi developer',
                      style: bodyNP,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<User?> _login() async {
    setState(() {
      emailErrorText = null;
      passwordErrorText = null;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const LoadingDialog();
      },
    );

    try {
      final user =
          await _auth.loginUserWithEmailAndPassword(email.text, password.text);

      Navigator.of(context).pop(); // Close the loading dialog

      if (user != null) {
        log('Masokkk');

        Get.toNamed(RouteName.home);
      } else {
        setState(() {
          emailErrorText = 'Email atau password salah';
          passwordErrorText = 'Email atau password salah';
        });
      }
      return user;
    } catch (e) {
      log('Error saat login: ${e.toString()}');

      Navigator.of(context).pop(); // Close the loading dialog

      setState(() {
        if (e is FirebaseAuthException) {
          if (e.code == 'user-not-found') {
            emailErrorText = 'Email tidak ditemukan';
          } else if (e.code == 'wrong-password') {
            passwordErrorText = 'Password salah';
          } else {
            emailErrorText = 'Email atau password salah';
            passwordErrorText = 'Email atau password salah';
          }
        }
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Login Gagal'),
            content: const Text('Email atau password salah.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return null;
    }
  }
}

class LoadingDialog extends StatelessWidget {
  const LoadingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
