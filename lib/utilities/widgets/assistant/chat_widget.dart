import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:orbital_spa/constants/colours.dart';
import '../../../constants/images_strings.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget(
      {super.key,
      required this.msg,
      required this.chatIndex,
      this.shouldAnimate = false});

  final String msg;
  final int chatIndex;
  final bool shouldAnimate;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: chatIndex == 0 ? [lightPurple, background] : [lightOrange, background]),
            borderRadius: BorderRadius.circular(10)
          ),
          // color: chatIndex == 0 ? lightPurple : lightOrange,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  chatIndex == 0
                      ? user3Image
                      : bot2Image,
                  height: 30,
                  width: 30,
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: chatIndex == 0
                      ? Text(
                        msg,
                        style: const TextStyle(
                          color: black,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          fontFamily: 'GT Walsheim'
                        )
                      )
                      // TextWidget(
                      //     label: msg,
                      //   )
                      : shouldAnimate
                          ? DefaultTextStyle(
                              style: const TextStyle(
                                color: black,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                fontFamily: 'GT Walsheim'
                              ),
                              child: AnimatedTextKit(
                                  isRepeatingAnimation: false,
                                  repeatForever: false,
                                  displayFullTextOnTap: true,
                                  totalRepeatCount: 1,
                                  animatedTexts: [
                                    TyperAnimatedText(
                                      msg.trim(),
                                    ),
                                  ]),
                            )
                          : Text(
                              msg.trim(),
                              style: const TextStyle(
                                  color: black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  fontFamily: 'GT Walsheim'
                                ),
                            ),
                ),
                chatIndex == 0
                    ? const SizedBox.shrink()
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.thumb_up_alt_outlined,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.thumb_down_alt_outlined,
                            color: Colors.white,
                          )
                        ],
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
