import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SimpleOverlayLoader extends StatelessWidget {
  final String? text;
  const SimpleOverlayLoader({super.key, this.text});

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;

    return Container(
      height: Get.height,
      width: Get.width,
      color: Colors.white.withOpacity(0.2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Colors.black),
          const SizedBox(width: 10),
          Text(
            text ?? 'Loading ...',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
