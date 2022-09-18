import 'package:flutter/material.dart';
import 'package:flutter_to_do/ui/theme.dart';

class MyButton extends StatelessWidget {
  final String label;
  final Function() onTap;

  const MyButton({
    Key key,
    this.label,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 110,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Themes.primaryClr),
        child: Text(
          label,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
