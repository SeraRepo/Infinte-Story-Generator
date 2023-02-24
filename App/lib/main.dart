import 'package:esp_app/models/user_model.dart';
import 'package:esp_app/providers/auth_provider.dart';
import 'package:esp_app/providers/tts_provider.dart';
import 'package:esp_app/providers/user_provider.dart';
import 'package:esp_app/views/home_view.dart';
import 'package:esp_app/views/my_stories_view.dart';
import 'package:esp_app/views/auth/sign_in.dart';
import 'package:esp_app/views/auth/sign_up.dart';
import 'package:esp_app/views/not_found_view.dart';
import 'package:esp_app/views/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'views/auth_view.dart';
import './views/not_found_view.dart';
import './views/GPT/story_generator.dart';

Future<void> main() async {
  await dotenv.load();
  runApp(const MyAuth());
}

class MyAuth extends StatefulWidget {
  const MyAuth({Key? key}) : super(key: key);

  @override
  _MyAuthState createState() => _MyAuthState();
}

class _MyAuthState extends State<MyAuth> {
  final AuthProvider authProvider = AuthProvider();
  final UserProvider userProvider = UserProvider();
  final TtsProvider ttsProvider = TtsProvider();

  User userDebug = User(
      username: "username",
      password: "password",
      email: "email",
      stories: [],
      token: "token",
      id: 1);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider.value(value: userProvider),
        ChangeNotifierProvider.value(value: ttsProvider)
      ],
      child: MaterialApp(
        title: 'my auth',
        theme: ThemeData(primaryColor: Colors.blue),
        home: const AuthView(),
        onGenerateRoute: (settings) {
          if (settings.name == SigninView.routeName) {
            return MaterialPageRoute(builder: (context) => const SigninView());
          } else if (settings.name == SignUpView.routeName) {
            return MaterialPageRoute(builder: (context) => const SignUpView());
          } else if (settings.name == HomeView.routeName) {
            return MaterialPageRoute(builder: (context) => const HomeView());
          } else if (settings.name == ProfileView.routeName) {
            return MaterialPageRoute(builder: (context) => const ProfileView());
          } else if (settings.name == MyStoriesView.routeName) {
            return MaterialPageRoute(
                builder: (context) => const MyStoriesView());
          } else if (settings.name == StoryGenerator.routeName) {
            final args = settings.arguments.toString();
            return MaterialPageRoute(
              builder: (context) {
                return StoryGenerator(
                  tokenUser: args,
                );
              },
            );
          } else {
            return null;
          }
        },
        onUnknownRoute: (settings) =>
            MaterialPageRoute(builder: (context) => const NotFoundView()),
      ),
    );
  }
}
