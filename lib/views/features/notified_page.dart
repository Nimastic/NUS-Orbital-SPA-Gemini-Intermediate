import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotifiedPage extends StatelessWidget {
  final String? label;
  const NotifiedPage({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        backgroundColor: Colors.white,
        title: Text(label.toString().split("|")[0],
          style: const TextStyle(color: Colors.black))
      ),
      body: Center(
        child: Container(
          height: 400,
          width: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.grey[400]
          ),
          child: Text(label.toString().split("|")[1],
            style: const TextStyle(color: Colors.black))
        ),
      )
    );
  }
}