// ignore_for_file: duplicate_import

import 'dart:developer';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:orbital_spa/constants/colours.dart';
import 'package:orbital_spa/constants/theme.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../../../constants/images_strings.dart';
import '../../../provider/chats_provider.dart';
import '../../../provider/models_provider.dart';
import '../../../services/speech/sst_listen.dart';
import '../../../utilities/widgets/assistant/chat_widget.dart';
import '../../../utilities/widgets/assistant/text_widget.dart';

class AssistantChatView extends StatefulWidget {
  const AssistantChatView({super.key});

  @override
  State<AssistantChatView> createState() => _AssistantChatViewState();
}

class _AssistantChatViewState extends State<AssistantChatView> {
  bool _isTyping = false;

  late TextEditingController textEditingController;
  late ScrollController _listScrollController;
  late FocusNode focusNode;

  final speechToText = SpeechToText();
  bool isListening = false;
  String text = "";

  @override
  void initState() {
    _listScrollController = ScrollController();
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _listScrollController.dispose();
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: const Icon(Icons.arrow_back_ios)
      ),
      // Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: Image.asset(openaiLogo),
      // ),
      title: Text(
        "SPA Assistant",
        style: pageHeaderStyle
      ),
      centerTitle: true,
      backgroundColor: background,
      // actions: [
      //   IconButton(
      //     onPressed: () async {
      //       await AssistantBottomSheet.showModalSheet(context: context);
      //     },
      //     icon: const Icon(Icons.more_vert_rounded, color: Color.fromARGB(255, 132, 0, 255)),
      //   ),
      // ],
    );
  }

  SafeArea _chatBox(ChatProvider chatProvider, ModelsProvider modelsProvider) {
    return SafeArea(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                  controller: _listScrollController,
                  itemCount: chatProvider.getChatList.length, //chatList.length,
                  itemBuilder: (context, index) {
                    return ChatWidget(
                      msg: chatProvider
                          .getChatList[index].msg, // chatList[index].msg,
                      chatIndex: chatProvider.getChatList[index]
                          .chatIndex, //chatList[index].chatIndex,
                      shouldAnimate:
                          chatProvider.getChatList.length - 1 == index,
                    );
                  }),
            ),


            if (_isTyping) ...[
              const SpinKitThreeBounce(
                color: lightPurple,
                size: 18,
              ),
            ],
            const SizedBox(
              height: 15,
            ),


            Material(
              color: lightBlue,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        focusNode: focusNode,
                        style: const TextStyle(
                          fontFamily: 'GT Walsheim',
                          color: black
                        ),
                        controller: textEditingController,
                        decoration: const InputDecoration.collapsed(
                            hintText: "How can I help you",
                            hintStyle: TextStyle(color: Color.fromARGB(255, 49, 49, 49))),
                      ),
                    ),
                    AvatarGlow(
                      endRadius: 30.0,
                      animate: isListening,
                      duration: const Duration(seconds: 2),
                      glowColor: Colors.purple,
                      repeat: true,
                      repeatPauseDuration: const Duration(milliseconds: 100),
                      showTwoGlows: true,
                      child: GestureDetector(
                        onLongPressDown: (details) {
                          startListening();
                        },
                        onTapUp: (details) async {
                          stopListening();
                        },
                        child: Icon(isListening ? Icons.mic : Icons.mic_none, size: 28)
                      ),
                    ),
                    const SizedBox(width: 3,),
                    IconButton(
                        onPressed: () async {
                          await sendMessageFCT(
                            modelsProvider: modelsProvider,
                            chatProvider: chatProvider,
                            isTyped: true
                          );
                        },
                        icon: const Icon(
                          Icons.send,
                          color: black,
                        ))
                  ],
                ),
              ),
            ),
          ],
        ),
      );
  }


  void scrollListToEND() {
    _listScrollController.animateTo(
        _listScrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 2),
        curve: Curves.easeOut);
  }

  Future<void> sendMessageFCT({
    required ModelsProvider modelsProvider,
    required ChatProvider chatProvider,
    required bool isTyped
  }) async {
    if (_isTyping) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: "You cant send multiple messages at a time",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (textEditingController.text.isEmpty && isTyped || text.isEmpty && !isTyped) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: TextWidget(
            label: "Please type a message",
          ),
          backgroundColor: lightPink,
        ),
      );
      return;
    }
    try {
      String msg = textEditingController.text;
      setState(() {
        _isTyping = true;
        chatProvider.addUserMessage(msg: msg);
        textEditingController.clear();
        focusNode.unfocus();
      });
      await chatProvider.sendMessageAndGetAnswers(
          msg: msg, chosenModelId: modelsProvider.getCurrentModel);
      setState(() {});
    } catch (error) {
      log("error $error");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: TextWidget(
          label: error.toString(),
        ),
        backgroundColor: lightPink,
      ));
    } finally {
      setState(() {
        scrollListToEND();
        _isTyping = false;
      });
    }
  }

  // Speech to text functions

  void onListening(bool isListening) async {
    // devtools.log('onListening');
    setState(() {
      if (this.isListening != isListening) {
        this.isListening = isListening;
        // devtools.log(isListening.toString());
      } else {
        if (!isListening) {
          Future.delayed(const Duration(seconds: 1), () async {
            setState(() {
              textEditingController.text = text;
              this.isListening = isListening;
            });
            final modelsProvider = Provider.of<ModelsProvider>(context, listen: false);
            final chatProvider = Provider.of<ChatProvider>(context, listen: false);
            await sendMessageFCT(
              modelsProvider: modelsProvider,
              chatProvider: chatProvider,
              isTyped: false
            );

          });
        }
      }
    });
  }

  Future startListening() {
    return SstListen.startListening(
      onResult: (text) { 
        if (this.text != text) {
          this.text = text;
        }
      }, 
      onListening: onListening
    );
  }

  void stopListening() => SstListen.stopListening(onListening: onListening);



  @override
  Widget build(BuildContext context) {
    
    final modelsProvider = Provider.of<ModelsProvider>(context);
    final chatProvider = Provider.of<ChatProvider>(context);

    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(mainPageBackground),
          fit: BoxFit.cover
        ),
      ),
      child: Scaffold(
        backgroundColor: transparent,
        appBar: _appBar(),
        body: _chatBox(chatProvider, modelsProvider),
      ),
    );
  }
}
