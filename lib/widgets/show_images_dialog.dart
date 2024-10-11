import 'package:flutter/material.dart';
import 'package:image_network/image_network.dart';

void showImage(BuildContext context, String imageUrl) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: imageUrl.isNotEmpty
            ? ImageNetwork(
                image: imageUrl,
                height: 400,
                width: 400,
                fitWeb: BoxFitWeb.fill,
              )
            : const Text('Gagal memuat gambar'),
      );
    },
  );
}
