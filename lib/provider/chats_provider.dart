import 'package:flutter/cupertino.dart';
import 'package:orbital_spa/services/speech/assistant_url_launcher.dart';

import '../models/chat_model.dart';


class ChatProvider with ChangeNotifier {
  List<ChatModel> chatList = [];
  List<ChatModel> get getChatList {
    return chatList;
  }

  void addUserMessage({required String msg}) {
    chatList.add(ChatModel(msg: msg, chatIndex: 0));
    notifyListeners();
  }

  Future<void> sendMessageAndGetAnswers(
      {required String msg, required String chosenModelId}) async {
    // if (chosenModelId.toLowerCase().startsWith("gpt")) {
      chatList.addAll(
        // await OpenAIService().sendMessageGPT(
        // message: msg,
        // modelId: chosenModelId,
        //)
        await Launcher.scantext(msg)
      
      );
    // } else {
    //   chatList.addAll(await OpenAIService().sendMessage(
    //     message: msg,
    //     modelId: chosenModelId,
    //   ));
    // }
    notifyListeners();
  }
}
