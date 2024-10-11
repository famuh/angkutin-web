import 'dart:developer';

import 'package:admin_panel/components/text_field.dart';
import 'package:admin_panel/data/zone.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constans/color.dart';

import '../components/buttons.dart';
import '../controllers/zone_controller.dart';

void addDataDialog(BuildContext context) {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final TextEditingController nameC = TextEditingController();
  final TextEditingController fullNameC = TextEditingController();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController phoneControllerC = TextEditingController();

  final ZoneDropDownController dropdownController =
      Get.put(ZoneDropDownController());

  Future<void> saveUserData() async {
    final email = emailC.text;
    final activePhoneNumber = int.tryParse(phoneControllerC.text);

    try {
      final userDoc = await firestore.collection('users').doc(email).get();

      if (userDoc.exists) {
        log('USER EXIST');
        Get.snackbar('Peringatan!', 'Email sudah dipakai');
      } else {
        await firestore.collection('users').doc(email).set({
          'name': nameC.text,
          'email': email,
          'activePhoneNumber': activePhoneNumber,
          'fullName': fullNameC.text,
          'role': 'Petugas',
          'latitude': 0.1,
          'longitude': 0.1,
          'services': [],
          'address': dropdownController.selectedItem.value,
        });
        Get.snackbar('Horee',
            'Data berhasil disimpan, tinggal suruh drivernya untuk login dari aplikasi ya');
      }
    } catch (e) {
      log('error: $e');
    }
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: white,
        title: const Text('Daftarkan Petugas Baru'),
        content: Container(
          width: 400,
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              CustomTextField(
                controller: nameC,
                title: 'Nama',
                hintText: 'Nama petugas',
              ),
              CustomTextField(
                controller: fullNameC,
                title: 'Nama Lengkap',
                hintText: 'Nama lengkap petugas',
              ),
              CustomTextField(
                controller: emailC,
                title: 'Email',
                hintText: 'Daftarkan email petugas',
              ),
              CustomTextField(
                controller: phoneControllerC,
                title: 'Nomor Telepon',
                hintText: 'Daftarkan Nomor Telepon petugas',
                keyboardType: TextInputType.number,
              ),
              Obx(() => DropdownButton(
                    value: dropdownController.selectedItem.value.isEmpty
                        ? null
                        : dropdownController.selectedItem.value,
                    hint: const Text('Pilih Zona'),
                    items: ZoneData.items.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (value) {
                      dropdownController.selectedItem(value);
                    },
                  )),
            ],
          ),
        ),
        actions: <Widget>[
          LargeButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            text: 'Batal',
          ),
          LargeButton(
            onPressed: () async {
              saveUserData();
              Get.back();
            },
            text: 'Daftarkan',
          ),
        ],
      );
    },
  );
}
