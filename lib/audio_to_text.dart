import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class voiceMessage extends StatefulWidget {
  const voiceMessage({super.key});

  @override
  State<voiceMessage> createState() => _voiceMessageState();
}

class _voiceMessageState extends State<voiceMessage> {
  SpeechToText speechToText = SpeechToText();

  var text = "Hold the button and start speaking";
  var isListening = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        endRadius: 75,
        animate: isListening,
        duration: Duration(milliseconds: 2000),
        glowColor: Colors.teal,
        repeat: true,
        repeatPauseDuration: Duration(milliseconds: 100),
        showTwoGlows: true,
        child: GestureDetector(
          onTapDown: (Details) async {
            if (!isListening) {
              var available = await speechToText.initialize();
              if (available) {
                setState(() {
                  isListening = true;
                  speechToText.listen(onResult: (result) {
                    setState(() {
                      text = result.recognizedWords;
                    });
                  });
                });
              }
            }
          },
          onTapUp: (Details) {
            setState(() {
              isListening = false;
            });
            speechToText.stop();
          },
          child: CircleAvatar(
            backgroundColor: Colors.teal,
            radius: 35,
            child: Icon(
              isListening ? Icons.mic : Icons.mic_none,
              color: Colors.white,
            ),
          ),
        ),
      ),
      appBar: AppBar(
        leading: Icon(Icons.sort_sharp),
        centerTitle: true,
        title: Text(
          'Now you have to voice record here',
          style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Italianno',fontSize: 37),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 400,
          width: double.infinity,
          child: Center(
              child: Text(
                text,
                style: TextStyle(fontFamily: 'Italianno',
                    fontSize: 40, color: isListening ? Colors.grey : Colors.black),
              )),
        ),
      ),
    );
  }
}
