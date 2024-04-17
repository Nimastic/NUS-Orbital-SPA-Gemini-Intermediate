import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:orbital_spa/models/chat_model.dart';
import 'package:orbital_spa/services/speech/commands.dart';
import 'package:url_launcher/url_launcher.dart';
import '../auth/data/repositories/auth_repository.dart';
import '../cloud/events/firebase_cloud_event_storage.dart';
import '../openai/openai_service.dart';
import 'dart:developer' as devtools show log;


final FlutterTts flutterTts = FlutterTts();

class Launcher {



 
  // Retrives text after the command, does not include text before command
  static String _getTextAfterCommand({
    required String text,
    required String command
  }) {
    final indexCommand = text.indexOf(command);
    final indexAfter = indexCommand + command.length;

    if (indexCommand == -1) {
      // Change to throw specific exception
      throw Exception();
    } else {
      // Returns remaining text
      return text.substring(indexAfter).trim();
    }
  }

  // Launches URl using external application
  static Future _launchUrl(String url) async {
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri, 
        mode: LaunchMode.externalApplication
      );
    }
  }


  // opens Email to send an email with the body provided
  static Future openEmail({
    required String body
  }) async {
    final url = 'mailto: ?body=${Uri.encodeFull(body)}';
    await _launchUrl(url);
  }

  // opens brower
  static Future openLink({
    required String url
  }) async {
    if (url.trim().isEmpty) {
      // throw exception 
      await _launchUrl('https://google.com');
    } else {
      await _launchUrl('https://$url');
    }
  }

  // open google search
  static Future openSearch({
    required String prompt
  }) async {
    if (prompt.trim().isEmpty) {
      //throw exception
      await _launchUrl('https://google.com');
    } else {
      String finalPrompt = prompt.replaceAll(' ', '+');
      await _launchUrl('https://www.google.com/search?q=$finalPrompt');
    }
  }

   // Function to check which command is being called
  static Future<List<ChatModel>> scantext(String rawText) async {
    final text = rawText.toLowerCase();
    devtools.log(text);

    try {

      if (text.contains(Commands.greet1)||text.contains(Commands.greet2)||text.contains(Commands.greet3)) {
        devtools.log('greet');

        flutterTts.speak('Hello! How can I assist you today?');
        return [ChatModel(
          msg: 'Hello! How can I assist you today?',
          chatIndex: 1
        )];
      }
      else if (text.contains(Commands.email1)||text.contains(Commands.email2)||text.contains(Commands.email3)) { 
        devtools.log('email');
        final body = _getTextAfterCommand(
          text: text,
          command: Commands.email1
        );
        openEmail(body: body);

        return [ChatModel(
          msg: 'Redirecting you to email', 
          chatIndex: 1
        )];

      // } else if (text.contains(Commands.search1)||text.contains(Commands.search2)||text.contains(Commands.search3)||
      //           text.contains(Commands.search4)||text.contains(Commands.search5)||text.contains(Commands.search6)||
      //           text.contains(Commands.search7)||text.contains(Commands.search8)) {
      //   openSearch(prompt: text);

      //   return 'Redirecting you to google';

      // } else if (text.contains(Commands.browser1)||text.contains(Commands.browser2)) {
      //   final url = _getTextAfterCommand(
      //     text: text,
      //     command: Commands.browser1
      //   );
      //   openLink(url: url);

      //   return 'Redirecting you to your browser';
      // } else if (text.contains(Commands.event1) || text.contains(Commands.event2)) {
        // final details = _getTextAfterCommand(
        //   text: text,
        //   command: Commands.event1
        // );

        // if (details.contains('from') && details.contains('to')) {
        //   String from = details.split('from')[1];
        // }



        // add_event(); //opens/add events
        // Get.to(() => const AddEventView());
      // } else if (text.contains(Commands.reminder1) || text.contains(Commands.reminder2)) {
        // final url = _getTextAfterCommand(
        //   text: text,
        //   command: Commands.task1
        // );
        // Get.to(() => const AddReminderView());
    //add_reminder(); //opens/add todolist
      } else {
        devtools.log('chatgpt');
          final OpenAIService openAIService = OpenAIService();

          String isEventInput = ' is "$text" an event. Answer only with yes or no.';
          String response1 = await openAIService.chatGPTAPI(isEventInput);

          if (response1.toLowerCase().contains('no')) {
            devtools.log('not event');
            String input = 'As a voice assistant, answer this query and keep your response short if possible: $text';
            String response = await openAIService.chatGPTAPI(input);

            flutterTts.speak(response);
            return [ChatModel(msg: response, chatIndex: 1)];
          } else {
            devtools.log('is event');

            String input = ''' what is the event title and date only in year-month-day-hour-minute using 24hour format only.
                                Answer like this:  
                                Event Title: Coffee date
                                Date: 2023-07-22 14:00
                                If there is no date, write null. If date is given in the form of the 
                                day of the week like tuesday, tell me the date of that day.
                                If a span of time is given, answer with:
                                Event Title:  
                                From: 
                                To: ''';
            
            String response1 = await openAIService.chatGPTAPI(input);
                                    
            final FirebaseCloudEventStorage eventService = FirebaseCloudEventStorage();
            final userId = AuthRepository.firebase().currentUser!.id;
            DateTime current = DateTime.now();

            devtools.log(response1);
            if (response1.contains('From: ')) {
              String title = response1.split('Event Title: ')[1].split('From: ')[0];
              String from = response1.split('From: ')[1].split('To: ')[0];
              String to = response1.split('From: ')[1].split('To: ')[1];
              devtools.log(from);
              devtools.log(to);

              final newEvent = await eventService.createNewEvent(ownerUserId: userId);

              await eventService.updateEvent(
                documentId: newEvent.documentId, 
                title: title, 
                description: '', 
                from: from, 
                to: to, 
                isAllDay: 0,
                doRemind: 0,
                remindAt: DateTime(current.year, current.month, current.day, 8, 0).subtract(const Duration(hours: 1)).toString(),
                uniqueId: UniqueKey().hashCode
              );
              flutterTts.speak("Event titled $title from $from to $to has been created");
              return [ChatModel(msg: "Event titled $title from $from to $to has been created", chatIndex: 1)];

            } else {
              String date = response1.split('Date: ')[1];
              DateTime? from = DateTime.tryParse(date);
              String title = response1.split('Event Title: ')[1].split('Date: ')[0];
              if (from == null) {
                final newEvent = await eventService.createNewEvent(ownerUserId: userId);
                DateTime from = DateTime(current.year, current.month, current.day, 8, 0);
                DateTime to = from.add(const Duration(hours: 2));

                await eventService.updateEvent(
                  documentId: newEvent.documentId, 
                  title: title, 
                  description: '', 
                  from: from.toString(), 
                  to: to.toString(), 
                  isAllDay: 0,
                  doRemind: 0,
                  remindAt: from.subtract(const Duration(hours: 1)).toString(),
                  uniqueId: UniqueKey().hashCode
                );
                flutterTts.speak("Event titled $title has been created");
                return [ChatModel(msg: "Event titled $title has been created", chatIndex: 1)];
              } else {
                final newEvent = await eventService.createNewEvent(ownerUserId: userId);
                DateTime to = DateTime.parse(date).add(const Duration(hours: 2));

                await eventService.updateEvent(
                  documentId: newEvent.documentId, 
                  title: title, 
                  description: '', 
                  from: date, 
                  to: to.toString(), 
                  isAllDay: 0,
                  doRemind: 0,
                  remindAt: DateTime(current.year, current.month, current.day, 8, 0).subtract(const Duration(hours: 1)).toString(),
                  uniqueId: UniqueKey().hashCode
                );
                flutterTts.speak("Event titled $title on $date has been created");
                return [ChatModel(msg: "Event titled $title on $date has been created", chatIndex: 1)];
              }
            }
          }

          // Check for event
          /*
          String isEventInput = "based on the sentence is this an event: $text, give a yes or no answer";
          String response1 = await openAIService.chatGPTAPI(isEventInput);
          devtools.log(response1);
          if (response1.contains('Yes')) {
            devtools.log('is event'); 
            
            final FirebaseCloudEventStorage eventService = FirebaseCloudEventStorage();
            final userId = AuthRepository.firebase().currentUser!.id;
            DateTime current = DateTime.now();
            String checkFields = ''' based on the sentence  $text, If this is an event, what is the event title and 
                                     date only in year-month-day-hour-minute 
                                     format using 24hour, answering only with 
                                     Event Title: [event title]  
                                     Date: [date] 
                                     If there is no date, write null. If date is given in the form of the day 
                                     of the week like tuesday, tell me the date of that day with no additional information.
                                     If a span of time is given, answer with:
                                     Event Title:  [event title]
                                     From: [date]
                                     To: [date]''';
            String response2 = await openAIService.chatGPTAPI(checkFields);
            devtools.log(response2);
            if (response2.contains('From: ')) {
              String title = response2.split('Event Title: ')[1].split('From: ')[0];
              String from = response2.split('From: ')[1].split('To: ')[0];
              String to = response2.split('From: ')[1].split('To: ')[1];
              devtools.log(from);
              devtools.log(to);

              final newEvent = await eventService.createNewEvent(ownerUserId: userId);

              await eventService.updateEvent(
                documentId: newEvent.documentId, 
                title: title, 
                description: '', 
                from: from, 
                to: to, 
                isAllDay: 0,
                doRemind: 0,
                remindAt: DateTime(current.year, current.month, current.day, 8, 0).subtract(const Duration(hours: 1)).toString(),
                uniqueId: UniqueKey().hashCode
              );
              flutterTts.speak("Event titled $title from $from to $to has been created");
              return "Event titled $title from $from to $to has been created";

            } else {
              String date = response2.split('Date: ')[1];
              String title = response2.split('Event Title: ')[1].split('Date: ')[0];
              if (date == "null") {
                final newEvent = await eventService.createNewEvent(ownerUserId: userId);
                DateTime from = DateTime(current.year, current.month, current.day, 8, 0);
                DateTime to = from.add(const Duration(hours: 2));

                await eventService.updateEvent(
                  documentId: newEvent.documentId, 
                  title: title, 
                  description: '', 
                  from: from.toString(), 
                  to: to.toString(), 
                  isAllDay: 0,
                  doRemind: 0,
                  remindAt: from.subtract(const Duration(hours: 1)).toString(),
                  uniqueId: UniqueKey().hashCode
                );
                flutterTts.speak("Event titled $title has been created");
                return "Event titled $title has been created";
              } else {
                final newEvent = await eventService.createNewEvent(ownerUserId: userId);
                DateTime to = DateTime.parse(date).add(const Duration(hours: 2));

                await eventService.updateEvent(
                  documentId: newEvent.documentId, 
                  title: title, 
                  description: '', 
                  from: date, 
                  to: to.toString(), 
                  isAllDay: 0,
                  doRemind: 0,
                  remindAt: DateTime(current.year, current.month, current.day, 8, 0).subtract(const Duration(hours: 1)).toString(),
                  uniqueId: UniqueKey().hashCode
                );
                flutterTts.speak("Event titled $title on $date has been created");
                return "Event titled $title on $date has been created";
              }
            }
          } else {
            devtools.log('not event');
            String input = 'As a voice assistant, answer this and keep your response short if possible: $text';
            String response = await openAIService.chatGPTAPI(input);
            flutterTts.speak(response);
            return response;
          }
          */


          

      }
    } on Exception catch (e) {
      // Deal with exception
      devtools.log(e.toString());
      throw Error();
    }
  }

  

}