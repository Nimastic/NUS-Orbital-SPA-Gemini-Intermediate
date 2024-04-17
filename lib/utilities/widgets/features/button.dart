import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {

  final String label;
  final Function()? onTap;
  final Color innerColour;
  final Color borderColor;
  final Color fontColor;

  const MyButton({
    super.key, 
    required this.label, 
    required this.onTap, 
    required this.innerColour, 
    required this.borderColor, 
    required this.fontColor
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: 120,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: innerColour,
          border: Border.all(
            color: borderColor
            //width
          )
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'GT Walsheim',
            fontSize: 18,
            color: fontColor
          )
        )
      )
    );
  }
}