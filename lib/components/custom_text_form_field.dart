import 'package:admin_panel/constans/space.dart';
import 'package:admin_panel/constans/text.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.title,
    required this.controller,
    required this.hintText,
    required this.emailErrorText,
    this.obscureText = false,
    String? errorText,
  });

  final String title;
  final TextEditingController controller;
  final String hintText;
  final String? emailErrorText;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: bodyNB,
        ),
        space1,
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            hintText: hintText,
            errorText: emailErrorText,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Silahkan isi email';
            }
            return null;
          },
        ),
      ],
    );
  }
}
