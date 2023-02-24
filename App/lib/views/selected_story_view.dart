import 'package:esp_app/views/read_selected_story_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:drop_shadow_image/drop_shadow_image.dart';
import 'package:http/http.dart' as http;

class SelectedStory extends StatefulWidget {
  final int indexStory;
  const SelectedStory({Key? key, required this.indexStory}) : super(key: key);

  @override
  State<SelectedStory> createState() => _SelectedStoryState();
}

class _SelectedStoryState extends State<SelectedStory> {
  final url = dotenv.env['API_URL']!;
  String _story = '';

  @override
  void initState() {
    super.initState();
  }

  Future fetchStory() async {
    var response = await http
        .get(Uri.parse(url + "/story/" + widget.indexStory.toString()));

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      _story = responseData["story"]["Story"].toString();
    } else {
      throw Exception('Request Failed.');
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemWidth = size.width;
    return Scaffold(
      body: FutureBuilder(
        future: fetchStory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              body: Stack(
                children: [
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(0, 255, 255, 255),
                            side: BorderSide.none,
                          ),
                          onPressed: (() {
                            Navigator.pop(context);
                          }),
                          child: const Icon(Icons.arrow_back,
                              color: Colors.black, size: 30.0),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: ClipRRect(
                            // borderRadius: BorderRadius.circular(30.0),
                            child: SizedBox.fromSize(
                              child: Container(
                                width: 250,
                                child: DropShadowImage(
                                  offset: const Offset(0, 3),
                                  scale: 1,
                                  blurRadius: 12,
                                  borderRadius: 12,
                                  image: Image.asset(
                                    'assets/images/hp.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
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
                          width: itemWidth,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 20,
                              backgroundColor: Colors.deepPurple,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: ((context) => (ReadSelectedStory(
                                        indexStory: widget.indexStory,
                                      ))),
                                ),
                              );
                            },
                            child: Text(
                              'Read',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
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
}
