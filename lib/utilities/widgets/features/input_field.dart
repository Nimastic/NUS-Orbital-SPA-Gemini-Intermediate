import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants/theme.dart';

class MyInputField extends StatelessWidget {

  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;
  final double height;

  const MyInputField({
    super.key, 
    required this.title, 
    required this.hint, 
    this.controller, 
    this.widget,
    required this.height
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: titleStyle
          ),
          Container(
            height: height,
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.only(left: 14),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey[200]!,
                width: 1.0
              ),
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[200]
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 5,
                    readOnly: widget == null ? false : true,
                    autofocus: false,
                    // cursorColor: Get.isDarkMode ? Colors.grey[100] : Colors.grey[700],
                    cursorColor: Colors.grey[700],
                    controller: controller,
                    style: hintStyle,
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: hintStyle,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: context.theme.colorScheme.background,
                          width: 0
                        )
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: context.theme.colorScheme.background,
                          width: 0
                        )
                      )
                    ),
                  ),
                ),
                widget == null ? Container() : Container(child: widget)
              ],
            )
          )
        ],
      ),
    );
  }
}