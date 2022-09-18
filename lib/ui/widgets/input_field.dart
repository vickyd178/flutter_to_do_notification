import 'package:flutter/material.dart';
import 'package:flutter_to_do/ui/theme.dart';
import 'package:get/get.dart';

class MyInputField extends StatelessWidget {
  final String title;
  final String initialTitle;
  final String hint;
  final TextEditingController controller;
  final Widget widget;

  const MyInputField({
    Key key,
    @required this.title,
    @required this.hint,
    this.initialTitle,
    this.controller,
    this.widget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: titleStyle,
          ),
          Container(
            margin: EdgeInsets.only(top: 8.0),
            padding: EdgeInsets.only(left: 14),
            height: 52,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1.0),
              borderRadius: BorderRadius.circular(12),
            ),
            child:  Row(
              children: [
                Expanded(child: TextFormField(
                  readOnly: widget==null?false:true,
                  autofocus: false,
                  cursorColor: Get.isDarkMode?Colors.grey[100]:Colors.grey[700],
                  controller: controller,
                  style: subTitleStyle,
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: subTitleStyle,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Get.isDarkMode?Themes.darkGreyClr:Colors.white
                      )
                    ),
                    enabledBorder:  UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Get.isDarkMode?Themes.darkGreyClr:Colors.white
                        )
                    ),
                  ),
                )),
                widget==null?Container():Container(child: widget,)
              ],
            ),
          ),

        ],
      ),
    );
  }
}
