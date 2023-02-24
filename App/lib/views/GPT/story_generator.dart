import 'dart:convert';
import 'package:provider/provider.dart';

import '../../models/button_tts_model.dart';
import '../../providers/tts_provider.dart';
import 'package:esp_app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:esp_app/models/secure_storage_model.dart';

class StoryGenerator extends StatefulWidget {
  final String tokenUser;
  const StoryGenerator({Key? key, required this.tokenUser}) : super(key: key);
  static String routeName = '/story_generator';

  @override
  _StoryGeneratorState createState() => _StoryGeneratorState();
}

class _StoryGeneratorState extends State<StoryGenerator> {
  final storage = const FlutterSecureStorage();
  final url = dotenv.env['API_URL']!;
  String token = "";
  final SecureStorage _secureStorage =
      SecureStorage(keyUserName: "", keyUserToken: "");

  String _story = 'Click the button to generate a story';

  @override
  initState() {
    super.initState();
    // getTokenFromSecureStorage();
  }

  void postData() async {
    try {
      final response = await post(Uri.parse(url + "/story"),
          body: json.encode({
            "story_name": "Stanley pirate",
            "story_tag": "",
            "params": [
              "Stanley is a pirate captain in the Caribeans in the 1600s. He is attacking a spanish treasure ship."
            ]
          }),
          headers: {
            'Content-Type': 'application/json',
            // 'x-access-token': widget.currentUser.token
            'x-access-token': widget.tokenUser,
          });

      Map<String, dynamic> responseData = json.decode(response.body);

      setState(() {
        _story = responseData['Story'];
      });
    } catch (err) {
      print(err);
    }
  }

  void ping() async {
    try {
      final response = await get(Uri.parse(url + "ping"));

      print(response.body);
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemWidth = size.width;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Welcome to the infinity of possibilities!'),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.all(3.0),
                child: ElevatedButton(
                  onPressed: postData,
                  child: const Text("Tell me a story"),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Text(_story),
                  )),
              Column(
                children: [
                  Container(
                    width: itemWidth / 2.5,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 254, 254, 252),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: _btnTts(),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _btnTts() {
    return Container(
      child: Row(children: [
        buildButtonTts(
            Colors.black,
            Colors.black,
            Icons.play_arrow,
            () =>
                Provider.of<TtsProvider>(context, listen: false).speak(_story)),
        buildButtonTts(Colors.black, Colors.black, Icons.stop,
            () => Provider.of<TtsProvider>(context, listen: false).stop()),
        buildButtonTts(Colors.black, Colors.black, Icons.pause,
            () => Provider.of<TtsProvider>(context, listen: false).pause()),
      ]),
    );
  }
}
