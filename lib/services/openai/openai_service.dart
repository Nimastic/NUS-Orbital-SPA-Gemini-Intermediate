import 'dart:convert';
import 'dart:developer' as devtools show log;
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../models/chat_model.dart';
import 'apikey.dart';

class OpenAIService {

  final List<Map<String, String>> messages = [];

  Future<String> chatGPTAPI(String prompt) async {
    messages.add({
      'role': 'user',
      'content': prompt
    });

    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          "Content-Type" : "application/json",
          "Authorization" : "Bearer $apiKey"
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": messages
        })
      );

      if (response.statusCode == 200) {
        String content = jsonDecode(response.body)['choices'][0]['message']['content'];
        content = content.trim();

        messages.add({
          'role': 'assistant',
          'content': content
        });
        return content;
      } else {
        devtools.log(response.statusCode.toString());
        return ('An internal error has occured');
      }
       
    } catch (e) {
      return e.toString();
    }
  }

  // Send Message using ChatGPT API
  Future<List<ChatModel>> sendMessageGPT(
      {required String message, required String modelId}) async {
    try {
      log("modelId $modelId");
      var response = await http.post(
        Uri.parse("https://api.openai.com/v1/chat/completions"),
        headers: {
          'Authorization': 'Bearer $apiKey',
          "Content-Type": "application/json"
        },
        body: jsonEncode(
          {
            "model": modelId,
            "messages": [
              {
                "role": "user",
                "content": message,
              }
            ]
          },
        ),
      );

      // Map jsonResponse = jsonDecode(response.body);
      Map jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      if (jsonResponse['error'] != null) {
        // print("jsonResponse['error'] ${jsonResponse['error']["message"]}");
        throw HttpException(jsonResponse['error']["message"]);
      }
      List<ChatModel> chatList = [];
      if (jsonResponse["choices"].length > 0) {
        // log("jsonResponse[choices]text ${jsonResponse["choices"][0]["text"]}");
        chatList = List.generate(
          jsonResponse["choices"].length,
          (index) => ChatModel(
            msg: jsonResponse["choices"][index]["message"]["content"],
            chatIndex: 1,
          ),
        );
      }
      return chatList;
    } catch (error) {
      log("error $error");
      rethrow;
    }
  }
}