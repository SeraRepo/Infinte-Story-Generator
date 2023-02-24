import 'package:flutter_tts/flutter_tts.dart';
import 'package:esp_app/models/signin_form_model.dart';
import 'package:esp_app/models/signup_form_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:esp_app/models/user_model.dart';

enum TtsState { playing, stopped, paused, continued }

class TtsProvider with ChangeNotifier {
  // late FlutterTts flutterTts;
  FlutterTts flutterTts = FlutterTts();
  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isPaused => ttsState == TtsState.paused;
  get isContinued => ttsState == TtsState.continued;
  initTts() {
    _setAwaitOptions();

    flutterTts.setStartHandler(() {
      print("Playing");
      ttsState = TtsState.playing;
      notifyListeners();
    });

    flutterTts.setCompletionHandler(() {
      print("Complete");
      ttsState = TtsState.stopped;
      notifyListeners();
    });

    flutterTts.setCancelHandler(() {
      print("Cancel");
      ttsState = TtsState.stopped;
      notifyListeners();
    });

    flutterTts.setPauseHandler(() {
      print("Paused");
      ttsState = TtsState.paused;
      notifyListeners();
    });

    flutterTts.setContinueHandler(() {
      print("Continued");
      ttsState = TtsState.continued;
      notifyListeners();
    });
  }

  //all platform
  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  Future pause() async {
    var result = await flutterTts.pause();
    if (result == 1) {
      ttsState = TtsState.paused;
      notifyListeners();
    }
  }

  Future stop() async {
    var result = await flutterTts.stop();
    if (result == 1) {
      ttsState = TtsState.stopped;
      notifyListeners();
    }
  }

  Future speak(text) async {
    await flutterTts.setVolume(0.5);
    await flutterTts.setLanguage("us-US");
    await flutterTts.setPitch(1.5);
    await flutterTts.speak(text);
    print("Speaking");
  }
}
