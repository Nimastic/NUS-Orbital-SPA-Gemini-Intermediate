import 'package:flutter/material.dart';

import '../../../constants/images_strings.dart';
import '../../../constants/theme.dart';

class MainPageHeader extends StatelessWidget {
  const MainPageHeader({
    super.key,
    required this.context,
    required this.name,
    required this.todo,
  });

  final BuildContext context;
  final String name;
  final int todo;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
      height: 170,
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFFfcecf4) ,
            Color(0xFFecf4fc)
          ]
        )
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, $name',
                style: headerNameStyle,
              ),
              Visibility(
                visible: !(todo == 0), // if there are pending tasks
                child: Text(
                  '$todo tasks pending',
                  style: headerTaskStyle,
                ),
              ),
              Visibility(
                visible: (todo == 0), // if there are no pending tasks
                child: Text(
                  'No pending tasks :)',
                  style: headerTaskStyle,
                ),
              )
            ],
          ),
          const Spacer(),
          Transform.scale(
            scale: 2,
            child: const Image(
              image: AssetImage(mainPageImage), 
            ),
          ),
        ],
      ),
    );
  }
}