import 'dart:convert';
import 'package:esp_app/views/home_view.dart';
import 'package:esp_app/views/selected_story_view.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:esp_app/views/GPT/story_generator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:esp_app/models/secure_storage_model.dart';
import 'package:http/http.dart' as http;

class MyStoriesView extends StatefulWidget {
  const MyStoriesView({Key? key}) : super(key: key);
  static String routeName = '/my_stories';

  @override
  State<MyStoriesView> createState() => _MyStoriesViewState();
}

class _MyStoriesViewState extends State<MyStoriesView> {
  final url = dotenv.env['API_URL']!;
  List<String> listStories = [];
  String token = "";

  final SecureStorage _secureStorage =
      SecureStorage(keyUserName: "", keyUserToken: "");

  @override
  void initState() {
    super.initState();
    getTokenFromSecureStorage();
  }

  Future getTokenFromSecureStorage() async {
    var retrieveToken = await _secureStorage.getUserToken();
    setState(() {
      token = retrieveToken.toString();
    });
  }

  Future<List<String>> fetchStories() async {
    var response = await http.get(Uri.parse(url + "/stories"));

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      for (var element in responseData["stories"]) {
        listStories.add(element["Story"].toString());
      }
      return listStories;
    } else {
      throw Exception('Request Failed.');
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 3;
    final double itemWidth = size.width / 2;

    return FutureBuilder(
      future: fetchStories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            children: [
              Row(mainAxisSize: MainAxisSize.min, children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(25, 25, 0, 0),
                    child: Text(
                      'All stories',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(25, 25, 0, 0),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(0, 255, 255, 255),
                        side: BorderSide.none,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: ((context) =>
                                StoryGenerator(tokenUser: token)),
                          ),
                        );
                      },
                      child: Text(
                        '+',
                        style: GoogleFonts.poppins(
                          fontSize: 30,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: GridView.count(
                    childAspectRatio: (itemWidth / itemHeight),
                    mainAxisSpacing: 30,
                    crossAxisSpacing: 5,
                    crossAxisCount: 3,
                    children: List.generate(listStories.length, (index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: ((context) =>
                                  SelectedStory(indexStory: index + 1)),
                            ),
                          );
                        },
                        child: const Image(
                          image: AssetImage('assets/images/hp.jpg'),
                          fit: BoxFit.cover,
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
