import 'package:esp_app/views/GPT/story_generator.dart';
import 'package:esp_app/views/my_stories_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:esp_app/models/secure_storage_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:esp_app/models/bottom_navigation_bar_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);
  static String routeName = '/home';

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final SecureStorage _secureStorage =
      SecureStorage(keyUserName: "", keyUserToken: "");

  String token = "";

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future getTokenFromSecureStorage() async {
    var retrieveToken = await _secureStorage.getUserToken();
    setState(() {
      token = retrieveToken.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    getTokenFromSecureStorage();

    return (Scaffold(
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      //Navigation if _selectedIndex == 0 return home else return others pages
      body: _selectedIndex == 0
          ? Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                      )),
                  height: MediaQuery.of(context).size.height / 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hi Stan !',
                                style: GoogleFonts.poppins(
                                  fontSize: 32,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Wanna read our last story ?',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  height: 0.7,
                                  color: Colors.white70,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: SizedBox.fromSize(
                                  child: Image.asset(
                                    'assets/images/hp.jpg',
                                    fit: BoxFit.cover,
                                    width: 160,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Padding(
                                padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                child: Text(
                                  "Continue Reading",
                                  style:
                                      GoogleFonts.poppins(color: Colors.black),
                                ),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(10),
                                  primary: Colors.white,
                                  minimumSize: const Size.fromHeight(40),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, StoryGenerator.routeName,
                                      arguments: token);
                                },
                                child: Text(
                                  "New Story",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    height: 0.7,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(15),
                                  primary: Colors.white,
                                  minimumSize: const Size.fromHeight(40),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                          child: Text(
                            "Recent story",
                            style: GoogleFonts.poppins(
                              color: Colors.black54,
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: SizedBox.fromSize(
                              child: Image.asset(
                                'assets/images/hp.jpg',
                                fit: BoxFit.cover,
                                height: 150,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: SizedBox.fromSize(
                              child: Image.asset(
                                'assets/images/hp.jpg',
                                fit: BoxFit.cover,
                                height: 150,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: SizedBox.fromSize(
                              child: Image.asset(
                                'assets/images/hp.jpg',
                                fit: BoxFit.cover,
                                height: 150,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            )
          // else of the navigation
          : _selectedIndex == 1
              ? const MyStoriesView()
              : null,
    ));
  }
}
