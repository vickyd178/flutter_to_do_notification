import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotifiedPage extends StatelessWidget {
  final String label;

  const NotifiedPage({Key key, this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.label.split("|")[0]),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(8),
          height: 400,
          width: 300,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Get.isDarkMode ? Colors.white : Colors.grey[400]),
              child: Text(
            this.label.split("|")[1],
            style: TextStyle(
              color: Get.isDarkMode ? Colors.black : Colors.white,
              fontSize: 24
            ),
          )),
        ),
    );
  }
}
