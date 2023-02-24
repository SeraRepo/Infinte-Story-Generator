import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:drop_shadow_image/drop_shadow_image.dart';
import 'package:http/http.dart' as http;
import '../../providers/tts_provider.dart';
import '../../models/button_tts_model.dart';

class ReadSelectedStory extends StatefulWidget {
  final int indexStory;
  const ReadSelectedStory({Key? key, required this.indexStory})
      : super(key: key);

  @override
  State<ReadSelectedStory> createState() => _ReadSelectedStoryState();
}

class _ReadSelectedStoryState extends State<ReadSelectedStory> {
  final url = dotenv.env['API_URL']!;
  String _story = '';

  @override
  void initState() {
    super.initState();
  }

  Future fetchStory() async {
    try {
      var response = await http
          .get(Uri.parse(url + "/story/" + widget.indexStory.toString()));

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        _story = responseData["story"]["Story"].toString();
      } else {
        throw Exception('Request Failed.');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    final double itemWidth = size.width;
    return Scaffold(
      body: FutureBuilder(
        future: fetchStory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              backgroundColor: const Color(0xfffbf9ee),
              body: Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: SingleChildScrollView(
                            child: Text(
                              _story,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            scrollDirection: Axis.vertical,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SizedBox(
                            height: 50,
                            width: itemWidth / 2.5,
                            child: Container(
                              width: itemWidth / 2.5,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 254, 254, 252),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: _btnTts(),
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
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
          () => Provider.of<TtsProvider>(context, listen: false).speak(_story),
        ),
        buildButtonTts(Colors.black, Colors.black, Icons.stop,
            () => Provider.of<TtsProvider>(context, listen: false).stop()),
        buildButtonTts(Colors.black, Colors.black, Icons.pause,
            () => Provider.of<TtsProvider>(context, listen: false).pause()),
      ]),
    );
  }
}
