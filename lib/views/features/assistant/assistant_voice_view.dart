import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:orbital_spa/services/speech/assistant_url_launcher.dart';
import 'package:orbital_spa/services/speech/sst_listen.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'dart:developer' as devtools show log;

class AssistantVoiceView extends StatefulWidget {
  const AssistantVoiceView({super.key});

  @override
  State<AssistantVoiceView> createState() => _AssistantVoiceViewState();
}

class _AssistantVoiceViewState extends State<AssistantVoiceView> {

  final speechToText = SpeechToText();
  bool isListening = false;
  String text = "Hold the button and start speaking";
  // final OpenAIService openAIService = OpenAIService();
  final textToSpeech = FlutterTts();


  @override
  void initState() {
    super.initState();
    initTextToSpeech();
  }

  @override
  void dispose() {
    super.dispose();
    textToSpeech.stop();
  }

  
  /// Text to speech functions

  Future<void> initTextToSpeech() async {
    setState(() {});
  }
   
  Future<void> systemSpeak(String content) async {
    await textToSpeech.speak(content);
  }

  // Speech to text functions

  void onListening(bool isListening) {
    devtools.log('onListening');
    setState(() {
      if (this.isListening != isListening) {
        this.isListening = isListening;
        devtools.log(isListening.toString());
      } else {
        if (!isListening) {
      Future.delayed(const Duration(seconds: 1), () {
        devtools.log('scan');
        Launcher.scantext(text);
      });
    }
      }
    });

    // if (!isListening) {
    //   Future.delayed(const Duration(seconds: 1), () {
    //     devtools.log('scan');
    //     Launcher.scantext(text);
    //   });
    // }
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Assistant'),
        centerTitle: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      
      // Button to start voice commands when held down
      floatingActionButton: AvatarGlow(
        endRadius: 75.0,
        animate: isListening,
        duration: const Duration(seconds: 2),
        glowColor: Colors.purple,
        repeat: true,
        repeatPauseDuration: const Duration(milliseconds: 100),
        showTwoGlows: true,
        child: GestureDetector(

          // // Start listening when user holds the button down
          // onTapDown: (details) async {
          //   if (!isListening) {
          //     await initSpeechToText();
          //     if (available) {
          //       setState(() {
          //         isListening = true;
          //         startListening();
          //       });
          //     }
          //   }
          // },

          // onTapDown: (details) {
          //   startListening();
          // },
          onLongPressDown: (details) {
            startListening();
          },

          // Stops listening when the user lets go of the button
          // onTapUp: (details) {
          //   setState(() {
          //     isListening = false;
          //   });
          //   stopListening();
          // },
          onTapUp: (details) {
            stopListening();
          },
          child: CircleAvatar(
            radius: 35,
            child: Icon(isListening ? Icons.mic : Icons.mic_none),
          ),
        ),
      ),
      



      body: Column(
        children: [
          //image of assistant
          const Center(
            child: SizedBox(
              width: 250,
              height: 300,
              child: FittedBox(
                child: Icon(Icons.android)
              )
            ),
          ),

          SingleChildScrollView(
            reverse: true,
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 25
              )
            )
          )
        ],
      )
    );


  }
}
