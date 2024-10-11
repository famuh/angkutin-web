import 'dart:developer';

import 'package:admin_panel/services/employee_service.dart';
import 'package:flutter/material.dart';

import '../constans/space.dart';

void updateEmployeeDialog(BuildContext context, String docID, String name,
    String email, int phone, String address) {
  final TextEditingController nameController =
      TextEditingController(text: name);
  final TextEditingController emailController =
      TextEditingController(text: email);
  final TextEditingController phoneController =
      TextEditingController(text: phone.toString());
  final TextEditingController addressController =
      TextEditingController(text: address);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Update User'),
        content: SingleChildScrollView(
          child: SizedBox(
            width: 500,
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nama'),
                ),
                space2,
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                space2,
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Nomor Telepon'),
                  keyboardType: TextInputType.number,
                ),
                space2,
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(labelText: 'Wilayah'),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              int phoneParse = int.tryParse(phoneController.text) ?? 0;
              EmployeeService()
                  .update(docID.toString(), nameController.text,
                      emailController.text, phoneParse, addressController.text)
                  .then((_) {
                Navigator.of(context).pop();
                log('User updated successfully');
              }).catchError((error) {
                log('Failed to update user: $error');
              });
            },
            child: const Text('Simpan'),
          ),
        ],
      );
    },
  );
}
