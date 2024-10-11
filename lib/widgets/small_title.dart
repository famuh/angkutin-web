import 'package:admin_panel/constans/color.dart';
import 'package:flutter/material.dart';

import '../constans/text.dart';

class SmallTitleSection extends StatelessWidget {
  String title;
  SmallTitleSection({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: bodyNB.copyWith(fontWeight: FontWeight.w600, color: primary),
    );
  }
}
